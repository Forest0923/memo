---
title: "Dockerfile"
draft: false
weight: 100
---

## Template

```Dockerfile
# Specify the base image. This is typically called first.
FROM ubuntu:latest

# Add metadata. Specified as a {key, value} set, with any number of keys.
# There are standardized keys like `org.opencontainers.image.authors`
LABEL org.opencontainers.image.authors="name <foo@example.com>"
LABEL org.opencontainers.image.url="example.com"
LABEL org.opencontainers.image.version="1.0"
LABEL description="My test image" maintainer="foo@example.com"

# Set environment variables
ENV test_var="hello world" test_var1=unused

# Environment variables used during build.
# ARG can also be used before `FROM` to specify the base image version
ARG version=3.0

# Commands to run while building the image.
# In other words, this builds an image with `tmux` already installed
RUN apt update && apt upgrade -y && apt install -y tmux=$version

# The working directory for the execution of RUN, COPY, ADD, ENTRYPOINT, CMD
WORKDIR /workspace

# Specify directories within the container that you want to persist.
# On the host, it's stored in `/var/lib/docker/volumes/[hash]/_data`
VOLUME /workspace

# Explicitly describe the port information that the container listens on.
# This does not actually open the port
EXPOSE 8080

# Copy files from the host to the image filesystem
COPY hello.py .

# Copy files from the host to the image filesystem
# Unlike `COPY`, you can specify a URL and add a downloaded file
# Additionally, tar files are automatically expanded
# As the impacts of network connection and automatic expansion can be unpredictable, use `COPY` for achievable tasks
ADD test.tar.gz .

# The command to run when the container starts.
# If there are explicit arguments in `docker run`, those overwrite this.
# In Dockerfile, you can only use it once. If there are multiple, the latter definition is effective
CMD ["echo", "cmd called"]

# The command to run when the container starts.
# If there are explicit arguments in `docker run`, those become the arguments for the command
# If `docker run` has no arguments and CMD is used, 
# the content of CMD becomes the arguments for the ENTRYPOINT command
# ex) without arguments => `python hello.py echo cmd called` will be executed
ENTRYPOINT ["python", "hello.py"]
```

## Multi stage build

By using multi-stage builds, you can create a single runtime image from multiple images within a single Dockerfile.
This can be useful in scenarios where you do not want to include build-time side effects in your runtime container.

A new build stage begins in the Dockerfile each time FROM is executed.

```Dockerfile
# First build stage
# An environment variable that is only valid in this build stage
ARG version=latest
# Specify a name with AS
FROM ubuntu:$version AS ubuntu
RUN echo "Building on Ubuntu version: $version"

# Second build stage
FROM debian
# You can copy files from other images using --from
COPY --from=ubuntu /etc/os-release /ubuntu_version
```
