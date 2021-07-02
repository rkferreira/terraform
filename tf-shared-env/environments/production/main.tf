locals {

  ## Main base
  vpc_data0 = element(var.vpc_data, 0)
  #
  vpc_cidr           = lookup(local.vpc_data0, "vpc_cidr")
  subnet_db_ids      = lookup(local.vpc_data0, "subnet_db_ids")
  subnet_private_ids = lookup(local.vpc_data0, "subnet_private_ids")
  subnet_public_ids  = lookup(local.vpc_data0, "subnet_public_ids")
}
