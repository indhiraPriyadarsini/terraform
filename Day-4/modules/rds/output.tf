output "rds_endpoint" {
    description = "Endpoint to access rds"
    value = aws_db_instance.mysql_db.endpoint
}