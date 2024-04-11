module "vpc" {
  source = "git::https://github.com/awsdevopsb01/tf-module-vpc.git"

  for_each   = var.vpc
  cidr_block = each.value["cidr_block"]
  subnets    = each.value["subnets"]
  tags       = local.tags
  env        = var.env
  default_vpc_id = var.default_vpc_id
  default_vpc_cidr = var.default_vpc_cidr
  default_vpc_rtb = var.default_vpc_rtb
}

#module "app" {
#  source = "git::https://github.com/awsdevopsb01/tf-module-app.git"
#
#  for_each = var.app
#  instance_type = each.value["instance_type"]
#  name = each.value["name"]
#  desired_capacity = each.value["desired_capacity"]
#  max_size= each.value["max_size"]
#  min_size=each.value["min_size"]
#
#  env=var.env
#  bastion_cidr = var.bastion_cidr
#
#  subnet_ids = lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["subnet_name"],null),"subnet_ids",null)
#  allow_app_cidr=lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["subnet_name"],null),"subnet_cidrs",null)
#  vpc_id = lookup(lookup(module.vpc,"main",null ),"vpc_id",null)
#}


module "docdb" {
  source = "git::https://github.com/awsdevopsb01/tf-module-docdb.git"

  for_each = var.app
  instance_type = each.value["instance_type"]
  name = each.value["name"]

  env=var.env

  engine_version = var.engine_version
  subnet_ids = lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["subnet_name"],null),"subnet_ids",null)
  allow_db_cidr=lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["subnet_name"],null),"subnet_cidrs",null)
  vpc_id = lookup(lookup(module.vpc,"main",null ),"vpc_id",null)
}


#variable "kms_arn" {}
#variable "tags" {}
#variable "allow_db_cidr" {}
