# The fork

This is a fork from [devinsolutions/taiga-events](https://github.com/devinsolutions/docker-taiga-events) image, which now is being officially maintained by Taigaio.

# Taiga Events Docker Image

Taiga-events on the official Node image (Alpine variant).

## Deployment

See [Taiga: Setup production environment](https://taigaio.github.io/taiga-doc/dist/setup-production.html) and [docker-compose.advanced.yml](https://github.com/taigaio/docker-taiga-5/blob/master/docker-compose.advanced.yml) to find out more about the deployment procedures.

### Configuration

`/etc/opt/taiga-events/config.json` is used by default as the configuration file. See [config.example.json](https://github.com/taigaio/taiga-events/blob/master/config.example.json).

### Logs

Stdout and stderr are copied to `/var/log/taiga-events.log`.
