terraform {
  backend "s3" {
    bucket = "supandoprojects-terraformstate-710271940286"
    key    = "s3/static/infra.tfstate"
    region = "eu-west-2"
  }
}
