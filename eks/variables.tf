variable "sg_ids" {
type = string
}

variable "subnet_ids" {
  type = list
}

variable "vpc_id" {
   type = string
}

variable "key" {
    default = "sh"
}

variable "worker-instance-type" {
  default = "t2.micro"
}
