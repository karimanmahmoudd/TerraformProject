# A variable containing the IDs of the proxy EC2 instances
variable "proxy_instance_ids" {
  type = list(string)
}

# A variable containing the IDs of the backend EC2 instances
variable "backend_instance_ids" {
  type = list(string)
}

# A variable containing the proxy sg id
variable "proxy_sg_id" {
  type = string
}

# A variable containing the backend sg ID
variable "backend_sg_id" {
  type = string
}

# A variable containing the VPC ID
variable "vpc_id" {
  type = string
}

# A variable containing the public subnets IDs
variable "public_subnet_ids" {
  type = list(string)
}

# A variable containing the private subnets IDs
variable "private_subnet_ids" {
  type = list(string)
}
