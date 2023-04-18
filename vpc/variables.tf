variable "os_name" {
  description = "The name of the AMI to use for the EC2 instance"
  type = string
}

variable "key" {
  description = "The name of the EC2 Key Pair to associate with the instance"
  type = string
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instance"
  type = string
}

variable "vpc-cidr" {
  description = "The CIDR block for the VPC"
  type = string
}

variable "subnet1-cidr" {
  description = "The CIDR block for Subnet 1"
  type = string
}

variable "subnet2-cidr" {
  description = "The CIDR block for Subnet 2"
  type = string
}

variable "subent_az-1" {
  description = "The Availability Zone for Subnet 1"
  type = string
}

variable "subent_az-2" {
  description = "The Availability Zone for Subnet 2"
  type = string
}
