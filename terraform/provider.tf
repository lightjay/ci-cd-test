terraform {
  backend "s3" {
    region = "us-west-2"
  }
}

provider "aws" {
  region = local.region
}