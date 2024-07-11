resource "aws_vpc" "strapi_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "saniya-vpc-strapi"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.strapi_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.strapi_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1b"
}

resource "aws_internet_gateway" "strapi_igw" {
  vpc_id = aws_vpc.strapi_vpc.id
}



resource "aws_route_table" "subnet1_rt" {
  vpc_id = aws_vpc.strapi_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.strapi_igw.id
  }
}

resource "aws_route_table" "subnet2_rt" {
  vpc_id = aws_vpc.strapi_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.strapi_igw.id
  }
}


resource "aws_route_table_association" "subnet1_rt" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.subnet1_rt.id
}

resource "aws_route_table_association" "subnet2_rt" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.subnet2_rt.id
}