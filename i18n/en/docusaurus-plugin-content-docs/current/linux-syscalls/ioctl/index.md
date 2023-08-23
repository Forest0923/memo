---
title: "ioctl"
description: "NR = 16"
tags: [
  "Linux", "System Calls"
]
---

## Version

- Linux v5.8.13

## Abstract

```c
long sys_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg);
```

- sys_ioctl()
  - ksys_ioctl()
    - security_file_ioctl()
    - do_vfs_ioctl()

## Arguments

## Return

## Definitions

### `sys_ioctl()`

- fs/ioctl.c

```c
SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
{
	return ksys_ioctl(fd, cmd, arg);
}
```

### `ksys_ioctl()`

- fs/ioctl.c

```c
int ksys_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
{
	struct fd f = fdget(fd);
	int error;

	if (!f.file)
		return -EBADF;

	error = security_file_ioctl(f.file, cmd, arg);
	if (error)
		goto out;

	error = do_vfs_ioctl(f.file, fd, cmd, arg);
	if (error == -ENOIOCTLCMD)
		error = vfs_ioctl(f.file, cmd, arg);

out:
	fdput(f);
	return error;
}
```

### `do_vfs_ioctl()`

- fs/ioctl.c

```c
/*
 * do_vfs_ioctl() is not for drivers and not intended to be EXPORT_SYMBOL()'d.
 * It's just a simple helper for sys_ioctl and compat_sys_ioctl.
 *
 * When you add any new common ioctls to the switches above and below,
 * please ensure they have compatible arguments in compat mode.
 */
static int do_vfs_ioctl(struct file *filp, unsigned int fd,
			unsigned int cmd, unsigned long arg)
{
	void __user *argp = (void __user *)arg;
	struct inode *inode = file_inode(filp);

	switch (cmd) {
	case FIOCLEX:
		set_close_on_exec(fd, 1);
		return 0;

	case FIONCLEX:
		set_close_on_exec(fd, 0);
		return 0;

	case FIONBIO:
		return ioctl_fionbio(filp, argp);

	case FIOASYNC:
		return ioctl_fioasync(fd, filp, argp);

	case FIOQSIZE:
		if (S_ISDIR(inode->i_mode) || S_ISREG(inode->i_mode) ||
		    S_ISLNK(inode->i_mode)) {
			loff_t res = inode_get_bytes(inode);
			return copy_to_user(argp, &res, sizeof(res)) ?
					    -EFAULT : 0;
		}

		return -ENOTTY;

	case FIFREEZE:
		return ioctl_fsfreeze(filp);

	case FITHAW:
		return ioctl_fsthaw(filp);

	case FS_IOC_FIEMAP:
		return ioctl_fiemap(filp, argp);

	case FIGETBSZ:
		/* anon_bdev filesystems may not have a block size */
		if (!inode->i_sb->s_blocksize)
			return -EINVAL;

		return put_user(inode->i_sb->s_blocksize, (int __user *)argp);

	case FICLONE:
		return ioctl_file_clone(filp, arg, 0, 0, 0);

	case FICLONERANGE:
		return ioctl_file_clone_range(filp, argp);

	case FIDEDUPERANGE:
		return ioctl_file_dedupe_range(filp, argp);

	case FIONREAD:
		if (!S_ISREG(inode->i_mode))
			return vfs_ioctl(filp, cmd, arg);

		return put_user(i_size_read(inode) - filp->f_pos,
				(int __user *)argp);

	default:
		if (S_ISREG(inode->i_mode))
			return file_ioctl(filp, cmd, argp);
		break;
	}

	return -ENOIOCTLCMD;
}
```

## わからない部分

KVM の VM 作成などに ioctl を使うが，sys_ioctl のコードを読んでも KVM_CREATE_VM の処理などは書かれていない．

モジュール用の ioctl のハンドラはそのモジュール内で定義されるが，どうやってそこに飛んでいるのか今のところわかっていない．

以下は KVM_CREATE_VM のマクロを追ったときのメモ．

```c
#define KVMIO 0xAE

# define _IOC_NONE	0U

#define _IOC(dir,type,nr,size) \
	(((dir)  << 0+8+8+14) | \
	 ((type) << 0+8) | \
	 ((nr)   << 0) | \
	 ((size) << 0+8+8))

#define _IO(type,nr)		_IOC(_IOC_NONE,(type),(nr),0)

#define KVM_CREATE_VM   _IO(KVMIO,   0x01)
```

```c
#define KVM_CREATE_VM   _IOC(0U,(0xAE),(0x01),0)
```

```c
#define KVM_CREATE_VM   (((0)     << 30) | \
                         ((0xAE)  <<  8) | \
                         ((0x01)  <<  0) | \
                         ((0)     << 16))
```

```text
0000 0000 0000 0000
1010 1110 0000 0000
0000 0000 0000 0001
0000 0000 0000 0000

0xAE01
```
