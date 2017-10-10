FROM java-img
MAINTAINER Akhil Raj <akhilmailbox@gmail.com>
RUN apt-get update

# elastisearch installation
# RUN wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.4.3/elasticsearch-2.4.3.deb
WORKDIR /root
ADD elasticsearch-2.4.3.deb /root/elasticsearch-2.4.3.deb
ADD readonlyrest-1.13.0_es2.4.3.zip /root/readonlyrest-1.13.0_es2.4.3.zip
RUN dpkg -i elasticsearch-2.4.3.deb
RUN sh -c 'echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml'
RUN sh -c 'echo "http.port: 9200" >> /etc/elasticsearch/elasticsearch.yml'
WORKDIR /usr/share/elasticsearch
RUN bin/plugin install mobz/elasticsearch-head
# readonly configuration
RUN DEBIAN_FRONTEND=noninteractive bin/plugin install file:/root/readonlyrest-1.13.0_es2.4.3.zip
WORKDIR /root

# kibana installation
RUN sh -c 'echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" | tee -a /etc/apt/sources.list.d/kibana-4.4.x.list'
RUN apt-get update
RUN apt-get install -y kibana --allow-unauthenticated

RUN sh -c 'echo "server.host: 0.0.0.0" >> /opt/kibana/config/kibana.yml'
RUN sh -c 'echo "server.port: 5601 " >> /opt/kibana/config/kibana.yml'

RUN locale-gen en_US.UTF-8
RUN locale-gen
RUN export LC_ALL=en_US.UTF-8
#ADD single-kibana-user-start.sh /root/start.sh
ADD multi-kibana-user-start.sh /root/start.sh
RUN chmod a+x /root/start.sh

ENTRYPOINT "/root/start.sh"
