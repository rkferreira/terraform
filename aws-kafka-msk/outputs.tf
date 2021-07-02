output "kafka_cluster-bootstrap_brokers_tls" {
  value = module.cluster-kafka.kafka_cluster-bootstrap_brokers_tls
}

output "kafka_cluster-bootstrap_brokers_scram" {
  value = module.cluster-kafka.kafka_cluster-bootstrap_brokers_scram
}

output "kafka_cluster-zookeeper" {
  value = module.cluster-kafka.kafka_cluster-zookeeper
}

output "kafka_cluster-current_version" {
  value = module.cluster-kafka.kafka_cluster-current_version
}
