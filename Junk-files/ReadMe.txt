How to use

In 1st instance
docker build -f Dockerfile-zookeeper-1 -t zookeeper-image-1:latest .
docker build -f Dockerfile-kafka-1 -t kafka1-image-2:latest .

docker run -d --name zookeeper1 --network host zookeeper-image-1:latest
docker run -d --name kafka1 --network host kafka1-image-2:latest



In 2nd instance
docker build -f Dockerfile-zookeeper-2 -t zookeeper-image-2:latest .
docker build -f Dockerfile-kafka-2 -t kafka1-image-2:latest .

docker run -d --name zookeeper2 --network host zookeeper-image-2:latest
docker run -d --name kafka2 --network host kafka1-image-2:latest 



docker run -dit --network host --name zookeeper ubuntu sleep infinity
docker run -dit --network host --name zookeeper openjdk:8-jre sleep infinity


172.31.32.34


echo "172.31.32.34 kafka1" >> /etc/hosts
echo "172.31.32.60 kafka1" >> /etc/hosts

apt update -y &&  apt install openjdk-21-jdk -y # need to enter 5 and 44 for geo and time zone location

apt update && apt install -y wget

wget https://dlcdn.apache.org/zookeeper/zookeeper-3.9.3/apache-zookeeper-3.9.3-bin.tar.gz
tar -xvzf apache-zookeeper-3.9.3-bin.tar.gz 
mv apache-zookeeper-3.9.3-bin /opt/zookeeper

 mkdir -p /opt/zookeeper/data
 chmod 755 /opt/zookeeper/data
 echo 2 > /opt/zookeeper/data/myid 
 chmod 644 /opt/zookeeper/data/myid


cat <<EOF > /opt/zookeeper/conf/zoo.cfg
tickTime=2000
dataDir=/opt/zookeeper/data
clientPort=2181
initLimit=10
syncLimit=5
maxClientCnxns=0
admin.enableServer=false
server.1=172.31.32.34:2888:3888
server.2=172.31.32.60:2888:3888
server.3=172.31.32.95:2888:3888
EOF


/opt/zookeeper/bin/zkServer.sh start
/opt/zookeeper/bin/zkServer.sh status
tail /opt/zookeeper/logs/zookeeper--server-ip-172-31-32-60.out


docker run -dit --network host --name kafka ubuntu sleep infinity
docker run -dit --network host --name kafka openjdk:8-jre sleep infinity

echo "172.31.32.34 kafka1" >> /etc/hosts
echo "172.31.32.60 kafka2" >> /etc/hosts
 echo "172.31.32.95 kafka3" >> /etc/hosts

apt update -y &&  apt install openjdk-21-jdk -y # need to enter 5 and 44 for geo and time zone location

apt update && apt install -y wget


wget https://archive.apache.org/dist/kafka/1.1.1/kafka_2.12-1.1.1.tgz
tar -xvf kafka_2.12-1.1.1.tgz
mv kafka_2.12-1.1.1 kafka
rm apache-zookeeper-3.9.3-bin.tar.gz kafka_2.12-1.1.1.tgz




mv /opt/kafka/config/server.properties /opt/kafka/config/server.properties.backup

touch /opt/kafka/config/server.properties
ls /opt/kafka/config/


cat <<EOF > /opt/kafka/config/server.properties
broker.id=2
listeners=PLAINTEXT://172.31.32.60:9092
advertised.listeners=PLAINTEXT://172.31.32.60:9092 
log.dirs=/opt/kafka/logs 
zookeeper.connect=172.31.32.34:2181,172.31.32.60:2181,172.31.32.95:2181
num.partitions=2
default.replication.factor=2 
min.insync.replicas=2 
auto.create.topics.enable=true 
log.retention.hours=168 
log.segment.bytes=1073741824 
log.retention.check.interval.ms=300000
EOF

/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties

/opt/kafka/bin/kafka-server-stop.sh -daemon /opt/kafka/config/server.properties


# Create a topic
/opt/kafka/bin/kafka-topics.sh --create \
  --zookeeper 172.31.32.34:2181,172.31.32.60:2181 \
  --replication-factor 2 \
  --partitions 2 \
  --topic test-topic-from-kafka1

