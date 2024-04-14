output "vpc" {
  value = lookup(module.vpc,"main",null)
}

output "cidr" {
  value = lookup(lookup(lookup(module.vpc,"main",null ),"subnet_ids",null),"db",null)
}