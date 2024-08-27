terraform {
  backend "s3" {
    bucket         = "terraform-bucketttt-ismine" 
    key            = "terraform/state.tfstate"
    region         = "us-east-2" 
    encrypt        = true
    dynamodb_table = "Amaan-locks" 
  }
}