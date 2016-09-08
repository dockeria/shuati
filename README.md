# go-coding

This is a project for [Golang](https://golang.org/) exercises.



### Installing Go

#### Local Installation
See https://www.goinggo.net/2016/05/installing-go-and-your-workspace.html

After installed go and set `$GOPATH` (which typically is `$HOME/go`)

```
mkdir -p $GOPATH/src/github.com/dockerian
cd $GOPATH/src/github.com/dockerian
git clone https://github.com/dockerian/shuati.git
cd shuati
```

*NOTE:* This assumes you have Git installed.  If you don’t, you can find the installation instructions here: https://git-scm.com/

Optionally create a soft link (as shortcut) in `$HOME/projects`

```
ln -s $GOPATH/src/github.com/dockerian/shuati $HOME/projects/shuati
cd -P $HOME/projects/shuati
```


#### Using Docker
Installing Go may not be needed if you choose to use [Docker](#docker). With running a shuati container, you can clone this repo at any location on your disk, for example `$HOME/projects`, without having to set ```$GOPATH```. And you can still access (e.g. for editing) the source code locally.

```
# assume in your projects folder
cd $HOME/projects
git clone https://github.com/dockerian/shuati.git
cd shuati
```

To build and run in docker container, see [here](#docker).



### Build, test and run

The `Makefile` has included `build`, `test`, `run` targets. For example, to build, simply change to the project directory and run

```
make build # or ./build.sh
```

or to run tests

```
make test  # or ./run.sh test
```


###<a name="docker" />Build and run shuati in Docker container

**Install Docker Toolbox**  

See
[Install Docker Platform](https://www.docker.com/products/overview#/install_the_platform)
or
[Docker Toolbox](https://www.docker.com/products/docker-toolbox)


**Clean up shuati container and image**

```
docker rm -f $(docker ps -a | grep shuati | awk '{print $1}')
docker rmi -f $(docker images -a | grep shuati | awk '{print $1}')
```


**Build Docker container**

```
./build.sh
```

or

```
# current path is the source root where Dockerfile exists
docker build -t shuati .
```


**Start Docker container**

Running `Makefile` target, default is `test` :

```
./run.sh
```

or

```
docker run -it -v "$PWD":/go/src/github.com/dockerian/shuati shuati
# or start container with downloaded 'shuati' in the image
docker run --rm -it shuati
```
