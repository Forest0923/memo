+++
title = "listen"
description = "NR = 50"
tags = [
  "Linux", "System Calls"
]
categories = [
  "Linux Code Reading"
]
weight = 50
draft = false
+++

## Version

- Linux v5.8.13

## Abstract

```c
long sys_listen(int fd, int backlog);
```

## Arguments

## Return

## Definition

### `sys_listen()`

- file: net/socket.c

```c
SYSCALL_DEFINE2(listen, int, fd, int, backlog)
{
	return __sys_listen(fd, backlog);
}
```

### `__sys_listen()`

```c
/*
 *	Perform a listen. Basically, we allow the protocol to do anything
 *	necessary for a listen, and if that works, we mark the socket as
 *	ready for listening.
 */

int __sys_listen(int fd, int backlog)
{
	struct socket *sock;
	int err, fput_needed;
	int somaxconn;

	sock = sockfd_lookup_light(fd, &err, &fput_needed);
	if (sock) {
		somaxconn = sock_net(sock->sk)->core.sysctl_somaxconn;
		if ((unsigned int)backlog > somaxconn)
			backlog = somaxconn;

		err = security_socket_listen(sock, backlog);
		if (!err)
			err = sock->ops->listen(sock, backlog);

		fput_light(sock->file, fput_needed);
	}
	return err;
}
```
