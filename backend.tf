terraform {
  backend "s3" {
    bucket         = "kdctl-bucket"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}
