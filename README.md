# [Docker Get Started](https://docs.docker.com/get-started/)

## Part 1: Orientation and setup
```
## List Docker CLI commands
$ docker
$ docker container --help

## Display Docker version and info
$ docker --version
$ docker version
$ docker info

## Execute Docker image
$ docker run hello-world

## List Docker images
$ docker image ls
$ docker images

## List Docker containers (running, all, all in quiet mode)
$ docker container ls
$ docker container ls --all
$ docker container ls -aq
$ docker ps
$ docker ps -a
$ docker ps -aq
```

## [Part 2: Containers](https://docs.docker.com/get-started/part2/)
* Prequest:
  * [Install docker ce](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
* Stack
  * 应用程序栈
  * 应用交互
* swarm/cluster
  * Multi-container, multi-machine applications are made possible by joining multiple machines into a "Dockerized" cluster called a swarm
  * docker-compose.yml
* Services
  * 微服务
  * 负载均衡
* Container
  * 应用模块

```
sudo service docker restart
$ docker build -t friendlyhello .  # Create image using this directory's Dockerfile
$ docker run -p 4000:80 friendlyhello  # Run "friendlyname" mapping port 4000 to 80
$ docker run -d -p 4000:80 friendlyhello         # Same thing, but in detached mode
$ docker container ls                                 # List all running containers
$ docker container ls -a              # List all containers, even those not running
$ docker ps
$ docker container stop <hash>            # Gracefully stop the specified container
$ docker stop 9c
$ docker container kill <hash>          # Force shutdown of the specified container
$ docker container rm <hash>         # Remove specified container from this machine
$ docker container rm $(docker container ls -a -q)          # Remove all containers
$ docker rm $(docker ps -aq)                 # Same as above, Remove all containers
$ docker image ls -a                              # List all images on this machine
$ docker image rm <image id>             # Remove specified image from this machine
$ docker image rm $(docker image ls -a -q)    # Remove all images from this machine
$ docker rmi 9c
$ docker login              # Log in this CLI session using your Docker credentials
$ docker tag <image> username/repository:tag   # Tag <image> for upload to registry
$ docker push username/repository:tag             # Upload tagged image to registry
$ docker run username/repository:tag                    # Run image from a registry
```

## [Part 3: Services](https://docs.docker.com/get-started/part3/)
* Prerequest:
  * [Install docker-compose](https://docs.docker.com/compose/install/)
```
$ docker swarm init --advertise-addr <machine ip>
$ docker stack ls                                             # List stacks or apps
$ docker stack deploy -c <composefile> <appname>   # Run the specified Compose file
$ docker stack deploy -c docker-compose.yml getstartedlab  # or update Compose file
$ docker stack services getstartedlab
$ docker stack ps getstartedlab
$ docker service ls                  # List running services associated with an app
$ docker service ps <service>                   # List tasks associated with an app
$ docker service ps getstartedlab_web
$ docker inspect <task or container>                    # Inspect task or container
$ docker container ls -q                                       # List container IDs
$ docker stack rm <appname>                              # Tear down an application
$ docker swarm leave --force       # Take down a single node swarm from the manager
```

## [Part 4: Swarms](https://docs.docker.com/get-started/part4/)
* Prerequest:
  * [Install Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  * [Install docker-machine](https://docs.docker.com/machine/install-machine/)
```
$ docker-machine create --driver virtualbox myvm1  # Create a VM (Mac, Win7, Linux)
$ docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm1  # Win10
$ docker-machine env myvm1                 # View basic information about your node
$ docker-machine ssh myvm1 "docker node ls"          # List the nodes in your swarm
$ docker-machine ssh myvm1 "docker node inspect <node ID>"         # Inspect a node
$ docker-machine ssh myvm1 "docker swarm join-token -q worker"    # View join token
$ docker-machine ssh myvm1 "docker swarm join-token manager"
$ docker-machine ssh myvm1    # Open an SSH session with the VM; type "exit" to end
$ docker node ls                 # View nodes in swarm (while logged on to manager)
$ docker-machine ssh myvm1 "docker swarm init --advertise-addr <myvm1 ip>"      # 1
$ docker-machine ssh myvm2 "docker swarm join --token <token> <myvm1 ip>:2377"  # 2
$ docker-machine ssh myvm2 "docker swarm leave"   # Make the worker leave the swarm
$ docker-machine ssh myvm1 "docker swarm leave -f"  # Make master leave, kill swarm
$ docker-machine ls    # list VMs, asterisk shows which VM this shell is talking to
$ docker-machine start myvm1             # Start a VM that is currently not running
$ docker-machine env myvm1       # show environment variables and command for myvm1
$ eval $(docker-machine env myvm1)    # Mac/Linux command to connect shell to myvm1
$ & "C:\Program Files\Docker\Docker\Resources\bin\docker-machine.exe" env myvm1 | Invoke-Expression           # Windows command to connect shell to myvm1
$ docker stack deploy -c <file> <app>                      # Deploy an app; command shell must be set to talk to manager (myvm1), uses local Compose file
$ docker stack deploy -c docker-compose.yml getstartedlab
$ docker-machine scp docker-compose.yml myvm1:~    # Copy file to node's home dir (only required if you use ssh to connect to manager and deploy the app)
$ docker-machine ssh myvm1 "docker stack deploy -c <file> <app>"         # Deploy an app using ssh (you must have first copied the Compose file to myvm1)
$ eval $(docker-machine env -u)      # Disconnect shell from VMs, use native docker
$ docker-machine stop $(docker-machine ls -q)                # Stop all running VMs
$ docker-machine rm $(docker-machine ls -q)  # Delete all VMs and their disk images
```

## [Part 5: Stacks](https://docs.docker.com/get-started/part5/)
1. `$ docker-machine create --driver virtualbox myvm1 && docker-machine create --driver virtualbox myvm2`
* `$ docker-machine ls`
2. `$ docker-machine ssh myvm1 "docker swarm init --advertise-addr <myvm1 ip>"`
* `$ docker swarm join-token manager`
3. `$ docker-machine ssh myvm2 "docker swarm join --token <myvm1 token> <myvm1 ip>:2377"`
* `$ docker node ls`
4. edit `docker-compose.yml`
5. `$ eval $(docker-machine env myvm1)`  # Configure a docker-machine shell to the swarm manager `myvm1`
6. `$ docker stack deploy -c docker-compose.yml getstartedlab`  # At `docker-compose.yml` path, init deploy
* `$ docker service ls`
* `$ docker stack ps getstartedlab`
* `$ docker container ls -q`
* `$ curl <myvm1 ip>:8080`
7. edit `docker-compose.yml` again and `$ docker stack deploy -c docker-compose.yml getstartedlab`  # At `docker-compose.yml` path, update deploy
* `$ curl <myvm1 ip>`

* 可以不使用 `swarm mode`: 直接运行 `$ docker-compose up` 执行单机模式, 详见 `$ docker-compose up --help`

## [Part 6: Deploy your app](https://docs.docker.com/get-started/part6/)
* 重要概念:
  * A `swarm` is a `group of machines` that are running Docker and joined into a `cluster`. After that has happened, you continue to run the Docker commands you're used to, but now they are executed on a cluster by a `swarm manager`. The machines in a swarm can be `physical or virtual`. After joining a swarm, they are referred to as `nodes`;
  * `Swarm managers` are the only machines in a swarm that can execute your commands, or authorize other machines to join the swarm as `workers`. `Workers` are just there to provide capacity and do not have the authority to tell any other machine what it can and cannot do;
  * Enabling swarm mode (`$ docker swarm init`) instantly makes `the current machine` a swarm manager. From then on, Docker runs the commands you execute on the swarm you're managing, rather than just on the current machine.
* 后续知识:
  * 如何查看日志: `$ docker logs --help`
  * `docker-compose.yml` 详细配置属性
  * `docker-compose`, `docker-machine` 命令
  * [多阶段编译](https://docs.docker.com/develop/develop-images/multistage-build/)