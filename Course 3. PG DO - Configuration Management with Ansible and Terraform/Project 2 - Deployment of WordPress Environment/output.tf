output "wordpress_url" {
  description = "WordPress app URL"
  value       = "http://${aws_instance.wordpress.public_ip}"
}