# Return the ID of the proxy SG
output "proxy_sg_id" {
  value = aws_security_group.proxy.id
}

# Return the ID of the backend SG
output "backend_sg_id" {
  value = aws_security_group.backend.id
}

# Return the ID of the ALB SG
output "alb_sg_id" {
  value = aws_security_group.alb.id
}