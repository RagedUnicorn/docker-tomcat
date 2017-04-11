# docker-tomcat

> A docker base to build a container for tomcat

This container is intended to build a base for providing a tomcat instance to host java applications.

### Start container

The container can be easily started with `docker-compose` command.

By default tomcat will be reachable on `127.0.0.1:8080`


```
docker-compose up -d
```

### Stop container

To stop all services from the docker-compose file

```
docker-compose down
```

## Dockery

In the dockery folder are some scripts that help out avoiding retyping long docker commands but are mostly intended for playing around with the container.

#### Build Image

The build script builds a container with a defined name

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

The tomcat configuration is located in `conf` and can be easily changed

The default user is:
`admin:admin`

To change this you can edit `conf/tomcat-users.xml`.

## Development

To debug the container and get more insight into the container use the `docker-compose-dev.yml`
configuration.

```
docker-compose -f docker-compose-dev.yml up -d
```

By default the launchscript `/docker-entrypoint.sh` will not be used to start the Tomcat process. Instead the container will be setup to keep `stdin_open` open and allocating a pseudo `tty`. This allows for connecting to a shell and work on the container. Tomcat itself can be started with `./docker-entrypoint.sh`.

## License:

Copyright (c) 2017 Michael Wiesendanger

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
