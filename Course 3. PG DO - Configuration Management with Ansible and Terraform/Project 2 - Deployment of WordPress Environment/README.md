# Project 2: Deployment of WordPress Environment

# STEPS
1. Generate ssh keypair to manage AWS VM  
    ssh-keygen -t rsa -f ~/.ssh/aws-rsa  
2. Copy vars.tf.example to vars.tf and fill it with your AWS credentials  
3. Run terraform  
    terrafrom init  
    terrafrom plan  
    terrafrom apply  
4. Follow Ansible output to get WordPress URL.