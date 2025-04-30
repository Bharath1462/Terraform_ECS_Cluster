resource "aws_lb" "ecs_lb" {
  name               = "ecs-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.ecs_sg_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "ecs-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

resource "aws_ecs_service" "service" {
  name            = "ecs-service"
  cluster         = var.ecs_cluster_id
  task_definition = var.task_definition_arn
  desired_count   = 2
  launch_type     = "EC2"
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "web-app"
    container_port   = 80
  }
}
