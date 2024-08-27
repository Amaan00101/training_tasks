resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-bucketttt-ismine"

  tags = {
    Name = "Amaan Bucket"
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

output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}