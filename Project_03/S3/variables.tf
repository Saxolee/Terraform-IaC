variable "sts_kms_descriptrion" {
  type    = string
  default = "Managed KMS key for S3 data encryption"
}

variable "sts_kms_alias" {
  type    = string
  default = "alias/sts_storage_key"
}

variable "sts_storage_new_bucket_name" {
  type    = string
  default = "sts-storage-bucket"
}

variable "sts_bucket_block_public_acl" {
  type    = bool
  default = true
}

variable "sts_bucket_block_public_policy" {
  type    = bool
  default = true
}

variable "sts_bucket_ignore_public_acls" {
  type    = bool
  default = true
}

variable "sts_bucket_restrict_public_buckets" {
  type    = bool
  default = true
}

variable "sts_bucket_acl" {
  type    = string
  default = "private"
}

variable "sts_bucket_lifecycle" {
  type    = string
  default = "Enabled"
}

variable "sts_bucket_versioning" {
  type    = string
  default = "Enabled"
}

variable sts_sqs_delay_seconds {
  type    = int
  default = 5
}

variable sts_sqs_max_message_size {
  type    = int
  default = 2048
}

variable  sts_sqs_message_retention_seconds {
  type    = int
  default = 86000
}

variable sts_sqs_visibility_timeout_seconds {
    type    = int
    default = 200
}

variable  sts_sqs_receive_wait_time_seconds {
  type    = int
  default = 10
}
