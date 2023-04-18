module "vpc" {
  source = "./modules/vpc"
  
  os_name       = var.os_name
  key           = var.key
  instance_type = var.instance_type
  vpc_cidr      = var.vpc_cidr
  subnet1_cidr  = var.subnet1_cidr
  subnet2_cidr  = var.subnet2_cidr
  subnet1_az    = var.subnet1_az
  subnet2_az    = var.subnet2_az
}


module "ec2_instance" {
  source = "./modules/ec2"
  ami-id        = "ami-07d3a50bd29811cd1"
  private-key   = "sh"
  instance_type  = "t2.micro"
}

module "eks" {
  source = "./modules/eks"

  security_group_ids = var.sg_ids
  subnet_ids = var.subnet_ids
  vpc_id = var.vpc_id
  key_name = var.key
  worker_instance_type = var.worker-instance-type
}

module "eks_sg" {
  source = "./modules/eks-sg"
  vpc_id = aws_vpc.main.id
}


// null module
module "null" {
  source  = "./modules/null"
}
