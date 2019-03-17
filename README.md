# docker-tomcat

> A docker base image to build a container for Tomcat based on Alpine

This image is intended to build a base for providing a tomcat instance to host java applications. It depends on the baseimage `ragedunicorn/java:1.0.1-stable` from [RagedUnicorn/docker-java](https://github.com/RagedUnicorn/docker-java). Make sure to locally build this image or put it in a repository.

## Version

* Tomcat 8

For an exact version see `Dockerfile`

## Using the image

#### Start container

The container can be easily started with `docker-compose` command.

By default tomcat will be reachable on `127.0.0.1:8080`

```
docker-compose up -d
```

#### Stop container

To stop all services from the docker-compose file

```
docker-compose down
```

### Creating a stack

To create a stack the specific `docker-compose.stack.yml` file can be used. It requires that you already built the image that is consumed by the stack or that it is available in a reachable docker repository.

```
docker-compose build --no-cache
```

**Note:** You will get a warning that external secrets are not supported by docker-compose if you try to use this file with docker-compose.

#### Join a swarm

```
docker swarm init
```

#### Create secrets
```
echo "app_user" | docker secret create com.ragedunicorn.tomcat.app_user -
echo "app_user_password" | docker secret create com.ragedunicorn.tomcat.app_user_password -
```

#### Deploy stack
```
docker stack deploy --compose-file=docker-compose.stack.yml [stackname]
```

For a production deployment a stack should be deployed. The secret will then be taken into account and Tomcat will be setup accordingly. You can also set a password in `conf\tomcat-users.xml` but this is not recommended for production.

## Dockery

In the dockery folder are some scripts that help out avoiding retyping long docker commands but are mostly intended for playing around with the container. For production docker-compose or docker stack should be used.

#### Build image

The build script builds an image with a defined name

```
sh dockery/dbuild.sh
```

#### Run container

Runs the built container. If the container was already run once it will `docker start` the already present container instead of using `docker run`

```
sh dockery/drun.sh
```

#### Attach container

Attaching to the container after it is running

```
sh dockery/dattach.sh
```

#### Stop container

Stopping the running container

```
sh dockery/dstop.sh
```

## Configuration

#### Default user

The Tomcat configuration is located in `config` and can be easily changed.

The default user is:
`admin:admin`

To change this you can edit `config/tomcat-users.xml`.

**Note:** This does not apply to a stack deployment. Make sure to set both password and user with docker secrets.

#### Build Args

The image allows for certain arguments being overridden by build args.

`TOMCAT_USER, TOMCAT_GROUP`

They all have a default value and don't have to be overridden. For details see the Dockerfile.

## Healthcheck

The production and the stack image supports a simple healthcheck showing whether the container is healthy or not. This can be configured inside `docker-compose.yml` or `docker-compose.stack.yml`

## Test

To do basic tests of the structure of the container use the `docker-compose.test.yml` file.

`docker-compose -f docker-compose.test.yml up`

For more info see [container-test](https://github.com/RagedUnicorn/docker-container-test).

Tests can also be run by category such as command, fileExistence and metadata tests by starting single services in `docker-compose.test.yml`

```
# basic file existence tests
docker-compose -f docker-compose.test.yml up container-test
# command tests
docker-compose -f docker-compose.test.yml up container-test-command
# metadata tests
docker-compose -f docker-compose.test.yml up container-test-metadata
```

The same tests are also available for the development image.

```
# basic file existence tests
docker-compose -f docker-compose.test.yml up container-dev-test
# command tests
docker-compose -f docker-compose.test.yml up container-dev-test-command
# metadata tests
docker-compose -f docker-compose.test.yml up container-dev-test-metadata
```

## Development

To debug the container and get more insight into the container use the `docker-compose.dev.yml`
configuration.

```
docker-compose -f docker-compose.dev.yml up -d
```

By default the launchscript `/docker-entrypoint.sh` will not be used to start the Tomcat process. Instead the container will be setup to keep `stdin_open` open and allocating a pseudo `tty`. This allows for connecting to a shell and work on the container. A shell can be opened inside the container with `docker attach [container-id]`. Tomcat itself can be started with `./docker-entrypoint.sh`.

The Tomcat server also exposes jmx access on port `60334` when built with the developer configuration. To connect to the server use a tool like jconsole and its url `127.0.0.1:60334`

## Links

Alpine packages database
- https://pkgs.alpinelinux.org/packages

## License

Copyright (C) 2019 Michael Wiesendanger

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
