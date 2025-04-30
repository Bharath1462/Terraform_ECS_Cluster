output "ecs_cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.task.arn
}
