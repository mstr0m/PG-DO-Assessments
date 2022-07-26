# Project 1 - Deploy the Application Using the Kubernetes Dashboard

# Deploy k8s dashboard
kubectl apply -f  https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
# Patch svc to use NodePort
kubectl -n kubernetes-dashboard patch svc kubernetes-dashboard -p '{"spec": {"type": "NodePort"}}'

# Create user and assigne admin role
kubectl apply -f sandry/
# Get login token for k8s dashboard
SA_NAME="sandry"
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep ${SA_NAME} | awk '{print $1}')

# Configure NFS server
# Node 3 (worker 2)
sudo -i
mkdir /nfs-share
apt update && install nfs-kernel-server -y
echo -e "/nfs-share 	*(rw,sync,no_root_squash)" >> /etc/exports
exportfs -rv
chown nobody:nogroup /nfs-share/
chmod 777 /nfs-share/
systemctl restart nfs-kernel-server
ip a | grep inet | awk 'FNR == 3 {print $2}' | cut -d '/' -f1
# worker nodes
apt install nfs-common


# Platform Deployment
kubectl apply -f namespace.yaml
kubectl apply -f quota.yaml
kubectl apply -f nfs-pv.yaml
# Create mysql secret
kubectl create secret generic wordpress-mysql-env --from-literal=MYSQL_ROOT_PASSWORD=password -n cep-project1
# Wordpress Deployment
kubectl apply -f wordpress/
kubectl apply -f mysql/