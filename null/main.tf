resource "null_resource" "nullremote" {

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.pem_path)
    host        = aws_instance.eks-client.public_ip
  }

  provisioner "remote-exec" {
    inline = [file("provision.sh")]
  }
}
