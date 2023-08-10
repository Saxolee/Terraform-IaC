output "vpc_id" {
  value = aws_vpc.sts_vpc.id
}

output "public_subnets_id" {
  value = [aws_subnet.sts_public_subnet.*.id]
}

output "private_subnets_id" {
  value = [aws_subnet.sts_private_subnet.*.id]
}


