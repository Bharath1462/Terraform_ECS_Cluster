resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs_instance_profile"
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_launch_template" "ecs_launch_template" {
  name_prefix   = "ecs-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_instance_profile.arn
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.ecs_sg_id]
    subnet_id                   = var.public_subnet_ids[0]
  }
  user_data = base64encode("#!/bin/bash\necho ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config")
}

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

resource "aws_autoscaling_group" "ecs_asg" {
  vpc_zone_identifier = var.public_subnet_ids
  desired_capacity    = 2
  min_size            = 1
  max_size            = 3
  target_group_arns   = [] # to be populated by ALB module
  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "web-app"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([{
    name      = "web-app"
    image     = "nginx:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}