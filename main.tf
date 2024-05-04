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

module "docdb" {
  source = "git::https://github.com/awsdevopsb01/tf-module-docdb.git"

  for_each = var.docdb
  subnets = lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["subnet_name"],null),"subnet_ids",null)
  allow_db_cidr = lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["allow_db_cidr"],null),"subnet_cidrs",null)
  engine_version = each.value["engine_version"]
  instance_count = each.value["instance_count"]
  instance_class = each.value["instance_class"]

  env=var.env
  tags = local.tags
  vpc_id = local.vpc_id
  kms_arn = var.kms_arn

}

module "rds" {
  source = "git::https://github.com/awsdevopsb01/tf-module-rds.git"

  for_each = var.rds
  subnets = lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["subnet_name"],null),"subnet_ids",null)
  allow_db_cidr = lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["allow_db_cidr"],null),"subnet_cidrs",null)
  engine_version = each.value["engine_version"]
  instance_count = each.value["instance_count"]
  instance_class = each.value["instance_class"]

  env = var.env
  tags = local.tags
  vpc_id = local.vpc_id
  kms_arn = var.kms_arn

}

module "elasticache" {
  source = "git::https://github.com/awsdevopsb01/tf-module-elasticache.git"

  for_each = var.elasticache
  subnets  = lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["subnet_name"],null),"subnet_ids",null)
  allow_db_cidr  = lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["allow_db_cidr"],null),"subnet_cidrs",null)
  engine_version = each.value["engine_version"]
  num_node_groups         = each.value["num_node_groups"]
  replicas_per_node_group = each.value["replicas_per_node_group"]
  node_type               = each.value["node_type"]

  env  = var.env
  tags = local.tags
  vpc_id  = local.vpc_id
  kms_arn = var.kms_arn

}

module "rabbitmq" {
  source = "git::https://github.com/awsdevopsb01/tf-module-amazon-mq.git"

  for_each = var.rabbitmq
  subnets  = lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["subnet_name"],null),"subnet_ids",null)
  allow_db_cidr  = lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["allow_db_cidr"],null),"subnet_cidrs",null)
  instance_type = each.value["instance_type"]

  env  = var.env
  tags = local.tags
  vpc_id  = local.vpc_id
  kms_arn = var.kms_arn
  bastion_cidr=var.bastion_cidr

}

module "alb" {
  source = "git::https://github.com/awsdevopsb01/tf-module-alb.git"

  for_each = var.alb
  subnets  = lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["subnet_name"],null),"subnet_ids",null)
  allow_alb_cidr  = each.value["name"] == "public" ? ["0.0.0.0/0"] : lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["allow_alb_cidr"],null),"subnet_cidrs",null)
  internal = each.value["internal"]
  name = each.value["name"]

  env  = var.env
  tags = local.tags
  vpc_id  = local.vpc_id

}

module "app" {
  depends_on = [module.docdb, module.vpc, module.rds, module.elasticache, module.rabbitmq, module.alb]
  source = "git::https://github.com/awsdevopsb01/tf-module-app.git"

  for_each = var.app
  instance_type = each.value["instance_type"]
  name          = each.value["name"]
  desired_capacity = each.value["desired_capacity"]
  max_size      = each.value["max_size"]
  min_size      = each.value["min_size"]
  app_port      = each.value["app_port"]
  dns_name      = each.value["dns_name"]

  subnet_ids    = lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["subnet_name"],null),"subnet_ids",null)
  allow_app_cidr= lookup(lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),each.value["allow_app_cidr"],null),"subnet_cidrs",null)
  listener_arn  = lookup(lookup(module.alb,each.value["lb_type"],null ),"listener_arn",null)
  dns_name      = lookup(lookup(module.alb,each.value["lb_type"],null ),"dns_name",null)
  vpc_id        = local.vpc_id

  domain_id     = var.domain_id
  env           = var.env
  bastion_cidr  = var.bastion_cidr
  tags          = local.tags

}
