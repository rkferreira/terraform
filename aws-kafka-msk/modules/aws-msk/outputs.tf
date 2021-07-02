output "kafka_sg-id" {
  value = aws_security_group.kafka-sg.id
}

output "kafka_s3-arn" {
  value = join("", aws_s3_bucket.bucket_logs_kafka.*.arn)
}

output "kafka_cluster-bootstrap_brokers_tls" {
  value = aws_msk_cluster.msk_cluster_kafka.bootstrap_brokers_tls
}

output "kafka_cluster-bootstrap_brokers_scram" {
  value = aws_msk_cluster.msk_cluster_kafka.bootstrap_brokers_sasl_scram
}

output "kafka_cluster-zookeeper" {
  value = aws_msk_cluster.msk_cluster_kafka.zookeeper_connect_string
}

output "kafka_cluster-current_version" {
  value = aws_msk_cluster.msk_cluster_kafka.current_version
}

