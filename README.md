# docker-bitlbee
Dockerfile for Bitlbee

## Building
There are three build arguments: `buildhost`, `version`, and `tar_filename`. Use these to to customize where the bitlbee source is downloaded from. Note you should only need to touch the `version` argument.

## Volumes
There are three volumes:
- `/usr/local/etc/bitlbee`: Contains configuration files
- `/var/lib/bitlbee`: Contains account data
- `/usr/local/lib/bitlbee`: Contains plugins

Note that you will have to create the bitlbee config file yourself

## Environment Variables
This images allows you to set some environment variables to manage the user/group that will be created when the container starts. You can specify this user in your bitlbee config file to ensure that bitlbee will not run as root. It will also allow you to match UID/GID between container and host, which is particularly handy when it comes to volumes. This technique is based on [this blog post](https://denibertovic.com/posts/handling-permissions-with-docker-volumes).
- `LOCAL_USER_ID`: The UID of the user that will be created on container startup.
- `LOCAL_GROUP_ID`: The GID of the group that will be created on container startup.
- `LOCAL_USER_NAME`: The username of the user that will be created on container startup.
- `LOCAL_USER_GROUP`: The group of the user that will be created on container startup.

## Usage
* Run the basic application
```shell
$ docker run -d -p 6667:6667 mwstobo/bitlbee
```

* Run the application without root privileges, with persistent config, data, and plugins, with a host user owning files in the volumes.
```shell
$ useradd -r -s /usr/sbin/nologin bitlbee
$ LOCAL_USER_ID=$(id -u bitlbee)
$ LOCAL_GROUP_ID=$(id -g bitlbee)
$ LOCAL_USER_NAME=bitlbee
$ CONFIG_DIR=/path/to/config/dir
$ DATA_DIR=/path/to/data/dir
$ PLUGIN_DIR=/path/to/plugin/dir
$ echo "User = bitlbee" >> $CONFIG_DIR/bitlbee.conf
$ docker run -d \
             -e LOCAL_USER_ID=$LOCAL_USER_ID \
             -e LOCAL_GROUP_ID=$LOCAL_GROUP_ID \
             -e LOCAL_USER_NAME=bitlbee \
             -v $CONFIG_DIR:/usr/local/etc/bitlbee \
             -v $DATA_DIR:/var/lib/bitlbee \
             -v $PLUGIN_DIR:/usr/local/lib/bitlbee \
             -p 6667:6667 \
             mwstobo/bitlbee
```
