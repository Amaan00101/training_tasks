output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_public_a" {
  value = aws_subnet.public_a.id
}

output "aws_security_group" {
  value = aws_security_group.sg.id
}

output "subnet_public_b" {
  value = aws_subnet.public_b.id
}
