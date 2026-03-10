terraform {
  backend "s3" {
    bucket         = "tfstate-ocp-aws-non-integrated"  # você cria no 00-backend
    key            = "dev/03-security.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}