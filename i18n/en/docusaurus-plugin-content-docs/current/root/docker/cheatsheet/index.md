---
title: "Cheatsheet"
draft: false
weight: 50
---

## Images

### Search Docker Hub

```sh
docker search <query>
```

### Download Image

```sh
docker pull <image>
```

### Create Image

```sh
docker commit <container> new_image:tag
docker commit <container> new_image
```

### Remove Image

```sh
docker image rm <image>
```

or

```sh
docker rmi <image>
```

### Tag Image

```sh
docker tag <image> new_image:tag
docker tag <image> new_image
```

### Display Image Information

```sh
docker image inspect
```

### Build Image

```sh
docker image build -t <image_name> .
```

or

```sh
docker build -t <image_name> .
```

## Containers

### Run Container

```sh
docker container run <image>
```

or

```sh
docker run <image>
```

- Execute Shell

```sh
docker container run -it <image> /bin/bash
```

- Overwrite ENTRYPOINT and Execute Shell (Be careful, as it might not work as originally planned)

```sh
docker container run --entrypoint /bin/bash -it <image>
```

### Port Forwarding

```sh
docker run -p <host-port>:<container-port> <image>
```

### File System Mount

```sh
docker run -v /path/to/local:/path/to/container <image>
```

or

```sh
docker run --mount type=bind,source=/path/to/local,target=/path/to/container <image>
```

### Running Containers

```sh
docker container ls -a
```

or

```sh
docker ps -a
```

### Display Container stdout, stderr

```sh
docker container logs <container>
```

or

```sh
docker logs <container>
```

### Display Container Information

```sh
docker container inspect <container>
```

### Rename Container

```sh
docker container rename <old_name> <new_name>
```

### Enter Shell of Running Container

```sh
docker container exec -it <container> /bin/bash
```

or

```sh
docker exec -it <container> /bin/bash
```

### Stop Container

- SIGTERM

```sh
docker container stop
```

- SIGKILL

```sh
docker container kill
```

or

```sh
docker kill
```

### Automatically Start Container when OS Boots

- When you want to always start it

```sh
docker container run -d --restart=always <container>
```

- When you don't want to execute the container stopped by `docker container stop` or similar

```sh
docker container run -d --restart=unless-stopped <container>
```

- When you want to add a setting to a container that is already running

```sh
docker update --restart=[always,unless-stopped] <container>
```
