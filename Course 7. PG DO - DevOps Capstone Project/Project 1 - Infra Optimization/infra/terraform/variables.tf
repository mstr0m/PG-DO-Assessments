# AWS
variable "AWS_ACCESS_KEY" {
  description = "AWS API Access Key"
  type        = string
  sensitive   = true
}
variable "AWS_SECRET_KEY" {
  description = "AWS API Secret Key"
  type        = string
  sensitive   = true
}
variable "AWS_TOKEN" {
  description = "AWS API Token"
  type        = string
  sensitive   = true
}
variable "AWS_REGION" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}
# PKI
variable "PATH_TO_PRIVATE_KEY" {
  description = "Exact path to Private Key file location"
  default     = "~/.ssh/aws-rsa"
  type        = string
}
variable "PATH_TO_PUBLIC_KEY" {
  description = "Exact path to Public Key file location"
  default     = "~/.ssh/aws-rsa.pub"
  type        = string
}
# SSH
variable "SSH_USER" {
  description = "SSH User on remote VM"
  default     = "ubuntu"
  type        = string
}
# INSTANCE
variable "AMIS" {
  description = "AMI id of AWS resource"
  type        = map(string)
  default = {
    ubuntu = "ami-04505e74c0741db8d"
  }
}
variable "INSTANCE_TYPE" {
  description = "AWS EC2 instance type (size)"
  default     = "t2.medium"
  type        = string
}
# K8S
variable "K8S_WORKER_COUNT" {
  description = "Number of k8s workers"
  type        = number
  default     = 1
}