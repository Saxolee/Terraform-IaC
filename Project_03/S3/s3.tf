# Create Bucket
resource "aws_s3_bucket" "sts_storage_bucket" {
    bucket = vars.sts_storage_new_bucket_name
}


# Set encryption with KMS Key to Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "sts_storage_bucket_encryption" {
    bucket = aws_s3_bucket.sts_storage_bucket.bucket

    rule {
        apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.sts_storage_key
        sse_algorithm     = "aws:kms"
        }
    }
}

# Create Bucket Public Access
resource "aws_s3_bucket_public_access_block" "sts_storage_bucket_block" {
    bucket                  = aws_s3_bucket.sts_storage_new_bucket_name.id
    block_public_acls       = vars.sts_bucket_block_public_acl
    block_public_policy     = vars.sts_bucket_block_public_policy
    ignore_public_acls      = vars.sts_bucket_ignore_public_acls
    restrict_public_buckets = vars.sts_bucket_restrict_public_buckets
}

# Create Bucket ACL
resource "aws_s3_bucket_acl" "sts_storage_bucket_acl" {
    bucket = aws_s3_bucket.sts_storage_new_bucket_name.id
    acl    = vars.sts_bucket_acl
}


# Create Bucket Policy
resource "aws_s3_bucket_policy" "sts_storage_bucket_policy" {
    bucket = aws_s3_bucket.sts_storage_new_bucket_name.id
    policy = data.aws_iam_policy_document.sts_storage_bucket_policy.json
}

data "aws_iam_policy_document" "sts_storage_bucket_policy" {
    statement {
        principals {
            type        = "Service"
            identifiers = ["s3.amazonaws.com"]
        }
        actions = [
            "s3:GetObject",
            "s3:ListBucket",
        ]
        resources = "*"
    }
}

# Create Event Notification
resource "aws_s3_bucket_notification" "sts_storage_bucket_notification" {
    bucket = aws_s3_bucket.sts_storage_bucket_name.id
    queue {
        queue_arn     = aws_sqs_queue.queue.arn
        events        = ["s3:ObjectCreated:*"]
        filter_suffix = ".log"
    }
}

# Apply Lifecycle rule
resource "aws_s3_bucket_lifecycle_configuration" "sts_storage_bucket_lifecycle" {
    bucket = aws_s3_bucket.sts_storage_bucket_name.id
    rule {
        id = "14day - expiration rule"
        expiration {
            days = 14
        }
        status = vars.sts_bucket_lifecycle 
    }
}

# Apply CORS
resource "aws_s3_bucket_cors_configuration" "sts_storage_bucket_cors_configuration" {
    bucket = aws_s3_bucket.sts_storage_bucket_name.id
    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["GET"]
        allowed_origins = ["https://saxoleetech.com"]
    }
}

# Create S3 Versioning
resource "aws_s3_bucket_versioning" "sts_storage_bucket_versioning" {
    bucket = aws_s3_bucket.sts_storage_bucket_name.id
    versioning_configuration {
        status = vars.sts_bucket_versioning 
    }
}


