variable "vpc_id" {}
variable "public_subnet_ids" {
  type = list(string)
}
variable "ecs_sg_id" {}
variable "ecs_cluster_id" {}
variable "task_definition_arn" {}
