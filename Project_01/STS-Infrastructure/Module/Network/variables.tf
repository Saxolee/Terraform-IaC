variable "name" {
  type        = string
  description = "The VPC name"
  default     = "sts-dev-vpc"
}

variable "sts_vpc_cidr_block" {
  type        = string
  description = "CIDR block of the vpc"
  default     = "10.0.0.0/16"
}

variable "sts_public_subnets_cidr_block" {
  type        = list
  description = "CIDR block for Public Subnet"
  default     = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

variable "sts_private_subnets_cidr_block" {
  type        = list
  description = "CIDR block for Private Subnet"
  default     = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  type        = list
  description = "AZ in which all the resources will be deployed"
}

variable "sts_vpc_tags" {
  description = "A map of tags to add to VPC"
  type        = map(string)
  default     = {}
}