# A variable that contains the public subnet IDs
variable "public_subnet_ids" {
  type = list(string)
}

# A variable that contains the private subnet IDs
variable "private_subnet_ids" {
  type = list(string)
}

# A variable that contains the proxy sg ID
variable "proxy_sg_id" {
  type = string
}

# A variable that contains the backend sg ID
variable "backend_sg_id" {
  type = string
}

# A variable that contains the name of the SSH key pair
variable "key_name" {
  type        = string
  default = "key-lab"
}

# A variable that contains the path to the backend application files
variable "backend_app_files" {
  type        = string
}