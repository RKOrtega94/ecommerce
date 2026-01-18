# AMI sourcing: latest Amazon Linux 2 with LocalStack-friendly fallback

# Primary: filter latest Amazon Linux 2 AMI from AWS (works when provider emulates EC2 API)
data "aws_ami" "al2_latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

# Fallback: allow override via variable when LocalStack doesn't support AMI query fully
variable "al2_ami_id_override" {
  description = "Override AMI ID for Amazon Linux 2 when running against LocalStack"
  type        = string
  default     = "" # leave empty to use data source
}

locals {
  ec2_ami_id = var.al2_ami_id_override != "" ? var.al2_ami_id_override : data.aws_ami.al2_latest.id
}

# Launch Template for ECS EC2 capacity
resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "spring-ecs-lt-"
  image_id      = local.ec2_ami_id
  instance_type = "t3.micro"

  monitoring {
    enabled = true # detailed monitoring
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  network_interfaces {
    security_groups = [aws_security_group.ecs_instances.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              set -euxo pipefail
              echo "ECS cluster bootstrap"
              echo "ECS_CLUSTER=${aws_ecs_cluster.main.name}" >> /etc/ecs/ecs.config
              systemctl enable --now ecs || true

              # Install CloudWatch agent (optional in LocalStack, kept for parity)
              yum update -y
              yum install -y awslogs
              systemctl enable --now awslogsd || true
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "spring-ecs-instance"
    }
  }
}

# Auto Scaling Group: single instance desired=min=max=1
resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "spring-ecs-asg"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  health_check_type         = "EC2"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "spring-ecs-asg"
    propagate_at_launch = true
  }
}

# Security group for ECS instances: inbound only from ALB SG on 8080
resource "aws_security_group" "ecs_instances" {
  name        = "ecs-instances-sg"
  description = "ECS instances SG; allow inbound only from ALB on 8080"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-instances-sg"
  }
}

# IAM role/profile for ECS instances
resource "aws_iam_role" "ecs_instance_role" {
  name = "ecsInstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action   = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attach" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.ecs_instance_role.name
}

