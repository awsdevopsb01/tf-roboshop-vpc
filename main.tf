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
#  allow_app_cidr=lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["allow_app_cidr"],null),"subnet_cidrs",null)
#  vpc_id = local.vpc_id
#}


module "docdb" {
  source = "git::https://github.com/awsdevopsb01/tf-module-docdb.git"

  for_each = var.docdb
  subnets = lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["subnet_name"],null),"subnet_ids",null)
  allow_db_cidr=lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["allow_db_cidr"],null),"subnet_cidrs",null)
  engine_version = each.value["engine_version"]
  instance_count = each.value["instance_count"]
  instance_class = each.value["instance_class"]

  env=var.env
  tags = local.tags
  vpc_id = local.vpc_id
  kms_arn = var.kms_arn

}
