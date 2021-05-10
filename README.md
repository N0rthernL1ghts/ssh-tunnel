# SSH Tunnel
Your usual SSH tunnel, but Dockerized

## Installation

* Pre-built Alpine based image available on dockerhub as `nlss/ssh-tunnel:latest`
* You can also clone the repository and build manually

## Remote SSH Authentication
Password authentication is not supported at the moment.  
Daemon will try to fetch SSH key from `/secret` directory, and fail if directory is not present. 
The simplest method is to mount the file like this:
```
docker run (...) -v "/path/to/ssh-key/id_ed25519:/secret/keyfile:ro" nlss/ssh-tunnel
```

If you need to use certificate:
```
docker run (...) -v "/path/to/ssh-key/id_ed25519:/secret/keyfile:ro" -v "/path/to/ssh-key/mycert:/secret/keyfile-cert:ro" nlss/ssh-tunnel
```

Another way would be to mount complete directory to `/secret` and make sure required files are provided.
```
docker run (...) -v "/path/to/my-ssh-secrets:/secret:ro" nlss/ssh-tunnel
```

## Available environment variables

```bash
TUNNEL_SERVICE      = 127.0.0.1:3306       [Connection is forwarded to this host:port]
SSH_HOST            = 123.123.123.123      [Remote SSH server]
SSH_PORT            = 22                   [Remote SSH port]
SSH_USER            = root                 [Remote SSH user]
SERVICE_EXPOSE_PORT = 5100                 [Expose forwarded service to this port]
```

Required: TUNNEL_SERVICE, SSH_HOST

This is default configuration which you would use for tunneling MySQL database.
TUNNEL_SERVICE

## Customize
By default, tunneled service will be exposed on port 5100, however you can override that with SERVICE_EXPOSE_PORT environment variable.

## Security
This service works well even in very restricted environment, so feel free to drop all privileges as done in docker-compose.yml

## Contributing

Fork -> Patch -> Push -> Pull Request


## Authors

* [Aleksandar Puharic](https://github.com/xZero707)


## License

MIT


## Copyright

```
Copyright (c) 2021 Aleksandar Puharic  <https://www.puharic.com>
```