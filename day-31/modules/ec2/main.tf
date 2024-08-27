resource "aws_instance" "app_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = "myy-us-east-1"
  subnet_id                   = var.subnet_public_a
  vpc_security_group_ids      = [var.aws_security_group]
  associate_public_ip_address = true

  tags = {
    Name = "myyy-AppServer"
  }
  
  lifecycle {
    prevent_destroy = true
  }
}