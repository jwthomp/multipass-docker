# Multipass Docker VM

## Prerequisites

To use this repository, you must have `multipass` and `docker` client installed. You do not need to have a `docker` daemon installed.

## Setup

### MacOS X
```
# brew install multipass
```

In order to install the docker client onto your host either install Docker Desktop, or grab the binary manually.

As an example:
```
wget https://download.docker.com/mac/static/stable/x86_64/docker-20.10.8.tgz
tar -czvf docker-20.10.8.tgz docker-20.10.8
cd docker-20.10.8
```

You can then run `docker` from that folder, or copy to somewhere that is in PATH.


## Miscellanea
If you previously were running Docker Desktop, and you are no longer using it, you may encounter errors due to a pre-existing
`~/.docker` directory. It will have been configured to work with Docker Desktop. Simply remove the contents of that folder.

An example error that you might see can ocur if you install `docker-compose` manually and run it:

```
...
  File "docker/auth.py", line 286, in _get_store_instance
  File "docker/credentials/store.py", line 23, in __init__
docker.credentials.errors.InitializationError: docker-credential-desktop not installed or not available in PATH
[86181] Failed to execute script docker-compose```
```

## Launch Docker VM
```
# ./launch.sh
```

## Use host Docker client
Put the following setting into your shells configuration file (.profile, .bash_profile, .zshrc, etc)
`export DOCKER_HOST=tcp://docker.local:2375`

The Multipass vm is running avahi-daemon so the vm's name is registered with mDNS as `docker.local`

After you have your DOCKER_HOST environment variable setup, you can use `docker` commands as normal.

## Networking Bug-a-boos
### Accessing your ports exposed by Docker
multipass does not currently bind exposed docker ports to localhost. As an example, if you run a web
server in docker that is exposing port 80, you will not be able to go to http://localhost:80. Instead,
you will need to use the docker vm's name to get there with http://docker.local:80.

I have included a helper bash script that uses the `socat` command to create a proxy from localhost to the docker vm.
You can use it by running `./bind_local.sh port1 port2 port3....`

You can run `./bind_local.sh` multiple times.

If you do not have `socat` installed, you can install it on your Mac with `brew install socat`

### Accessing your hosts exposed ports from withing a Docker container.

You can access your hosts exposed ports from within a Docker container by using the ip address `192.168.64.1` which
is accessible as an interface on your host. Any programms running that are bound to all interfaces (ip: 0.0.0.0) will
be bound to this network address.


## Remove Docker VM
```
# ./remove.sh
```

License: See License file
