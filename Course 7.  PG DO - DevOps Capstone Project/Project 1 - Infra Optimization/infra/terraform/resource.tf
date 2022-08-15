# ADD PUBLIC KEY TO AWS. IT WILL BE USED DURING VM CREATION
resource "aws_key_pair" "aws_key" {
  key_name   = "aws_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# SETUP SECURITY GROUP - AWS FIREWALL
resource "aws_security_group" "sg_k8s" {
  name = "sg_k8s"
  # Any incoming traffic is allowed
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Any outgoing traffic is allowed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 INSTANCE FOR MASTER
resource "aws_instance" "k8s-master" {
  ami           = var.AMIS["ubuntu"]
  instance_type = var.INSTANCE_TYPE
  # Add previously generated public key to VM
  key_name = aws_key_pair.aws_key.key_name
  # Add VM to security group
  vpc_security_group_ids = [aws_security_group.sg_k8s.id]
  tags = {
     Name = "k8s"
     Role = "master"
  }

  # Wait for SSH connection to become available, which means VM is up and running
  provisioner "remote-exec" {
    inline = ["echo 'SSH is up!'"]
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.SSH_USER
      private_key = file(var.PATH_TO_PRIVATE_KEY)
    }
  }
}

# EC2 INSTANCES FOR WORKER
resource "aws_instance" "k8s-worker" {
  count         = var.K8S_WORKER_COUNT
  ami           = var.AMIS["ubuntu"]
  instance_type = var.INSTANCE_TYPE
  # Add previously generated public key to VM
  key_name = aws_key_pair.aws_key.key_name
  # Add VM to security group
  vpc_security_group_ids = [aws_security_group.sg_k8s.id]
  tags = {
     Name = "k8s"
     Role = "worker"
  }

  # Wait for SSH connection to become available, which means VM is up and running
  provisioner "remote-exec" {
    inline = ["echo 'SSH is up!'"]
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.SSH_USER
      private_key = file(var.PATH_TO_PRIVATE_KEY)
    }
  }
}

# After we got ip addresses of our k8s nodes we can create inventory file for ansible from a template
resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      k8s_masters = aws_instance.k8s-master.*.public_ip
      k8s_workers = aws_instance.k8s-worker.*.public_ip
      path_to_private_key = var.PATH_TO_PRIVATE_KEY
    }
  )
  filename = "${path.module}/../ansible/inventory"

  # As soon inventory file is ready we can call Ansible playbook to configure k8s cluster
  provisioner "local-exec" {
    # Switching context to ansible folder
    working_dir = "${path.module}/../ansible/"
    # Run ansible-playbook, it will use freshly created inventory file
    # We use Force Color option because by default terrafrom output will be lack and white
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook k8s.yaml"
  }

  # Now we replace ip address in local ~/.kube/config to public one
  provisioner "local-exec" {
    # And we replace ip address in local ~/.kube/config to public one
    command = "sed -ri 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"${aws_instance.k8s-master.public_ip}"/ ~/.kube/config"
  }

  # Deploy plaltform and application layers
  provisioner "local-exec" {
    # Switching context to root
    working_dir = "${path.module}/../../"
    command = <<EOT
      "kubectl apply -f ./platform/namespace.yaml"
      "kubectl apply -f ./platform/user/"
      "kubectl apply -f ./platform/nfs-server/"
      "kubectl apply -f ./app/mysql/"
      "kubectl apply -f ./app/wordpress/"
    EOT
  }
}
