output "k8s_master_ip" {
  description = "Local ~/.kube/config is ready. k8s master ip:"
  value       = "${aws_instance.k8s-master.public_ip}"
}