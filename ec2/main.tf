resource "aws_instance" "eks-client" {
    ami = var.ami-id
    key_name = var.private-key
    instance_type  = var.instance_type
    associate_public_ip_address = true
    subnet_id = aws_subnet.eks-subnet-1.id
    vpc_security_group_ids = [aws_security_group.ec2-vpc-sg.id]
}
