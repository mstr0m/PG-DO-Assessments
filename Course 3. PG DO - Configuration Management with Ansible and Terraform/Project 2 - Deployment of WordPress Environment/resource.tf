# ADD PUBLIC KEY TO AWS. IT WILL BE USED DURING VM CREATION
resource "aws_key_pair" "aws_key" {
  key_name   = "aws_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# SETUP SECURITY GROUP - AWS FIREWALL
resource "aws_security_group" "sg_wordpress" {
  name = "sg_wordpress"
  # Port 22 will be used by Ansible SSH connection
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Port 80 will be used to access WordPress app
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Any outgoing traffic is allowed for VM
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 INSTANCE
resource "aws_instance" "wordpress" {
  ami           = var.AMIS["ubuntu"]
  instance_type = var.INSTANCE_TYPE
  # Add previously generated public key to VM
  key_name = aws_key_pair.aws_key.key_name
  # Add VM to security group
  vpc_security_group_ids = [aws_security_group.sg_wordpress.id]

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

  # As soon SSH is ready we can call Ansible playbook to configure WordPress app
  provisioner "local-exec" {
    # Switching context to ansible folder
    working_dir = "${path.module}/ansible/"
    # Run ansible-playbook for specific host and provide path to private key file
    command = "ansible-playbook -i ${self.public_ip}, --private-key ${var.PATH_TO_PRIVATE_KEY} wordpress.yaml"
  }

}