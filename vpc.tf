resource "aws_vpc" "myvpc" {
  cidr_block = "10.11.0.0/16"
  tags = { Name = "Vaibhav"
  }
  
}
resource "aws_subnet" "Public" {
   vpc_id     = aws_vpc.myvpc.id
   cidr_block = "10.11.1.0/24"

  tags = {
    Name = "Public"
  }
}
resource "aws_subnet" "Private" {
   vpc_id     = aws_vpc.myvpc.id
   cidr_block = "10.11.2.0/24"

  tags = {
    Name = "Private"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "IGW"
  }
}
resource "aws_route_table" "r1" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "MRT"
  }
}
resource "aws_eip" "EIP" {
    domain = "vpc"
  
}
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.Public.id
}
resource "aws_route_table" "r2" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name = "CRT"
  }
}
  resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.Public.id
  route_table_id = aws_route_table.r1.id
}
resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.Private.id
  route_table_id = aws_route_table.r2.id
}
resource "aws_instance""public"{
  ami  = "ami-05b10e08d247fb927"
  instance_type = "t2.micro"
  key_name =   aws_key_pair.key.key_name
  subnet_id = aws_subnet.Public.id
    associate_public_ip_address = true
    user_data = <<-EOF
         #!/bin/bash
           sudo yum install nginx -y
             sudo systemctl start nginx 
              sudo systemctl enable nginx
                 EOF
  tags = {
    Name = "Public"
  }
}
resource "aws_key_pair" "key" {
  key_name   = "nvp.pem"            
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCqcD8QrYZnNcNa+/HyonLq3zR06WGhN1tapZb2WsOpl2fZsvdGqJ4wpFkh5P4Y8bINm7+BvFZxQ9n50oOIu/H7Lmo+UxD32OLNCnYe4Hz1SHU61jnddfw0YoMjtPRklBN6DEv487DT/sIF6I6Cj/ZbRSopcWtdqe7YNGVPyKcUYw== noname"

  } 

resource "aws_instance""private"{
  ami  = "ami-05b10e08d247fb927"
  instance_type = "t2.micro"
  key_name =   aws_key_pair.key.key_name
  subnet_id = aws_subnet.Private.id
    associate_public_ip_address = true
    user_data = <<-EOF
         #!/bin/bash
           sudo yum install nginx -y
             sudo systemctl start nginx 
              sudo systemctl enable nginx
                 EOF
  tags = {
    Name = "Private"
  }
}

  output "publicip" {
    value = aws_instance.public.public_ip
  }
   output "Privateip" {
    value = aws_instance.private.private_ip
  }

resource "aws_vpc" "name" {
    cidr_block = "10.11.0.0/16"
  
}