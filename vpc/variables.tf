variable "vpc-cidr" {
  description = "The CIDR block for the VPC"
  type = string
   default = "10.10.0.0/16" 
}

variable "subnet1-cidr" {
  description = "The CIDR block for Subnet 1"
  type = string
   default = "10.10.1.0/24"
}

variable "subnet2-cidr" {
  description = "The CIDR block for Subnet 2"
  type = string
  default = "10.10.2.0/24"
}

variable "subent_az-1" {
  description = "The Availability Zone for Subnet 1"
  type = string
  default =  "ap-south-1a" 
}

variable "subent_az-2" {
  description = "The Availability Zone for Subnet 2"
  type = string
   default =  "ap-south-1b"
}
