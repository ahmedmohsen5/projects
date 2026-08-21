output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet" {
  value = aws_subnet.public_subnet["az1"].id
}

output "sg-ec2" {
  value = aws_security_group.ec2_sg.id
}


