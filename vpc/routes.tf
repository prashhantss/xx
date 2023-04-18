// Create Route Table
resource "aws_route_table" "eks-rt" {
  vpc_id = aws_vpc.eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-igw.id
  }

  tags = {
    Name = "eks-rt"
  }
}

// Subnet Association with Route Table 
resource "aws_route_table_association" "eks-rt_association-1" {
  subnet_id      = aws_subnet.eks-subnet-1.id 
  route_table_id = aws_route_table.eks-rt.id
}

// Subnet-2 Association with Route Table
resource "aws_route_table_association" "eks-rt_association-2" {
  subnet_id      = aws_subnet.eks-subnet-2.id 
  route_table_id = aws_route_table.eks-rt.id
}
