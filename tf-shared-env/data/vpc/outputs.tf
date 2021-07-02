output "vpc_cidr" {
  value = data.aws_vpc.vpc.cidr_block
}

output "subnet_private_ids" {
  value = data.aws_subnet_ids.private.ids
}

output "subnet_public_ids" {
  value = data.aws_subnet_ids.public.ids
}

output "subnet_db_ids" {
  value = data.aws_subnet_ids.db.ids
}
