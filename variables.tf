variable "location" {
    default = "ap-south-1"
}

variable "os_name" {
    default = "ami-07d3a50bd29811cd1"
}

variable "key" {
    default = "sh"
}

variable "pem-path" {
    type = string
    default = "/sh.pem"
}

variable "instance-type" {
    default = "t2.micro"
}

variable "vpc-cidr" {
    default = "10.10.0.0/16"  
}

variable "subnet1-cidr" {
    default = "10.10.1.0/24"
}

variable "subnet2-cidr" {
    default = "10.10.2.0/24"
  
}
variable "subent_az-1" {
    default =  "ap-south-1a"  
}

variable "subent_az-2" {
    default =  "ap-south-1b"  
}

variable "aws_access_key_id" {
  description = "The AWS access key ID."
}

variable "aws_secret_access_key" {
  description = "The AWS access key ID."
}





