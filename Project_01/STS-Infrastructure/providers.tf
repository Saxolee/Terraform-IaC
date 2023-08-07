terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.8.0"
    }
  }
}

# Create remote backend for storing terraform state
terraform {
    backend "s3" {
      //NOTE: make sure the bucket exists
      bucket         = "sts-dev-terraform-state-eu-west-2"
      key            = "sts-dev-terraform/backend.tfstate"
      region         = "eu-west-2"
      dynamodb_table = "sts-dev-terraform-state-locks-tbl"
      encrypt        = true
    }
}
