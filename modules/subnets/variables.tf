# A variable containing the VPC in which the subnet will be created in
variable "vpc_id" {
  type = string
}

# The list of availability zones in the root main
variable "azs" {
  type = list(string)
}

# A Variable containing the internet gateway that will be used by the public subnet
variable "internet_gateway_id" {
  type = string
}

# A Variable containing the NAT gateway that will be used by the private subnet
variable "nat_gateway_id" {
  type = string
}
