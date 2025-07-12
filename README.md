# SSH Tunnel
Your usual SSH tunnel, but Dockerized

## Installation

Pre-built Alpine based image available
- `ghcr.io/n0rthernl1ghts/ssh-tunnel:latest`


You can also clone the repository and build manually

## Remote SSH Authentication
Password authentication is not supported at the moment.  
Daemon will try to fetch SSH key from docker secrets / environment, and fail if not present. 
The simplest method is to import the file using built-in convenience script:
```shell
bin/import_secret ssh_key_mysql /path/to/ssh-key/id_ed25519
```

If you need to use certificate, make sure to add secret entry to `compose.override.yaml`

```yaml
secrets:
  ssh_cert_mysql:
    file: secrets/ssh_keyfile_cert_mysql

services:
  mysql:
    secrets:
      - ssh_cert_mysql
```
And copy the file to your secrets
```shell
bin/import_secret ssh_cert_mysql /path/to/ssh-key/your_cert
```

## Available environment variables

```bash
REMOTE_SERVICE_HOST      = 127.0.0.1       [Connection is forwarded to this host]
REMOTE_SERVICE_PORT      = 3306            [Connection is forwarded to this port]
REMOTE_SSH_HOST          = 123.123.123.123 [Remote SSH server]
REMOTE_SSH_PORT          = 22              [Remote SSH port]
REMOTE_SSH_USER          = root            [Remote SSH user]
LOCAL_SERVICE_PORT       = 5100            [Expose forwarded service to this port]
```

Required: REMOTE_SERVICE_HOST, REMOTE_SERVICE_PORT, REMOTE_SSH_HOST

This is default configuration which you would use for tunneling MySQL database. This is only an example.

## Customize
By default, tunneled service will be exposed on port 5100, however you can override that with LOCAL_SERVICE_PORT environment variable.

## Security
This service works well even in very restricted environment, so feel free to drop all privileges as done in `compose.yaml`

## Contributing

Fork -> Patch -> Push -> Pull Request


## Authors

* [Aleksandar Puharic](https://github.com/xZero707)


## License

MIT


## Copyright

```
Copyright (c) 2023 Aleksandar Puharic  <https://www.puharic.com>
```