# The public (internet-facing) ALB ❤️
resource "aws_lb" "public_alb" {
  name               = "public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.proxy_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "public-alb"
  }
}

# Creating a target group for the listeners to add them to the ALB
resource "aws_lb_target_group" "frontend_tg" {
  name     = "proxy-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/" 
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Creating the listeners for the public ALB ❤️
resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

# Creating the tg attachment 
resource "aws_lb_target_group_attachment" "frontend_attachment" {
  count            = length(var.proxy_instance_ids)
  target_group_arn = aws_lb_target_group.frontend_tg.arn
  target_id        = var.proxy_instance_ids[count.index]
  port             = 3000
}

# The private (internal) ALB ❤️
resource "aws_lb" "internal_alb" {
  name               = "internalalb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.backend_sg_id]
  subnets            = var.private_subnet_ids

  tags = {
    Name = "internal-alb"
  }
}

# Creating a target group for the listeners to add them to the ALB
resource "aws_lb_target_group" "backend_api_tg" {
  name     = "backend-api-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/api/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Creating the listeners for the private ALB ❤️
resource "aws_lb_listener" "backend_api_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 5000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_api_tg.arn
  }
}

# Creating a target group for the listeners to add them to the ALB
resource "aws_lb_target_group_attachment" "backend_api_attachment" {
  count            = length(var.backend_instance_ids)
  target_group_arn = aws_lb_target_group.backend_api_tg.arn
  target_id        = var.backend_instance_ids[count.index]
  port             = 5000
}
