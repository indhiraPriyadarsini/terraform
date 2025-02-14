output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_instance.ec2_instance[*].id
}
