# Taiga Events Docker Image

Taiga-events on the official Node image (Alpine variant).

## Image deprecation

**This image is deprecated and will no longer receive updates of taiga-events
version.** After 1st October 2020, this image won't receive any updates at all,
and this repo will be archived. After that date, if the image becomes inactive
on Docker Hub, it will be removed as per Docker Hub's [image retention policy](
https://www.docker.com/pricing/resource-consumption-updates).

## Deployment

See [Taiga: Setup production environment](
https://taigaio.github.io/taiga-doc/dist/setup-production.html) and
[docker-compose.advanced.yml](
https://github.com/devinsolutions/docker-taiga/blob/master/docker-compose.advanced.yml)
to find out more about the deployment procedures.

### Configuration

`/etc/opt/taiga-events/config.json` is used by default as the configuration
file. See [config.example.json](
https://github.com/taigaio/taiga-events/blob/master/config.example.json).

### Logs

Stdout and stderr are copied to `/var/log/taiga-events.log`.
