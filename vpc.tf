resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_public_subnets[0]
  availability_zone = var.availability_zones[0]
  tags = {
    Name = join("-", ["pub", "sub", var.availability_zones[0]])
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_public_subnets[1]
  availability_zone = var.availability_zones[1]
  tags = {
    Name = join("-", ["pub", "sub", var.availability_zones[1]])
  }
}
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_private_subnets[0]
  availability_zone = var.availability_zones[0]
  tags = {
    Name = join("-", ["priv", "sub", var.availability_zones[0]])
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_private_subnets[1]
  availability_zone = var.availability_zones[1]
  tags = {
    Name = join("-", ["priv", "sub", var.availability_zones[1]])
  }
}

resource "aws_subnet" "db_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_db_subnets[0]
  availability_zone = var.availability_zones[0]
  tags = {
    Name = join("-", ["db", "sub", var.availability_zones[0]])
  }
}

resource "aws_subnet" "db_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_db_subnets[1]
  availability_zone = var.availability_zones[1]
  tags = {
    Name = join("-", ["db", "sub", var.availability_zones[1]])
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "public_a_subnet" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a_subnet" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "nat" {
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_nat_gateway" "ngw" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.nat.id
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "private_ngw" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}