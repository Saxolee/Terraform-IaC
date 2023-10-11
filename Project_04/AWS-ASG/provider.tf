provider "aws" {
    region = "eu-west-2"
}

terraform {
    required_version = ">= 1.2.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = ">= 4.8.0"
        }
    }
}
