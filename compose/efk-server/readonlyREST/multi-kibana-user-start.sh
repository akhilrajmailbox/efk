#!/bin/bash
A=$(tput sgr0)
export TERM=xterm


if [[ ! -f /etc/elasticsearch/elasticsearch.yml-org ]];then
  if [[ $KIBANA_RO_PASSWORD = "" || $FLUENTD_PASSWORD = "" || $KIBANA_ADMIN_PASSWORD = "" ]];then
echo ""
echo -e '\E[32m'"Please provide all environment variable while run the 'docker run command' with -e option $A"
echo ""
echo ""
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"|    indeeded docker variable     | $A"
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"|    1)  KIBANA_RO_PASSWORD       | $A"
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"|    2)  KIBANA_ADMIN_PASSWORD    | $A"
echo -e '\E[33m'"----------------------------------- $A"
echo -e '\E[33m'"|    3)  FLUENTD_PASSWORD         | $A"
echo -e '\E[33m'"----------------------------------- $A"
echo ""
echo "USERNAME : kibanadmin"
echo "PASSWORD : The password you are providing with 'KIBANA_ADMIN_PASSWORD' environment variable"
echo "This is the user have admin privilege on kibana"
echo ""
echo "USERNAME : kibana"
echo "PASSWORD : The password you are providing with 'KIBANA_RO_PASSWORD' environment variable"
echo "This is the user for elasticsearch and kibana connection"
echo ""
echo "USERNAME : admin"
echo "PASSWORD : The password you are providing with 'FLUENTD_PASSWORD' environment variable"
echo "This is the user for elasticsearch and fluentd connection"
echo ""
exit 0
  else
cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml-org
cat <<EOF>> /etc/elasticsearch/elasticsearch.yml
readonlyrest:
    enable: true
    response_if_req_forbidden: <h1>Forbidden</h1>
    access_control_rules:

    - name: Kibana Server (we trust this server side component, full access granted via HTTP authentication, this is the user have admin privilege on kibana)
      auth_key: kibanadmin:$KIBANA_ADMIN_PASSWORD
      type: allow

    - name: Kibana Server (we trust this server side component, full access granted via HTTP authentication, this is the user for elasticsearch and kibana server connection)
      auth_key: kibana:$KIBANA_RO_PASSWORD
      kibana_access: ro
      type: allow

    - name: fluentd Client (this user can write and create its own indices, this is the user for elasticsearch and fluentd connection)
      auth_key: admin:$FLUENTD_PASSWORD
      type: allow
      actions: ["indices:data/read/*","indices:data/write/*","indices:admin/template/*","indices:admin/create"]
      indices: ["*"]
EOF

cat <<EOF>> /opt/kibana/config/kibana.yml
elasticsearch.username: "kibanadmin"
elasticsearch.password: "$KIBANA_ADMIN_PASSWORD"
EOF

  fi
fi


service elasticsearch restart
service kibana restart
tailf /root/start.sh
