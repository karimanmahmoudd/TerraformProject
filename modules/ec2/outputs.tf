# The IDs of the frontend instances
output "proxy_instances" {
  value = aws_instance.proxy[*].id
}

# The IDs of the backend instances
output "backend_instances" {
  value = aws_instance.backend[*].id
}

# The IDs of the public IPs of the proxy instances
output "proxy_public_ips" {
  value = aws_instance.proxy[*].public_ip
}

# The IDs of the private IPs of the backend instances
output "backend_private_ips" {
  value = aws_instance.backend[*].private_ip
}

output "proxy_instance_ids" {
  value = [for instance in aws_instance.proxy : instance.id]
}

output "backend_instance_ids" {
  value = [for instance in aws_instance.backend : instance.id]
}
