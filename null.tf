resource "null_resource" "nullremote" {

connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.pem-path)
    host        = aws_instance.eks-client.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.25.7/2023-03-17/bin/linux/amd64/kubectl",
      "curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.25.7/2023-03-17/bin/linux/amd64/kubectl.sha256",
      "chmod +x ./kubectl",
      "mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin",
      "echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc",
    ]
  }
}

resource "null_resource" "nullremote1" {

connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.pem-path)
    host        = aws_instance.eks-client.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
      "aws --version",
      "kubectl version --short --client",
    ]
  }
}


resource "null_resource" "nullremote2" {

connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.pem-path)
    host        = aws_instance.eks-client.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "aws configure set aws_access_key_id ${var.aws_access_key_id}",
      "aws configure set aws_secret_access_key ${var.aws_secret_access_key}",
      "aws configure set region ${var.location}",
    ]
  }
}







resource "null_resource" "nullremote3" {

connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.pem-path)
    host        = aws_instance.eks-client.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "aws eks update-kubeconfig --name eks-01 --region ap-south-1",
	"kubectl get nodes",
    ]
  }
}
