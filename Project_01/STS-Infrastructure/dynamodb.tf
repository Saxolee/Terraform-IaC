# Create dynamodb table to prevent file lock on remote file
resource "aws_dynamodb_table" "sts_terraform_locks" {
  name         = "sts-dev-terraform-state-locks-tbl"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}