resource "aws_autoscaling_group" "front" {
  name                      = "${var.naming.name}-front"
  force_delete              = true
  default_cooldown          = 60
  health_check_grace_period = 180
  health_check_type         = "ELB"

  desired_capacity = 2
  max_size         = 5
  min_size         = 2

  launch_template {
    id      = aws_launch_template.front.id
    version = "$Latest"
  }

  # availability_zones = var.subnets_az
  vpc_zone_identifier  = aws_subnet.pub[*].id
  termination_policies = ["NewestInstance", "OldestLaunchTemplate"]

  dynamic "tag" {
    iterator = elem
    for_each = var.naming.tags
    content {
      key                 = elem.key
      value               = var.naming.tags[elem.key] != null ? var.naming.tags[elem.key] : ""
      propagate_at_launch = true
    }
  }

  lifecycle {
    ignore_changes = ["desired_capacity", "max_size", "min_size"]
  }
}

resource "aws_autoscaling_attachment" "front" {
  autoscaling_group_name = aws_autoscaling_group.front.id
  alb_target_group_arn   = aws_lb_target_group.front.arn
}

resource "aws_autoscaling_policy" "cpu_usage_scale_out" {
  name                      = "CPUUsageScaleOut"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.front.name
  estimated_instance_warmup = 120
  # scaling_adjustment        = 1

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 65.0
  }
}
