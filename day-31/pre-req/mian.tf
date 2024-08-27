provider "aws" {
  region  = var.aws_region
  profile = "default"
}

resource "aws_s3_bucket" "static_assets" {
  bucket = var.bucket_name
  tags = {
    Name = "static_assets"
  }
}


resource "aws_dynamodb_table" "terraform_locks" {
  name         = "Amaan-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "State Lock Table"
  }
}