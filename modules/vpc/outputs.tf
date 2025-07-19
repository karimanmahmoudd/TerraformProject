# Getting the ID of the VPC
output "vpc_id" {
  value = aws_vpc.main.id
}

# Getting the ID of the IGW
output "igw_id" {
  value = aws_internet_gateway.igw.id
}
