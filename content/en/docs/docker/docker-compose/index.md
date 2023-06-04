---
title: "Docker Compose"
draft: false
weight: 110
---

## Template

```yml
# Version of Docker compose
version: '3'
services:
  # First container
  db:
    image: mysql:latest
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpasswd
      MYSQL_DATABASE: sampledb
      MYSQL_USER: application
      MYSQL_PASSWORD: applicationpw

  # Second container
  web:
    image: nginx:latest
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    ports:
      - "8080:80"
    # Specifies dependencies
    # As it depends on the db container, web starts after db starts
    depends_on:
      - db

# Creating volumes
volumes:
    # Write volume settings. When it's {}, it uses the default settings.
    # It seems that you can store it locally or in AWS
    # You can also specify the file system of the mount point, or attach labels
    db_data:
        driver: local
    driver_opts:
      o: bind
      device: /path/to/data
```

## Run

### Docker compose plugin

```sh
docker compose up
```

or

```sh
docker compose -f /path/to/docker-compose.yml up
```

### docker-compose

```sh
docker-compose up
```

or

```sh
docker-compose -f /path/to/docker-compose.yml up
```
