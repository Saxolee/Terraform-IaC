output "s3_bucket_sts_terraform_state" {
  value = aws_s3_bucket.sts_terraform_state.bucket
}