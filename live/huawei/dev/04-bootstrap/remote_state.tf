data "terraform_remote_state" "config" {
  backend = "local"

  config = {
    path = "../00-config/terraform.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "../01-network/terraform.tfstate"
  }
}

data "terraform_remote_state" "edge" {
  backend = "local"

  config = {
    path = "../02-edge/terraform.tfstate"
  }
}

data "terraform_remote_state" "security" {
  backend = "local"

  config = {
    path = "../03-security/terraform.tfstate"
  }
}