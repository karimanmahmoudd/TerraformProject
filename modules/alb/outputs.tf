# An output containing the DNS name of the public ALB 
output "public_alb_dns" {
  value = aws_lb.public_alb.dns_name
}

# An output containing the DNS name of the private ALB
output "private_alb_dns" {
  value = aws_lb.internal_alb.dns_name
}

# An output containing the ARN of the public ALB 
output "public_alb_arn" {
  value       = aws_lb.public_alb.arn
}

# An output containing the ARN of the private ALB
output "private_alb_arn" {
  value       = aws_lb.internal_alb.arn
}
