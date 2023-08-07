locals {
  name                       = var.name
  cidr_block                 = var.sts_vpc_cidr_block
  public_subnets_cidr_block  = var.sts_public_subnets_cidr_block
  private_subnets_cidr_block = var.sts_private_subnets_cidr_block
  availability_zones         = var.availability_zones
  tags                       = var.sts_vpc_tags
}