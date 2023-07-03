# It specifies the start of the terraform configuration.

terraform { 

#Specifies the requirements of the provider used by terraform
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" { # Specifies the aws providers config
    region = "us-east-1"
}


#Defines the s3 bucket resource. In this section, you specify the bucket name
#and any config such as the force_destroy.

resource "aws_s3_bucket" "terraform_state" { 
  bucket = "dev-backend-tf-bucket"
  force_destroy = true  
}


# Defines the versioning config for the s3 bucket.

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}


#Defines the server-side encryption configuration for the s3 bucket.
#in this secton it is configured to use the AES256

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3.bucket.terraform_state.bucket
  rule{
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# Defines the DynamoDB table resource. In this section, you specify the table name.

resource "aws_dynamodb_table" "terrafrom_lock" {
    name = "terraform-state-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
      name = "LockID"
      type="A"
    }
  
}