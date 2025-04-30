provider "aws" {
  region = "eu-west-2"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "network" {
  source          = "./modules/network"
  vpc_cidr        = var.vpc_cidr
  subnet_count    = var.subnet_count
  availability_zones = var.availability_zones
}

module "ecs" {
  source              = "./modules/ecs"
  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
  ecs_sg_id           = module.network.ecs_sg_id
  cluster_name        = var.cluster_name
  ami_id              = var.ami_id
  instance_type       = var.instance_type
}

module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
  ecs_sg_id           = module.network.ecs_sg_id
  ecs_cluster_id      = module.ecs.ecs_cluster_id
  task_definition_arn = module.ecs.task_definition_arn
}