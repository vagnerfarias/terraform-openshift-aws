data "terraform_remote_state" "config" {
  backend = "local"

  config = {
    path = "../00-config/terraform.tfstate"
  }
}