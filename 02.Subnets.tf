resource "aws_subnet" "my_subnet" {
  count             = 3
  vpc_id            = aws_vpc.app1.id 
  cidr_block        = cidrsubnet(aws_vpc.app1.cidr_block, 8, count.index)
  availability_zone = "eu-west-1${["a", "b", "c"][count.index]}"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "my-subnet-${count.index}"
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

resource "aws_route_table_association" "app1_rta" {
  count          = length(aws_subnet.my_subnet.*.id)
  subnet_id      = aws_subnet.my_subnet[count.index].id
  route_table_id = aws_route_table.app1_rt.id
}
