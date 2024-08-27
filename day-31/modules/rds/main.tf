resource "aws_db_instance" "mysql" {
  identifier        = "mydb"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password
  
  publicly_accessible = false
  
  vpc_security_group_ids = [var.aws_security_group]
  
  db_subnet_group_name  = aws_db_subnet_group.main.name

  skip_final_snapshot = true

  tags = {
    Name = "mydb"
  }
}

resource "aws_db_subnet_group" "main" {
  name        = "main"
  subnet_ids   = [var.subnet_public_a, var.subnet_public_b]  
  tags = {
    Name = "db_subnet_group"
  }
}
