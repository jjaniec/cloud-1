resource "aws_lb_target_group" "front" {
  name     = "${var.naming.name}-front"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    port    = "traffic-port"
    matcher = "200,302"
  }

  stickiness {
    type = "lb_cookie"
  }
}
