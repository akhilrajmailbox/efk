# elasticsearch-fluentd-kibana

# efk-server


docker run command ::

```

docker run --env-file env-file -p 5687:9200 -p 5688:5601 -it --name efk-server --hostname efk-server img-name /bin/bash

```

NOTE ::


environment variable for readonlyREST container ::

Create a file with the following variable

## single kibana user configuration
(need to update the Dockerfile entrypoint)

```
## mandatory docker variable

KIBANA_PASSWORD		=		password for kibana - elasticsearch connection
FLUENTD_PASSWORD	=		password for kibana - fluentd  connection

```

## multi kibana user configuration

```
KIBANA_RO_PASSWORD      =       readonly access for kibana dashboard
KIBANA_ADMIN_PASSWORD   =       password for kibana - elasticsearch connection
FLUENTD_PASSWORD        =       password for kibana - fluentd  connection
```

environment variable for nginx enabled container ::

Create a file with the following variable

```
## mandatory docker variable

HTPASSWORD		=		"USERNAME : admin" and "PASSWORD : The password you are providing with 'HTPASSWORD' environment variable"

```

example environment file  ::

```
## mandatory docker variable
# NOTE : do not use @ symbol in password

KIBANA_PASSWORD=passwordsomething
FLUENTD_PASSWORD=scretesecond

```

```
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
```

# efk-client



docker run command ::

```
docker run --env-file /path/to/env-file -it --name <<container-name>> --hostname <<hostname>> <<img_name_configured_with_td-agent>> /bin/bash

```

environment variable ::

Create a file with the following variable

```
TD_CONF			        =		for configure td_agent use 'Y' or 'y'
TAG_NAME		        =		any name you want to see in web_ui for that log
LOG_FILE_PATH		    =		log file path for monitoring
ELASTIC_SERVER_HOST	=		efk server host ip
ELASTIC_SERVER_PORT	=		efk server port number (elasticsearch_port)
ELASTIC_USERNAME	  =		elasticsearch_fluentd connecting username
ELASTIC_PASSWORD	  =		elasticsearch_fluentd connecting user's password

```


example environment file  ::

```
TD_CONF=y
TAG_NAME=nohup
LOG_FILE_PATH=/var/log/nohup.out
ELASTIC_SERVER_HOST=192.168.1.235
ELASTIC_SERVER_PORT=5687
ELASTIC_USERNAME=<<fluentd_username in efk server>>
ELASTIC_PASSWORD=<<fluentd_password in efk server>>

```
