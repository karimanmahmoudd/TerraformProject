# An output containing the ID of the NAT GW
output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}

# An output containing the ID of the RT
output "private_route_table_id" {
  value = aws_route_table.private.id
}

# An output containing the NAT GW EIP
output "nat_gateway_ips" {
  value = [aws_eip.nat.public_ip]
}
