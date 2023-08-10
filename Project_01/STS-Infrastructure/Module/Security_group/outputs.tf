output "security_groups_ids" {
  value = aws_security_group.sts_security_group.id
}