+++
title = "accept4"
description = "NR = 288 <br> cf. [accept](/memo/ja/docs/linux-syscalls/accept/)"
tags = [
  "Linux", "System Calls"
]
categories = [
  "Linux Code Reading"
]
weight = 288
draft = false
+++

## Version

- Linux v5.8.13

## Abstract

```c
long sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
				int __user *upeer_addrlen, int flags);
```

## Arguments

## Return

## Definition

- file: net/socket.c

```c
SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
		int __user *, upeer_addrlen, int, flags)
{
	return __sys_accept4(fd, upeer_sockaddr, upeer_addrlen, flags);
}
```

```c
/*
 *	For accept, we attempt to create a new socket, set up the link
 *	with the client, wake up the client, then return the new
 *	connected fd. We collect the address of the connector in kernel
 *	space and move it to user at the very end. This is unclean because
 *	we open the socket then return an error.
 *
 *	1003.1g adds the ability to recvmsg() to query connection pending
 *	status to recvmsg. We need to add that support in a way thats
 *	clean when we restructure accept also.
 */

int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
		  int __user *upeer_addrlen, int flags)
{
	int ret = -EBADF;
	struct fd f;

	f = fdget(fd);
	if (f.file) {
		ret = __sys_accept4_file(f.file, 0, upeer_sockaddr,
						upeer_addrlen, flags,
						rlimit(RLIMIT_NOFILE));
		if (f.flags)
			fput(f.file);
	}

	return ret;
}
```

```c
int __sys_accept4_file(struct file *file, unsigned file_flags,
		       struct sockaddr __user *upeer_sockaddr,
		       int __user *upeer_addrlen, int flags,
		       unsigned long nofile)
{
	struct socket *sock, *newsock;
	struct file *newfile;
	int err, len, newfd;
	struct sockaddr_storage address;

	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
		return -EINVAL;

	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;

	sock = sock_from_file(file, &err);
	if (!sock)
		goto out;

	err = -ENFILE;
	newsock = sock_alloc();
	if (!newsock)
		goto out;

	newsock->type = sock->type;
	newsock->ops = sock->ops;

	/*
	 * We don't need try_module_get here, as the listening socket (sock)
	 * has the protocol module (sock->ops->owner) held.
	 */
	__module_get(newsock->ops->owner);

	newfd = __get_unused_fd_flags(flags, nofile);
	if (unlikely(newfd < 0)) {
		err = newfd;
		sock_release(newsock);
		goto out;
	}
	newfile = sock_alloc_file(newsock, flags, sock->sk->sk_prot_creator->name);
	if (IS_ERR(newfile)) {
		err = PTR_ERR(newfile);
		put_unused_fd(newfd);
		goto out;
	}

	err = security_socket_accept(sock, newsock);
	if (err)
		goto out_fd;

	err = sock->ops->accept(sock, newsock, sock->file->f_flags | file_flags,
					false);
	if (err < 0)
		goto out_fd;

	if (upeer_sockaddr) {
		len = newsock->ops->getname(newsock,
					(struct sockaddr *)&address, 2);
		if (len < 0) {
			err = -ECONNABORTED;
			goto out_fd;
		}
		err = move_addr_to_user(&address,
					len, upeer_sockaddr, upeer_addrlen);
		if (err < 0)
			goto out_fd;
	}

	/* File flags are not inherited via accept() unlike another OSes. */

	fd_install(newfd, newfile);
	err = newfd;
out:
	return err;
out_fd:
	fput(newfile);
	put_unused_fd(newfd);
	goto out;

}
```
