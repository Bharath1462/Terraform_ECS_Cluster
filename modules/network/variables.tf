variable "vpc_cidr" {
  type = string
}

variable "subnet_count" {
  type = number
}

variable "availability_zones" {
  type = list(string)
}