output "ecs_cluster_id" {
  value = module.ecs.ecs_cluster_id
}

output "load_balancer_dns_name" {
  value = module.alb.load_balancer_dns_name
}
