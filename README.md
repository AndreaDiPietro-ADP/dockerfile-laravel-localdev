# dockerfile-laravel-localdev

Useful to have a development environment for Laravel without the need to install PHP, Node, NPM, Composer, XDebug3 on your local machine.

[DockerHub Images repo](https://hub.docker.com/r/andreadipietro/laravel-local-dev)

## Usage

### How to create a Laravel project using the **docker run** command inside a folder of the Docker host machine

```sh
docker run --rm -v HOST_DIRECTORY_FULLPATH:/laravel_app --entrypoint '/bin/bash' andreadipietro/laravel-local-dev:php8.1.3 -c 'composer create-project laravel/laravel /laravel_app'
```

For example, the creation of a Laravel project inside a folder named _**my_blog**_ ( HOST_DIRECTORY_FULLPAT=${PWD}/my_blog ):

```sh
docker run --rm -v ${PWD}/my_blog:/laravel_app --entrypoint '/bin/bash' andreadipietro/laravel-local-dev:php8.1.3 -c 'composer create-project laravel/laravel /laravel_app'
```

### How to create a container running an existent Laravel project

```sh
docker run --name CONTAINER_NAME -d -p PORT:8000 -v HOST_DIRECTORY_FULLPAT:/laravel_app andreadipietro/laravel-local-dev:php8.1.3
```

For example:

```sh
docker run --name laravel_my_blog -d -p 9080:8000 -e DB_CONNECTION=sqlite -v ${PWD}/my_blog:/laravel_app andreadipietro/laravel-local-dev:php8.1.3
```

### How to execute Artisan, Composer and Node commands

Simply open a terminal inside the running container

```sh
docker exec -it CONTAINER bash
```

For example:

```sh
docker exec -it laravel_my_blog bash
```

### Docker Compose Example

```yml
version: "3.9"

services:

  db:
    image: mysql:latest
    deploy:
      restart_policy:
        condition: none
    ports:
      - 33306:3306
    environment:
      MYSQL_DATABASE: laravel_my_blog
      MYSQL_USER: laravel_my_blog
      MYSQL_PASSWORD: laravel_my_blog
      MYSQL_ROOT_PASSWORD: laravel_my_blog_for_root
    volumes:
      - ${PWD}/DockerSharedFS/laravel_my_blog/db:/var/lib/mysql
    networks:
      - laravel_my_blog_nt

  blog:
    image: andreadipietro/laravel-local-dev:php8.1.3
    container_name: laravel_my_blog
    deploy:
      restart_policy:
        condition: none
    ports:
      - 9080:8000
    environment:
      APP_NAME: "Laravel My Blog"
      DB_CONNECTION: mysql
      DB_HOST: db
      DB_PORT: 3306
      DB_DATABASE: laravel_my_blog
      DB_USERNAME: laravel_my_blog
      DB_PASSWORD: laravel_my_blog
      XDEBUG_CONFIG: \
        client_host=host.docker.internal \
        client_port=9003 \
        idekey=phpdebugkey
      XDEBUG_MODE: "debug,develop"
    volumes:
      - ${PWD}/DockerSharedFS/laravel_my_blog/app:/laravel_app
    depends_on: 
      - db
    networks:
      - laravel_my_blog_nt

networks:
  laravel_my_blog_nt:
    name: laravel_my_blog_network

```
