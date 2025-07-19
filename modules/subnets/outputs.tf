# Gets the IDs of the public subnets
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

# Gets the IDs of the private subnets
output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

# Gets the CIDR blocks of the public subnets
output "public_subnet_cidr_blocks" {
  value       = aws_subnet.public[*].cidr_block
}

# Gets the CIDR blocks of the private subnets
output "private_subnet_cidr_blocks" {
  value       = aws_subnet.private[*].cidr_block
}
