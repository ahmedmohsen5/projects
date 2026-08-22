resource "aws_vpc" "main" {
  region = var.region
  cidr_block = var.cidr

  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnet
  availability_zone = each.value.az
  cidr_block = each.value.ip
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-${each.key}"
  }
  
}

resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnet
  cidr_block = each.value.ip
  vpc_id = aws_vpc.main.id
  availability_zone = each.value.az
  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-ig"
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-eip"
  }
}

resource "aws_nat_gateway" "ng" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public_subnet["az1"].id
  depends_on = [ aws_internet_gateway.ig ]
  tags = {
    Name = "${var.project_name}-ng"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-public_rt"
  }

}

resource "aws_route" "public_internet_access" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig.id
}

resource "aws_route_table_association" "public_rta" {
  for_each = var.public_subnet
  subnet_id = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-private_rt"
  }
}

resource "aws_route" "private_network_access" {
  route_table_id = aws_route_table.private_rt.id
  nat_gateway_id = aws_nat_gateway.ng.id
  destination_cidr_block = "0.0.0.0/0"
}
resource "aws_route_table_association" "private_rta" {
  for_each = var.private_subnet
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_subnet[each.key].id
}

resource "aws_security_group" "ec2_sg" {
  name= "ec2_sg"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_web" {
  cidr_ipv4 = "0.0.0.0/0"
  security_group_id = aws_security_group.ec2_sg.id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  cidr_ipv4 = "0.0.0.0/0"
  security_group_id = aws_security_group.ec2_sg.id
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.ec2_sg.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}


