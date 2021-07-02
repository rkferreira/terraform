#########################################
## Main
#


#########################################
## Locals
#

locals {
  common_tags = {
    VS          = var.vs
    Environment = var.environment
    Squad       = var.squad
    Product     = var.product
    App         = var.application
    Tier        = var.tier
  }

  environment = var.environment == terraform.workspace ? var.environment : "mismatch"
}


#########################################
## Environments
#

module "env-development" {
  source       = "./environments/development"
  count        = local.environment == "development" ? 1 : 0
  depends_on   = [module.data_vpc, module.common]
  vpc_data     = module.data_vpc
  vpc_id       = var.vpc_id
  key_name     = var.key_name
  ami          = var.ami-us
  net_internal = var.network_internals
  tags         = local.common_tags
  # extra
  common = module.common
}

module "env-homologation" {
  source       = "./environments/homologation"
  count        = local.environment == "homologation" ? 1 : 0
  depends_on   = [module.data_vpc]
  vpc_data     = module.data_vpc
  vpc_id       = var.vpc_id
  key_name     = var.key_name
  ami          = var.ami-us
  net_internal = var.network_internals
  tags         = local.common_tags
  # extra
  common = module.common
}

module "env-production" {
  source     = "./environments/production"
  count      = local.environment == "production" ? 1 : 0
  depends_on = [module.data_vpc]
  vpc_data   = module.data_vpc
}

module "common" {
  source       = "./environments/common"
  count        = local.environment != "mismatch" ? 1 : 0
  depends_on   = [module.data_vpc]
  vpc_data     = module.data_vpc
  vpc_id       = var.vpc_id
  key_name     = var.key_name
  ami          = var.ami-us
  net_internal = var.network_internals
  tags         = local.common_tags
}


#########################################
## Data
#

module "data_vpc" {
  source = "./data/vpc"
  count  = local.environment != "mismatch" ? 1 : 0
  vpc_id = var.vpc_id
}
