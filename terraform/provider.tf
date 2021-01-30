terraform {
  backend "remote" {

  }
}

provider "aws" {
  region = local.region
}