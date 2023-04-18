// Create Subnet-1
resource "aws_subnet" "eks-subnet-1" {
  vpc_id     = aws_vpc.eks-vpc.id 
  cidr_block = var.subnet1-cidr
  availability_zone = var.subent_az-1
  map_public_ip_on_launch = "true"
  tags = {
    Name = "eks-subnet-1"
  }
}

// Create Subnet-2
resource "aws_subnet" "eks-subnet-2" {
  vpc_id     = aws_vpc.eks-vpc.id 
  cidr_block = var.subnet2-cidr
  availability_zone = var.subent_az-2
  map_public_ip_on_launch = "true"
  tags = {
    Name = "eks-subnet-2"
  }
}
