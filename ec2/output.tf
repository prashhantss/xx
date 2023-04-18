output "instance_id" {
    value = aws_instance.eks-client.id
}

output "public_ip" {
    value = aws_instance.eks-client.public_ip
}
