terraform {
  backend "s3" {
    bucket         = "my-almostt-newww-buckettt" 
    key            = "terraform/state.tfstate"
    region         = "us-east-1" 
    encrypt        = true
    dynamodb_table = "Amaan-locks" 
  }
}