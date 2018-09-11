provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    region = "<REGION>"
    bucket = "<BUCKET>"
    key = "<PATH>"
  }
}
