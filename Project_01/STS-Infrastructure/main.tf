module "Network" {
    source                     = "./module/network"
    name                       = "sts-dev-vpc"
    availability_zones         = local.availability_zones                     
}
