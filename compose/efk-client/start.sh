#!/bin/bash
A=$(tput sgr0)
export TERM=xterm

if [[ ! -f /etc/td-agent/td-agent.conf-org ]];then
  if [[ $TD_CONF = [y,Y] ]];then
echo -e '\E[33m'"td-agent is configuring......! $A"
    if [[ $TAG_NAME = "" || $LOG_FILE_PATH = "" || $ELASTIC_SERVER_HOST = "" || $ELASTIC_SERVER_PORT = "" || $ELASTIC_USERNAME = "" || $ELASTIC_PASSWORD = "" ]];then
echo ""
echo -e '\E[32m'"Please provide all environment variable while run the 'docker run command' with -e option $A"
echo ""
echo ""
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"|    indeeded docker variable     | $A"
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"|    1)  TAG_NAME                 | $A"
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"|    2)  LOG_FILE_PATH            | $A"
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"|    3)  ELASTIC_SERVER_HOST      | $A"
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"|    4)  ELASTIC_SERVER_PORT      | $A"
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"|    5)  ELASTIC_USERNAME         | $A"
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"|    6)  ELASTIC_PASSWORD         | $A"
echo -e '\E[33m'"----------------------------------- $A"
echo ""
echo ""
exit 0
    else
cp /etc/td-agent/td-agent.conf /etc/td-agent/td-agent.conf-org

cat <<EOF> /etc/td-agent/td-agent.conf
<source>
  type tail
  format none
  time_format %b %d %H:%M:%S %Y
  pos_file  /var/log/td-agent/$TAG_NAME.pos
  path $LOG_FILE_PATH
  tag $TAG_NAME
</source>

<match $TAG_NAME>
    type elasticsearch
    host $ELASTIC_SERVER_HOST
    port $ELASTIC_SERVER_PORT
    include_tag_key true
    tag_key @log_name
    user $ELASTIC_USERNAME
    password $ELASTIC_PASSWORD
    index_name $TAG_NAME
    type_name $TAG_NAME
    logstash_prefix $TAG_NAME
    logstash_format true
    flush_interval 1s
</match>
EOF

touch /var/log/td-agent/$TAG_NAME.pos || echo "file exist"
chmod 777 /var/log/td-agent/$TAG_NAME.pos
chown -R td-agent:td-agent /var/log/td-agent/$TAG_NAME.pos
usermod -aG adm td-agent
    fi
  else
echo -e '\E[33m'"td-agent is not configuring......! $A"
  fi
fi


if [[ $TD_CONF = [y,Y] ]];then
echo ""
echo -e '\E[33m'"td-agent is already configured $A"
echo -e '\E[33m'"td-agent is starting $A"
echo ""
 if [[ ! -f $LOG_FILE_PATH ]];then
touch $LOG_FILE_PATH
 fi
chown -R :adm $LOG_FILE_PATH
chmod 774 $LOG_FILE_PATH
chown -R td-agent:td-agent /etc/td-agent
service td-agent restart
fi
