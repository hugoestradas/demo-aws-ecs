output "alb_url" {
  value = "http://${aws_alb.nginx_service.dns_name}/employees"
}

output "postgress-address" {
  value = "address: ${aws_db_instance.db.address}"
}

output "rds_pg_port" {
  description = "RDS instance port"
  value       = aws_db_instance.db.port
  sensitive   = true
}

output "rds_pg_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.db.username
  sensitive   = true
}