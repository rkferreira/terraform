# Terraform MSK repository


## Terraform resources

[aws_msk_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster)

[msk_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_configuration)

[msk_scram_secret_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_scram_secret_association)


## MSK references

[Amazon Managed Streaming for Apache Kafka Documentation](https://docs.aws.amazon.com/msk/index.html)

[Best Practices](https://docs.aws.amazon.com/msk/latest/developerguide/bestpractices.html)

[MSK Sizing calculator](https://amazonmsk.s3.amazonaws.com/MSK_Sizing_Pricing.xlsx)

[AWS re:Invent 2018: MSK Launch](https://www.youtube.com/watch?v=zhsVfsykBHc)

[AWS re:Invent 2020: Guide to Apache Kafka replication and migration with Amazon MSK](https://www.youtube.com/watch?v=CmcJb9Ge3jI)

[AWS Online Tech Talks: Introduction to Amazon Managed Streaming for Kafka](https://www.youtube.com/watch?v=9nKswHsLseY)

[AWS Online Tech Talks: Best Practices for Provisioning Amazon MSK Clusters & Using Popular Apache Kafka-Compatible Tooling](https://www.youtube.com/watch?v=4C_FT2Ie9E4)


## Kafka client tests

Simple test using kafka client.

* Download Apache Kafka
  * [Apache Kafka Download](https://kafka.apache.org/downloads)

* Build it
  * doesnt work with JDK 16, use 11 and gradle 6.X (comes with gradle wrapper)

```
./gradlew jar
```

* Creating topics thru zookeeper

  * [Controlling Access to Apache ZooKeeper](https://docs.aws.amazon.com/msk/latest/developerguide/zookeeper-security.html)

```
PLAINTEXT (port: 2181)

../bin/kafka-topics.sh --create --zookeeper z-2.xxx:2181,z-3.xxx:2181,z-1.xxx:2181 --replication-factor 3 --partitions 1 --topic TEST_PLAIN
```

```
SASL (port: 2182)

cp /Library/Java/JavaVirtualMachines/jdk-11.0.11.jdk/Contents/Home/lib/security/cacerts /tmp/truststore.jks

export
KAFKA_OPTS="
-Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty
-Dzookeeper.client.secure=true
-Dzookeeper.ssl.trustStore.location=/tmp/truststore.jks
-Dzookeeper.ssl.trustStore.password=changeit"

../bin/kafka-topics.sh --create --zookeeper z-2.xxx:2182,z-3.xxx:2182,z-1.xxx:2182 --replication-factor 3 --partitions 1 --topic TEST_TLS
```

* Producing messages

  * [Username and password authentication with AWS Secrets Manager](https://docs.aws.amazon.com/msk/latest/developerguide/msk-password.html)

```
cat << __END__ > /tmp/users_jaas.conf
KafkaClient {
   org.apache.kafka.common.security.scram.ScramLoginModule required
   username="admin"
   password="xxxxx";
};
__END__

cat << __END__ > /tmp/client_sasl.properties
security.protocol=SASL_SSL
sasl.mechanism=SCRAM-SHA-512
ssl.truststore.location=/tmp/truststore.jks
__END__

```

```
export KAFKA_OPTS=-Djava.security.auth.login.config=/tmp/users_jaas.conf

../bin/kafka-console-producer.sh --broker-list b-1.xxx:9096,b-3.xxx:9096,b-5.xxx:9096 --topic TEST --producer.config /tmp/client_sasl.properties
```

* Consuming messages
  * same files needed as for producing

```
../bin/kafka-console-consumer.sh --bootstrap-server b-1.xxx:9096,b-3.xxx:9096,b-5.xxx:9096 --topic TEST --from-beginning --consumer.config /tmp/client_sasl.properties
```

