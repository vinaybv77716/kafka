# use this image : docker run -dit --network host --name zookeeper openjdk:8-jre sleep infinity

# execute this comands :
# echo "172.31.32.34 kafka1" >> /etc/hosts
# echo "172.31.32.60 kafka1" >> /etc/hosts
# apt update && apt install -y wget
# wget https://dlcdn.apache.org/zookeeper/zookeeper-3.9.3/apache-zookeeper-3.9.3-bin.tar.gz
# tar -xvzf apache-zookeeper-3.9.3-bin.tar.gz 
# mv apache-zookeeper-3.9.3-bin /opt/zookeeper
#  mkdir -p /opt/zookeeper/data
#  chmod 755 /opt/zookeeper/data
#  echo 1 > /opt/zookeeper/data/myid 
#  chmod 644 /opt/zookeeper/data/myid
# cat <<EOF > /opt/zookeeper/conf/zoo.cfg
# tickTime=2000
# dataDir=/opt/zookeeper/data
# clientPort=2181
# initLimit=10
# syncLimit=5
# maxClientCnxns=0
# admin.enableServer=false
# server.1=172.31.32.34:2888:3888
# server.2=172.31.32.60:2888:3888
# EOF


# Start the container : /opt/zookeeper/bin/zkServer.sh start

# use network host to connect to zookeeper 


FROM openjdk:8-jre

WORKDIR /opt

RUN apt-get update && \    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://dlcdn.apache.org/zookeeper/zookeeper-3.9.3/apache-zookeeper-3.9.3-bin.tar.gz && \    tar -xvzf apache-zookeeper-3.9.3-bin.tar.gz && \
    mv apache-zookeeper-3.9.3-bin /opt/zookeeper

RUN mkdir -p /opt/zookeeper/data && \
    chmod 755 /opt/zookeeper/data && \
    echo 3 > /opt/zookeeper/data/myid && \
    chmod 644 /opt/zookeeper/data/myid && \
    touch /opt/zookeeper/conf/zoo.cfg
COPY zoo.cfg /opt/zookeeper/conf/

EXPOSE 2181 2888 3888

CMD ["/opt/zookeeper/bin/zkServer.sh", "start-foreground"]

