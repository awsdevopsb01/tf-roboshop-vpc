output "vpc" {
  value = lookup(lookup(lookup(module.vpc,"main",null),"subnet_ids",null),"db",null)
}