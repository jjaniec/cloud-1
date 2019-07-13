output "db_endpoint" {
  value = aws_db_instance.back.endpoint
}

output "alb_dns_name" {
  value = aws_lb.front.dns_name
}
