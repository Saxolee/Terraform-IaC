# Create KMS Key resource block
resource "aws_kms_key" "sts_storage_key" {
  description              = vars.sts_kms_descriptrion 
  key_usage                = "SIGN_VERIFY"
  deletion_window_in_days  = 7
  enable_key_rotation      = false
  customer_master_key_spec = "RSA_4096"
}

# Create an Alias for the KMS Key
resource "aws_kms_alias" "sts_storage_key_alias" {
  name          = vars.sts_kms_alias
  target_key_id = aws_kms_key.sts_storage_key.key_id
}
