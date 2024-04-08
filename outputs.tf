output "vpc" {
  value = lookup(lookup(module.vpc,"main",null),"subnet_ids",null)
}