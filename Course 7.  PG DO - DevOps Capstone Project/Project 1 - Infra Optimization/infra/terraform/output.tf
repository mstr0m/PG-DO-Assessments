output "Wordpress_app_url" {
  description = "Wordpress app url:"
  value       = "http://${aws_instance.k8s-master.public_ip}:31000"
}
output "etcd_bkup" {
  description = "ETCD backup is in your home folder:"
  value       = "~/etcd_backup.db"
}