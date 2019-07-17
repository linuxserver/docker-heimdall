[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)](https://linuxserver.io)

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring :-

 * regular and timely application updates
 * easy user mappings (PGID, PUID)
 * custom base image with s6 overlay
 * weekly base OS updates with common layers across the entire LinuxServer.io ecosystem to minimise space usage, down time and bandwidth
 * regular security updates

Find us at:
* [Discord](https://discord.gg/YWrKVTn) - realtime support / chat with the community and the team.
* [IRC](https://irc.linuxserver.io) - on freenode at `#linuxserver.io`. Our primary support channel is Discord.
* [Blog](https://blog.linuxserver.io) - all the things you can do with our containers including How-To guides, opinions and much more!

# [linuxserver/heimdall](https://github.com/linuxserver/docker-heimdall)
[![](https://img.shields.io/discord/354974912613449730.svg?logo=discord&label=LSIO%20Discord&style=flat-square)](https://discord.gg/YWrKVTn)
[![](https://images.microbadger.com/badges/version/linuxserver/heimdall.svg)](https://microbadger.com/images/linuxserver/heimdall "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/linuxserver/heimdall.svg)](https://microbadger.com/images/linuxserver/heimdall "Get your own version badge on microbadger.com")
![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/heimdall.svg)
![Docker Stars](https://img.shields.io/docker/stars/linuxserver/heimdall.svg)
[![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Pipeline-Builders/docker-heimdall/master)](https://ci.linuxserver.io/job/Docker-Pipeline-Builders/job/docker-heimdall/job/master/)
[![](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/heimdall/latest/badge.svg)](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/heimdall/latest/index.html)

[Heimdall](https://heimdall.site) is a way to organise all those links to your most used web sites and web applications in a simple way.
Simplicity is the key to Heimdall.
Why not use it as your browser start page? It even has the ability to include a search bar using either Google, Bing or DuckDuckGo.

[![heimdall](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/heimdall-banner.png)](https://heimdall.site)

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list) and our announcement [here](https://blog.linuxserver.io/2019/02/21/the-lsio-pipeline-project/). 

Simply pulling `linuxserver/heimdall` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v7-latest |


## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=heimdall \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -p 80:80 \
  -p 443:443 \
  -v </path/to/appdata/config>:/config \
  --restart unless-stopped \
  linuxserver/heimdall
```

Using tags, you can switch between the stable releases of Heimdall and the master branch. No tag is required for the latest stable release.
Add the development tag,  if required,  to the linuxserver/heimdall line of the run/create command in the following format, linuxserver/heimdall:development
The development tag will be the latest commit in the master branch of Heimdall.
HOWEVER , USE THE DEVELOPMENT TAG AT YOUR OWN PERIL !!!!!!!!!


### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  heimdall:
    image: linuxserver/heimdall
    container_name: heimdall
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - </path/to/appdata/config>:/config
    ports:
      - 80:80
      - 443:443
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 80` | http gui |
| `-p 443` | https gui |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London |
| `-v /config` | Contains all relevant configuration files. |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```


&nbsp;
## Application Setup

Access the web gui at http://SERVERIP:PORT


### Adding password protection

This image now supports password protection through htpasswd. Run the following command on your host to generate the htpasswd file `docker exec -it heimdall htpasswd -c /config/nginx/.htpasswd <username>`. Replace <username> with a username of your choice and you will be asked to enter a password. New installs will automatically pick it up and implement password protected access. Existing users updating their image can delete their site config at `/config/nginx/site-confs/default` and restart the container after updating the image. A new site config with htpasswd support will be created in its place.



## Support Info

* Shell access whilst the container is running: `docker exec -it heimdall /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f heimdall`
* container version number 
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' heimdall`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/heimdall`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.  
  
Below are the instructions for updating containers:  
  
### Via Docker Run/Create
* Update the image: `docker pull linuxserver/heimdall`
* Stop the running container: `docker stop heimdall`
* Delete the container: `docker rm heimdall`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start heimdall`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull heimdall`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d heimdall`
* You can also remove the old dangling images: `docker image prune`

### Via Watchtower auto-updater (especially useful if you don't remember the original parameters)
* Pull the latest image at its tag and replace it with the same env variables in one run:
  ```
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once heimdall
  ```

**Note:** We do not endorse the use of Watchtower as a solution to automated updates of existing Docker containers. In fact we generally discourage automated updates. However, this is a useful tool for one-time manual updates of containers where you have forgotten the original parameters. In the long term, we highly recommend using Docker Compose.

* You can also remove the old dangling images: `docker image prune`

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic: 
```
git clone https://github.com/linuxserver/docker-heimdall.git
cd docker-heimdall
docker build \
  --no-cache \
  --pull \
  -t linuxserver/heimdall:latest .
```

The ARM variants can be built on x86_64 hardware using `multiarch/qemu-user-static`
```
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

Once registered you can define the dockerfile to use with `-f Dockerfile.aarch64`.

## Versions

* **15.07.19:** - Save laravel.log to /config, install heimdall during first start.
* **28.06.19:** - Rebasing to alpine 3.10.
* **23.03.19:** - Switching to new Base images, shift to arm32v7 tag.
* **22.02.19:** - Rebasing to alpine 3.9.
* **04.11.18:** - Add php7-zip.
* **31.10.18:** - Add queue service.
* **17.10.18:** - Symlink avatars folder.
* **16.10.18:** - Updated fastcgi_params for user login support.
* **07.10.18:** - Symlink `.env` rather than copy. It now resides under `/config/www`
* **30.09.18:** - Multi-arch image. Move `.env` to `/config`.
* **05.09.18:** - Rebase to alpine linux 3.8.
* **06.03.18:** - Use password protection if htpasswd is set. Existing users can delete their default site config at /config/nginx/site-confs/default and restart the container, a new default site config with htpasswd support will be created in its place
* **12.02.18:** - Initial Release.
