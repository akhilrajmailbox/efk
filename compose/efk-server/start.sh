#!/bin/bash
A=$(tput sgr0)
export TERM=xterm


if [[ ! -f /etc/nginx/htpasswd.users ]];then
  if [[ "$HTPASSWORD" = "" ]];then
echo ""
echo -e '\E[32m'"Please provide all environment variable while run the 'docker run command' with -e option $A"
echo ""
echo ""
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"|    indeeded docker variable     | $A"
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"|    1)  HTPASSWORD               | $A"
echo -e '\E[33m'"----------------------------------- $A"
echo ""
echo "USERNAME : admin"
echo "PASSWORD : The password you are providing with 'HTPASSWORD' environment variable"
echo ""
exit 0
  else
sleep 1
  fi
htpasswd -b -c /etc/nginx/htpasswd.users admin $HTPASSWORD
fi





service elasticsearch restart
service kibana restart
service nginx restart
tailf /root/start.sh
