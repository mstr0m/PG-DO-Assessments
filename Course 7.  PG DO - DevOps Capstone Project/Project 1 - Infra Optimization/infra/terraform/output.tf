output "app_url" {
  description = "Wordpress app url:"
  value       = "http://${aws_instance.k8s-master.public_ip}:31000"
}