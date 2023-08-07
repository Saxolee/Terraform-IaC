# Create a s3 bucket to store terraform state file
resource "aws_s3_bucket" "sts_terraform_state" {
    //NOTE: make sure the bucket name is global unique, otherwise the creation fails.
  bucket        = format("sts-dev-terraform-state-%s", local.region)
  force_destroy = false
# Prevent accidental deletion of this S3 bucket  
  lifecycle {
    ignore_changes = [bucket]
  }
  tags = {
    "Region" : local.region
    "Environment" : "DEV"
    "Project" : "STS_Cloud_Infrastructure"
  }
}

# Prevent public access to the s3 bucket
resource "aws_s3_bucket_public_access_block" "sts_terraform_state" {
  bucket                  = aws_s3_bucket.sts_terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# Create and enforce bucket ownership
resource "aws_s3_bucket_ownership_controls" "sts_terraform_state" {
  bucket = aws_s3_bucket.sts_terraform_state.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Enable versioning for protecting state files
resource "aws_s3_bucket_versioning" "sts_terraform_state" {
  bucket = aws_s3_bucket.sts_terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "sts_terraform_state" {
  bucket = aws_s3_bucket.sts_terraform_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}