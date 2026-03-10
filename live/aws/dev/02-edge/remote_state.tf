data "terraform_remote_state" "config" {
  backend = "s3"
  config = {
    bucket         = "tfstate-ocp-aws-non-integrated"
    key            = "dev/00-config.tfstate"
    region         = "us-east-2"
    encrypt        = true
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket         = "tfstate-ocp-aws-non-integrated"
    key            = "dev/01-network.tfstate"
    region         = "us-east-2"
    encrypt        = true
  }
}