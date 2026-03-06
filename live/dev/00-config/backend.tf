terraform {
  backend "s3" {
    bucket         = "tfstate-ocp-aws-non-integrated"
    key            = "dev/00-config.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}