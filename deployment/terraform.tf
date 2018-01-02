# This backend bucket needs to be created manually
# ex: `aws s3api create-bucket --bucket pypi-popular-terraform`
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "pypi-popular-terraform"
    key    = "core.tfstate"
    region = "us-east-1"
  }
}

module "bootstrap" {
  source = "./terraform_bootstrap"
}

module "k8s_cluster" {
  source = "./terraform_k8s_cluster"
}
