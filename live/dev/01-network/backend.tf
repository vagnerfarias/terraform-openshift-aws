terraform {
  backend "s3" {
    bucket         = "tfstate-ocp-aws-non-integrated"
    key            = "dev/01-network.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}