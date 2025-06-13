# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = [var.public_web_primary_subnet_id, var.public_web_replica_subnet_id]

  enable_deletion_protection = false

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-alb"
    }
  )
}

# ALB Target Group
resource "aws_lb_target_group" "main" {
  name     = "${var.environment}-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher            = "200"
    path               = "/health.html"
    port               = "traffic-port"
    protocol           = "HTTP"
    timeout            = 5
    unhealthy_threshold = 2
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-tg"
    }
  )
}

# ALB Listener
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# Latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# User data template
data "template_file" "user_data" {
  template = file("${path.module}/../../templates/user_data.sh")
}

# Public Launch Template
resource "aws_launch_template" "public" {
  name_prefix   = "${var.environment}-public-lt"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups            = [var.ec2_security_group_id]
  }

  iam_instance_profile {
    name = var.ec2_instance_profile_name
  }

  user_data = base64encode(data.template_file.user_data.rendered)

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "${var.environment}-public-ec2"
      }
    )
  }
}

# Private Launch Template
resource "aws_launch_template" "private" {
  name_prefix   = "${var.environment}-private-lt"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups            = [var.ec2_security_group_id]
  }

  iam_instance_profile {
    name = var.ec2_instance_profile_name
  }

  user_data = base64encode(data.template_file.user_data.rendered)

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "${var.environment}-private-ec2"
      }
    )
  }
}

# Public Auto Scaling Group
resource "aws_autoscaling_group" "public" {
  name                = "${var.environment}-public-asg"
  desired_capacity    = 2
  max_size           = 4
  min_size           = 2
  target_group_arns  = [aws_lb_target_group.main.arn]
  vpc_zone_identifier = [var.public_web_primary_subnet_id, var.public_web_replica_subnet_id]
  health_check_type  = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.public.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = merge(
      var.tags,
      {
        Name = "${var.environment}-public-ec2"
      }
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# Private Auto Scaling Group
resource "aws_autoscaling_group" "private" {
  name                = "${var.environment}-private-asg"
  desired_capacity    = 2
  max_size           = 4
  min_size           = 2
  target_group_arns  = [aws_lb_target_group.main.arn]
  vpc_zone_identifier = [var.private_app_primary_subnet_id, var.private_app_replica_subnet_id]
  health_check_type  = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.private.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = merge(
      var.tags,
      {
        Name = "${var.environment}-private-ec2"
      }
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
} 