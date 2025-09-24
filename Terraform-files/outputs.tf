output "instance_id" {
  value       = aws_instance.web.id
  description = "EC2 instance ID"
}

output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP address"
}

output "public_dns" {
  value       = aws_instance.web.public_dns
  description = "Public DNS name"
}

output "http_url" {
  value       = "http://${aws_instance.web.public_ip}/"
  description = "Convenience URL for the demo site (HTTP only)"
}
