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
5. 
K8S_MASTER_IP=x.x.x.x
sed -ri 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/$K8S_MASTER_IP/ ~/.kube/config
6. 
"kubectl apply -f ./platform/namespace.yaml"
      "kubectl apply -f ./platform/user/"
      "kubectl apply -f ./platform/nfs-server/"
      "kubectl apply -f ./app/mysql/"
      "kubectl apply -f ./app/wordpress/"