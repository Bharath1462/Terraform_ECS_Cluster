variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_count" {
  default = 2
}

variable "availability_zones" {
  default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "ami_id" {
  default = "ami-00332bada740df2bf"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "cluster_name" {
  default = "my_cluster"
}
