# ALB with Blue/Green listeners and switchable default actions via variable

variable "active_target_group" {
  description = "Active target group (blue|green) used by port 80 listener"
  type        = string
  default     = "blue"
}

resource "aws_lb" "main" {
  name               = "spring-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

# Target groups with /health checks
resource "aws_lb_target_group" "blue" {
  name        = "spring-app-tg-blue"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled   = true
    path      = "/health"
    protocol  = "HTTP"
    matcher   = "200"
    interval  = 15
    timeout   = 5
  }

  tags = { Environment = "blue" }
}

resource "aws_lb_target_group" "green" {
  name        = "spring-app-tg-green"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled   = true
    path      = "/health"
    protocol  = "HTTP"
    matcher   = "200"
    interval  = 15
    timeout   = 5
  }

  tags = { Environment = "green" }
}

# Listener on port 80 forwards to active TG
resource "aws_lb_listener" "prod" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.active_target_group == "blue" ? aws_lb_target_group.blue.arn : aws_lb_target_group.green.arn
  }
}

# Listener on port 8080 forwards to inactive TG for validation
resource "aws_lb_listener" "validation" {
  load_balancer_arn = aws_lb.main.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.active_target_group == "blue" ? aws_lb_target_group.green.arn : aws_lb_target_group.blue.arn
  }
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "alb_arn" {
  value = aws_lb.main.arn
}

output "blue_target_group_arn" {
  value = aws_lb_target_group.blue.arn
}

output "green_target_group_arn" {
  value = aws_lb_target_group.green.arn
}
