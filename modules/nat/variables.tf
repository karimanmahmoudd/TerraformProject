# Variable that contains the public subnets to be used for the NAT GW
variable "public_subnet_ids" {
  type = list(string)
}

# Variable that contains the private subnets to be used for the NAT GW
variable "private_subnet_ids" {
  type = list(string)
}

# Variable containing the VPC ID
variable "vpc_id" {
  type = string
}
