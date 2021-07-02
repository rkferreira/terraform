locals {
  default-msk_sg_ingress = [
    {
      from_port   = 9090
      to_port     = 9099
      protocol    = "TCP"
      description = "Kafka Service ports"
      cidr_blocks = ["${data.terraform_remote_state.infracore.outputs.vpc_cidr}"]
    },
    {
      from_port   = 2181
      to_port     = 2182
      protocol    = "TCP"
      description = "Zookeeper Service ports"
      cidr_blocks = ["${data.terraform_remote_state.infracore.outputs.vpc_cidr}"]
    }
  ]

  vpc_id                 = var.vpc_id != null ? var.vpc_id : data.terraform_remote_state.infracore.outputs.vpc_id
  subnet_ids             = length(var.subnet_ids) != 0 ? var.subnet_ids : data.terraform_remote_state.infracore.outputs.private_subnet_ids
  number_of_broker_nodes = var.msk_number_brokers != null ? var.msk_number_brokers : length(local.subnet_ids)
}

module "tags" {
  source = "app.terraform.io/xxx/tags/aws"

  vs          = var.vs
  environment = var.environment
  squad       = var.squad
  product     = var.product
  application = var.app
  tier        = var.tier
}

module "cluster-kafka" {
  source = "./modules/aws-msk"

  vpc_id                 = local.vpc_id
  bucket_name            = var.msk_s3_bucket
  cluster_name           = var.msk_cluster_name
  kafka_version          = var.msk_version
  number_of_broker_nodes = local.number_of_broker_nodes
  instance_type          = var.msk_instance_type
  ebs_volume_size        = var.msk_ebs_volume_size
  enhanced_monitoring    = var.msk_enhanced_monitoring
  client_subnets         = local.subnet_ids
  sg_ingress             = length(var.msk_sg_ingress) != 0 ? var.msk_sg_ingress : local.default-msk_sg_ingress
  extra_security_groups  = var.msk_extra_sgs
  default_configuration  = var.msk_default_configuration
  secrets_map            = var.msk_default_secrets_map
  extra_secrets_arn      = var.msk_extra_secrets_arn
  tags                   = module.tags.tags
}
