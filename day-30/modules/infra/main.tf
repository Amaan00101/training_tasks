provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "my-neww-instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/einfochips/Downloads/SPkey.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apache2",
      "sudo systemctl start apache2.service",
      "sudo systemctl enable apache2.service"
    ]
  }


  provisioner "local-exec" {
    command = "echo EC2 instance has been Deployed."
  }

}

resource "aws_s3_bucket" "my_buckett" {
  bucket = var.bucket_name

  tags = {
    Name = join("-", [var.bucket_name, "buckett"])
  }
}
