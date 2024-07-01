resource "aws_instance" "SaniyaStrapiEC2" {
  ami                         = var.ami
  instance_type               = "t2.medium"
  vpc_security_group_ids      = [aws_security_group.strapiEC2-sg.id]

  subnet_id                   = aws_subnet.subnet1.id

  key_name                    = "k8-key-pair"
  associate_public_ip_address = true
  user_data = file("user_data_strapi.sh")         
  
  tags = {
    Name = "StrapiEC2"
  }
}

resource "aws_security_group" "strapiEC2-sg" {
  vpc_id      = aws_vpc.strapi_vpc.id
  description = "Security Group for Strapi Application"
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "1337"
    to_port     = "1337"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "Strapi-sg"
  }

}

resource "aws_route53_record" "subdomain" {
  zone_id = 
  name    = "saniya.contentecho.in"
  type    = "A"
  ttl     = 300
  records = [aws_instance.SaniyaStrapiEC2.public_ip]
}

