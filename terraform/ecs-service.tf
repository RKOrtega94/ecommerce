# ECS cluster and EC2 service attaching to active target group

# Cluster
resource "aws_ecs_cluster" "main" {
  name = "spring-app-cluster"
}

# Task definition (EC2/bridge)
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/spring-app"
  retention_in_days = 7
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_ecr_repository" "spring_app" {
  name                 = "spring-app"
  image_tag_mutability = "MUTABLE"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.spring_app.repository_url
}

resource "aws_ecs_task_definition" "app" {
  family           = "spring-app"
  network_mode     = "bridge"
  cpu              = 256
  memory           = 512
  requires_compatibilities = ["EC2"]
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn       = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = "spring-app",
      image     = "${aws_ecr_repository.spring_app.repository_url}:latest",
      essential = true,
      portMappings = [{ containerPort = 8080, hostPort = 8080 }],
      environment = [
        { name = "APP_VERSION", value = var.app_version },
        { name = "ENVIRONMENT", value = var.environment }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name,
          awslogs-region        = "us-east-1",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# Service attached to active target group
resource "aws_ecs_service" "app" {
  name            = "spring-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = var.active_target_group == "blue" ? aws_lb_target_group.blue.arn : aws_lb_target_group.green.arn
    container_name   = "spring-app"
    container_port   = 8080
  }

  placement_constraints {
    type = "distinctInstance"
  }

  depends_on = [aws_lb_listener.prod, aws_lb_listener.validation]

  lifecycle {
    ignore_changes = [load_balancer]
  }
}

