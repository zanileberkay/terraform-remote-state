# It specifies the start of the terraform configuration.

terraform {

  backend "remote" {
    organization = "znl-united"

    workspaces {
      name = "znl-united-practice"
    }
  }

  required_providers {
    aws ={
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
  
}