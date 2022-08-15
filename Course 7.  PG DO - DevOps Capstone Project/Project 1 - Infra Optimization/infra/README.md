# STEPS
1. Generate ssh keypair to manage AWS VM  
    ssh-keygen -t rsa -f ~/.ssh/aws-rsa
3. Install 
    ansible-galaxy collection install kubernetes.core
    pip3 install kubernetes
2. cd /terraform  
3. Copy terraform.tfvars.example to terraform.tfvars and fill it with your AWS credentials  
3. Run terraform
    - terrafrom init
    - terrafrom plan
    - terrafrom apply
4. Terraform will prepare local k8s cluster config ~/.kube/config 