module "network" {
  source                         = "../modules/network"
  cidr                           = "10.162.0.0/16"
  tags                           = local.tags
  default_security_group_ingress = [{}]
  default_security_group_egress  = [{}]
}
