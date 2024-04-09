module "vpc" {
  source = "git::https://github.com/awsdevopsb01/tf-module-vpc.git"

  for_each   = var.vpc
  cidr_block = each.value["cidr_block"]
  subnets    = each.value["subnets"]
  tags       = local.tags
  env        = var.env
}

module "app" {
  source = "git::https://github.com/awsdevopsb01/tf-module-app.git"

  for_each = var.app
  instance_type = each.value["instance_type"]
  name = each.value["name"]
  desired_capacity = var.desired_capacity
  max_size= var.max_size
  min_size=var.min_size

  env=var.env
  bastion_cidr = var.bastion_cidr

  subnet_ids = lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["subnet_name"],null),"subnet_ids",null)
  app_cidr_block=lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["subnet_name"],null),"subnet_cidrs",null)
  vpc_id = lookup(lookup(module.vpc,"main",null ),"vpc_id",null)
}




#variable "app_cidr_block" {}
#variable "vpc_id" {}
