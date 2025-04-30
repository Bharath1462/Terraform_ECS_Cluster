variable "vpc_id" {}
variable "public_subnet_ids" {
  type = list(string)
}
variable "ecs_sg_id" {}
variable "ami_id" {}
variable "instance_type" {}
variable "cluster_name" {}