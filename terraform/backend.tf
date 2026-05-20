
terraform {

  backend "s3" {

    bucket = "koushik-terraform-state"

    key = "terraform.tfstate"

    region = "ap-south-1"

    dynamodb_table = "terraform-lock"

    encrypt = true
  }
}