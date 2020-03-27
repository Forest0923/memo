---
title: Install kernel
date: 2020-03-28
---
## Compile
- Change directory to `/usr/src`.
- Get kernel source code with the following command (ver.5.4.1).

```
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.4.1.tar.gz
```

- Decompress with tar.

```
tar -xvf linux-5.4.1.tar.gz
```

- Change directory to `linux-5.4.1`.
- Make .config with the following command.

```
make olddefconfig
```

- Compile with the following command. `4` indicate how many thread do you use.

```
make -j 4
```

## Install
- Install modules and kernel image with the following command.

```
make modules_install && make install
```


## Boot
- Setting bootloader (grub).

```
grub-mkconfig
```

- Reboot.
- You can choose kernel by selecting `Advanced options for Ubuntu`.
