data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = [ "al2023-ami-2023.*-kernel-6.18-x86_64" ]
  }
}

data "aws_key_pair" "get_key" {
  key_name = "test"
}

resource "aws_instance" "project_ec2" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id = var.public_subnet
  key_name = data.aws_key_pair.get_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [ var.security_group ]
  tags = {
    Name = "${var.project_name}-ec2"
  }
}

