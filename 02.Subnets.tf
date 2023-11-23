variable "public_subnet_cidrs" {
  default = ["10.32.1.0/24", "10.32.2.0/24", "10.32.3.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.32.11.0/24", "10.32.12.0/24", "10.32.13.0/24"]
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.app1.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = "eu-west-1${["a", "b", "c"][count.index]}"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.app1.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = "eu-west-1${["a", "b", "c"][count.index]}"
  
  tags = {
    Name = "private-subnet-${count.index + 11}"
  }
}

resource "aws_internet_gateway" "app1_igw" {
  vpc_id = aws_vpc.app1.id

  tags = {
    Name = "app1-igw"
  }
}

resource "aws_route_table" "app1_rt" {
  vpc_id = aws_vpc.app1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app1_igw.id
  }

  tags = {
    Name = "app1-rt"
  }
}

resource "aws_route_table_association" "app1_rta_public" {
  count          = length(aws_subnet.public_subnet.*.id)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.app1_rt.id
}
