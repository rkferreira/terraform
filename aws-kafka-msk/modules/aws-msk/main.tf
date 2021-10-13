locals {
  configuration_info_arn      = var.configuration_info_arn != null ? var.configuration_info_arn : aws_msk_configuration.default.arn
  configuration_info_revision = var.configuration_info_revision != null ? var.configuration_info_revision : aws_msk_configuration.default.latest_revision
  default_configuration       = length(var.default_configuration) > 0 ? var.default_configuration : local.default_cfg
  default_cfg = [
    "auto.create.topics.enable=false",
    "min.insync.replicas=2",
    "num.io.threads=8",
    "num.network.threads=5",
    "num.partitions=1",
    "num.replica.fetchers=2",
    "replica.lag.time.max.ms=30000",
    "socket.receive.buffer.bytes=102400",
    "socket.request.max.bytes=104857600",
    "socket.send.buffer.bytes=102400",
    "unclean.leader.election.enable=true",
    "zookeeper.session.timeout.ms=18000",
    "default.replication.factor=${length(var.client_subnets)}"
  ]
  generated_secrets_ids  = [for k, v in module.msk-secrets : module.msk-secrets["${k}"].kafka_secret-arn]
  msk_available_versions = ["2.6.0", "2.6.1", "2.6.2", "2.7.0", "2.7.1", "2.8.0"]
}

resource "aws_appautoscaling_target" "msk_disk_autoscale" {
  max_capacity       = var.disk_autoscale_max
  min_capacity       = 1
  resource_id        = aws_msk_cluster.msk_cluster_kafka.arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"
}

# https://docs.aws.amazon.com/msk/latest/developerguide/msk-autoexpand.html
#
resource "aws_appautoscaling_policy" "msk_disk_autoscale_policy" {
  name               = "${var.cluster_name}-default"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_msk_cluster.msk_cluster_kafka.arn
  scalable_dimension = aws_appautoscaling_target.msk_disk_autoscale.scalable_dimension
  service_namespace  = aws_appautoscaling_target.msk_disk_autoscale.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "KafkaBrokerStorageUtilization"
    }
    target_value       = var.disk_autoscale_trigger
    disable_scale_in   = true
    scale_out_cooldown = 21600
  }
}

resource "aws_security_group" "kafka-sg" {
  name        = "kafka-sg"
  description = "SG para kafka cluster"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.sg_ingress
    content {
      description = ingress.value["description"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}

resource "aws_s3_bucket" "bucket_logs_kafka" {
  count  = var.bucket_name != null ? 1 : 0
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "logs_group_kafka" {
  name = "msk_broker_logs-${var.cluster_name}"
  tags = var.tags
}

resource "aws_kms_key" "default" {
  count       = var.secrets_kms_key_id != null ? 0 : 1
  description = "Key for MSK Cluster Scram Secret Association"
  is_enabled  = true
  tags        = var.tags
}

resource "aws_kms_alias" "default" {
  count         = var.secrets_kms_key_id != null ? 0 : 1
  name_prefix   = "alias/AmazonMSK-"
  target_key_id = aws_kms_key.default[0].key_id
}

module "msk-secrets" {
  source        = "./secrets"
  for_each      = var.secrets_map
  secret_suffix = each.key
  secret_value  = each.value
  kms_key_id    = var.secrets_kms_key_id != null ? var.secrets_kms_key_id : aws_kms_key.default[0].key_id
  tags          = var.tags
}

resource "aws_msk_scram_secret_association" "default" {
  cluster_arn     = aws_msk_cluster.msk_cluster_kafka.arn
  secret_arn_list = concat(local.generated_secrets_ids, var.extra_secrets_arn)
  depends_on      = [module.msk-secrets, aws_msk_cluster.msk_cluster_kafka]
}

resource "aws_msk_configuration" "default" {
  name              = "${var.cluster_name}-default"
  kafka_versions    = setunion(toset(local.msk_available_versions), toset(["${var.kafka_version}"]))
  server_properties = <<PROPERTIES
  %{for cfg in local.default_configuration}
    ${cfg}
  %{endfor}
  PROPERTIES  
}

resource "aws_msk_cluster" "msk_cluster_kafka" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  depends_on             = [aws_msk_configuration.default]

  dynamic "broker_node_group_info" {
    for_each = var.instance_type != null ? ["true"] : []
    content {
      instance_type   = var.instance_type
      ebs_volume_size = var.ebs_volume_size
      client_subnets  = var.client_subnets
      security_groups = concat([aws_security_group.kafka-sg.id], var.extra_security_groups)
    }
  }

  enhanced_monitoring = var.enhanced_monitoring

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.open_monitoring
      }
      node_exporter {
        enabled_in_broker = var.open_monitoring
      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = var.encryption_clientbroker
      in_cluster    = var.encryption_incluster
    }
  }

  client_authentication {
    sasl {
      scram = true
    }
  }

  dynamic "configuration_info" {
    for_each = ["true"]
    content {
      arn      = local.configuration_info_arn
      revision = local.configuration_info_revision
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.logs_group_kafka.name
      }
      s3 {
        enabled = var.bucket_name != null ? true : false
        bucket  = join("", aws_s3_bucket.bucket_logs_kafka.*.id)
        prefix  = var.bucket_prefix
      }
    }
  }
  tags = var.tags
}
