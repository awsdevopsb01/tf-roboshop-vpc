output "vpc" {
  value = lookup(lookup(lookup(lookup(module.vpc,"main",null),"subnet_ids",null),"app",null),"subnet_ids",null)
}