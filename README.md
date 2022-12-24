# Sunitha's starting
 * Forked https://github.com/OpenSIPS/docker-opensips to sunitha's github account
 * In acer ubuntu os shell create a dir opensips_razvan
 * cd opensips_razvan
 * git init
 * git clone git@github.com:OpenSIPS/docker-opensips.git
 * updated Dockerfile to debian:bullseye and opensips version from 3.1 to 3.3
 * included curl and apt-utils to get installed  
 * changed key to curl command from opensips documetation 
 * https://apt.opensips.org/packages.php?os=bullseye
 * changed Makefile also to opensips 3.3
 * In ubuntu os shell gave cmd : make build
 * docker run --name opensipsrazvan -p 192.168.0.103:5061:5060 -itd opensips/opensips:3.3 
 * Because host 5060 is already exposed to old opensips mapped to 5061
 * opensips/opensips:3.3 is the image name



# OpenSIPS Docker Image
http://www.opensips.org/

Docker recipe for building and starting an OpenSIPS image

## Building the image
You can build the docker image by running:
```
make build
```

This command will build a docker image with OpenSIPS master version taken from
the git repository. To build a different git version, you can run:
```
OPENSIPS_VERSION=2.2 make build
```

To build with MySQL support:
```
OPENSIPS_EXTRA_MODULES=opensips-mysql-module make build
```

To start the image, simply run:
```
make start
```

## Variables
You can set different variables to tune your deployment:
 * `OPENSIPS_VERSION` - sets the opensips version (Default: `3.1`)
 * `OPENSIPS_BUILD` - specifies the build to use, `nightly` or `releases` (Default: `releases`)
 * `OPENSIPS_DOCKER_TAG` - indicates the docker tag (Default: `latest`)
 * `OPENSIPS_CLI` - specifies whether to install opensips-cli (`true`) or not (`false`) (Default: `true`)
 * `OPENSIPS_EXTRA_MODULES` - specifies extra opensips modules to install (Default: no other module)

## Packages on DockerHub

Released docker packages are visible on DockerHub
https://hub.docker.com/r/opensips/opensips



## Sunitha's changes after opensips make build success
 * In container bash shell in /root, created .opensips-cli.cfg
 * From https://github.com/OpenSIPS/opensips-cli/blob/master/etc/default.cfg
 * copied default config to .opensips-cli.cfg
 * updated the file: log_level: DEBUG
 * commented fifo lines 
 * added lines: 
 * database_admin_url: mysql://root@192.168.0.103:3306
 * database_url: mysql://opensips:opensipsrw@192.168.0.103:3306/opensips
 * ++++++++++++++++++++++++
 * In Mariadb deleted opensips db and opensips user
 * Ran command opensips-cli -x database create opensips
 * It created opensips db, tables  and user opensips with permissions
 * ++++++++++++++++++++++++
 * To enable opensips.log in /var/log/opensips.log
 * From https://www.oreilly.com/library/view/building-telephony-systems/9781785280610/ch03s03.html
 * rsyslog was not found in container bash shell
 * apt-get install rsyslog procps wget
 * edit /etc/rsyslog.conf and added last line 
 * Local0.*                      -/var/log/opensips.log
 * /etc/init.d/rsyslog restart threw an error on imklog 
 * solution is : in container bash shell enter sed -i '/imklog/s/^/#/' /etc/rsyslog.conf
 * /etc/init.d/rsyslog restart
 * Now /var/log/opensips.log is present
 * /etc/init.d/opensips restart
 * ++++++++++++++++++++++++
 * To check a package installed, ran cmd  dpkg -L php-mysql 
 * dpkg -L opensips-mysql-module 
