resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "MyVPC"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.main.id
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}


# create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
  cidr_block              = var.public_subnet_cidrs_az1
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_az1"
  }
}
# create public subnet az2
resource "aws_subnet" "public_subnet_az2" {
  cidr_block              = var.public_subnet_cidrs_az2
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_az2"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id  = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags       = {
    Name     = "public_route_table"
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_az1.id
  route_table_id      = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_az2.id
  route_table_id      = aws_route_table.public_route_table.id
}


# create private subnet az1
resource "aws_subnet" "private_subnet_az1" {
  cidr_block              = var.private_subnet_cidrs_az1
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "private_subnet_az1"
  }
}
# create public subnet az2
resource "aws_subnet" "private_subnet_az2" {
  cidr_block              = var.private_subnet_cidrs_az2
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "private_subnet_az2"
  }
}


# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet az1 
resource "aws_eip" "eip_for_nat_gateway_az1" {
  vpc    = true

  tags   = {
    Name = "nat gateway az1 eip"
  }
}

# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet az2
resource "aws_eip" "eip_for_nat_gateway_az2" {
  vpc    = true

  tags   = {
    Name = "nate gateway az2 eip"
  }
}

# create nat gateway in public subnet az1
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  subnet_id     = aws_subnet.private_subnet_az1.id

  tags   = {
    Name = "nat gateway for az1"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [aws_internet_gateway.my_igw]
}


# create nat gateway in public subnet az2
resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id
  subnet_id     =  aws_subnet.private_subnet_az2.id
  tags   = {
    Name = "nate gateway az2"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  # on the internet gateway for the vpc.
  depends_on = [aws_internet_gateway.my_igw]
}


# create private route table az1 and add route through nat gateway az1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id            = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az1.id
  }

  tags   = {
    Name = "private route table az1"
  }
}

# associate private app subnet az1 with private route table az1
resource "aws_route_table_association" "private_subnet_az1_route_table_az1_association" {
  subnet_id         = aws_subnet.private_subnet_az1.id
  route_table_id    = aws_route_table.private_route_table_az1.id
}



# create private route table az2 and add route through nat gateway az2
resource "aws_route_table" "private_route_table_az2" {
  vpc_id            = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az2.id
  }

  tags   = {
    Name = "private route table az2"
  }
}

# associate private app subnet az2 with private route table az2
resource "aws_route_table_association" "private_subnet_az2_route_table_az2_association" {
  subnet_id         = aws_subnet.private_subnet_az2.id
  route_table_id    = aws_route_table.private_route_table_az2.id
}

