data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket         = "tfstate-ocp-aws-non-integrated"
    key            = "dev/01-network.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tfstate-locks"
    encrypt        = true
  }
}