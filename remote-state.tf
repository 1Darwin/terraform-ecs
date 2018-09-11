terraform {
  backend "s3" {
    bucket  = "<BUCKET>"
    encrypt = "true"
    key     = "<PATH>"
    region  = "<REGION>"
  }
}
