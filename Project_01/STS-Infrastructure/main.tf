module "Network" {
    source                     = "./module/network"
    name                       = "sts-dev-vpc"
    availability_zones         = local.availability_zones                     
}

module "Security_group" {
  source = "./module/security_group"
  vpc_id = module.network.vpc_id
}
