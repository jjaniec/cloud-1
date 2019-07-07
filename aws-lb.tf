resource "aws_lb" "front" {
  name               = var.naming.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.pub[*].id

  enable_deletion_protection = false

  tags = var.naming.tags
}

resource "aws_lb_listener" "front" {
  load_balancer_arn = aws_lb.front.arn
  port = 80
  default_action {
    target_group_arn = aws_lb_target_group.front.arn
    type = "forward"
  }
}

# resource "aws_lb_cookie_stickiness_policy" "front" {
#   name                     = "stickiness-policy"
#   load_balancer            = aws_lb.main.id
#   lb_port                  = 80
#   cookie_expiration_period = 600
# }
