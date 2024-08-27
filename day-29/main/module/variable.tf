variable "bucket" {
    type = string
    default = "myy-terraform-bucket"
}

variable "instance_name" {
    type = string
    default = "Amaan-new-inst"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "region" {
    type = string
    default = "us-east-2"
}

variable "ami_id" {
    description = "AMI ID for the EC2 instance"
    default     = "ami-003932de22c285676"
}

variable "bucket_name" {
    type = string
    default = "mynewnewwbuckkettt"
}