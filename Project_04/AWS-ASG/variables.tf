variable "sts_asg_inbound_ec2" {
  type        = list(any)
  default     = [22, 80]
  description = "inbound port allow on production instance"
}

variable "sts_asg_instance_type" {
    type    = string
    default = "t2.micro"
}

variable "sts_asg_ami" {
    type    = string
    default = "ami-0eb260c4d5475b901"
}

variable "sts_asg_key_name" {
    type    = string
    default = "saxolee-key-pair"
}

variable "sts_asg_availability_zone" {
    type    = list(string)
    default = ["eu-west-2a", "eu-west-2b"]
}

variable "sts_asg_vpc_cidr" {
    type    = string
    default = "10.0.0.0/16"
}

variable "sts_asg_pub_subnet_cidrs" {
    type        = list(string)
    description = "list of all cidr for subnet"
    default     = ["10.0.1.0/24", "10.0.3.0/24"]
}
