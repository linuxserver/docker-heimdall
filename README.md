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
* [Podcast](https://anchor.fm/linuxserverio) - on hiatus. Coming back soon (late 2018).

# PSA: Changes are happening

From August 2018 onwards, Linuxserver are in the midst of switching to a new CI platform which will enable us to build and release multiple architectures under a single repo. To this end, existing images for `arm64` and `armhf` builds are being deprecated. They are replaced by a manifest file in each container which automatically pulls the correct image for your architecture. You'll also be able to pull based on a specific architecture tag.

TLDR: Multi-arch support is changing from multiple repos to one repo per container image.

# [linuxserver/heimdall](https://github.com/linuxserver/docker-heimdall)
[![](https://images.microbadger.com/badges/version/linuxserver/heimdall.svg)](https://microbadger.com/images/linuxserver/heimdall "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/linuxserver/heimdall.svg)](https://microbadger.com/images/linuxserver/heimdall "Get your own version badge on microbadger.com")
![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/heimdall.svg)
![Docker Stars](https://img.shields.io/docker/stars/linuxserver/heimdall.svg)

[Heimdall](https://heimdall.site) is a way to organise all those links to your most used web sites and web applications in a simple way.
Simplicity is the key to Heimdall.
Why not use it as your browser start page? It even has the ability to include a search bar using either Google, Bing or DuckDuckGo.

[![heimdall](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/heimdall-banner.png)](https://heimdall.site)

## Supported Architectures

Our images support multiple architectures such as `X86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list). 

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| X86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v6-latest |

## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=heimdall \
  -e PUID=1001 \
  -e PGID=1001 \
  -e TZ=Europe/London \
  -p 80:80 \
  -p 443:443 \
  -v </path/to/appdata/config>:/config \
  linuxserver/heimdall
```


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
      - PUID=1001
      - PGID=1001
      - TZ=Europe/London
    volumes:
      - </path/to/appdata/config>:/config
    ports:
      - 80:80
      - 443:443
    mem_limit: 4096m
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 80` | http gui |
| `-p 443` | https gui |
| `-e PUID=1001` | for UserID - see below for explanation |
| `-e PGID=1001` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London |
| `-v /config` | Contains all relevant configuration files. |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1001` and `PGID=1001`, to find yours use `id user` as below:

```
  $ id username
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
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

## Versions

* **31.10.18:** - Add queue service.
* **17.10.18:** - Symlink avatars folder.
* **16.10.18:** - Updated fastcgi_params for user login support.
* **07.10.18:** - Symlink `.env` rather than copy. It now resides under `/config/www`
* **30.09.18:** - Multi-arch image. Move `.env` to `/config`.
* **05.09.18:** - Rebase to alpine linux 3.8.
* **06.03.18:** - Use password protection if htpasswd is set. Existing users can delete their default site config at /config/nginx/site-confs/default and restart the container, a new default site config with htpasswd support will be created in its place
* **12.02.18:** - Initial Release.
