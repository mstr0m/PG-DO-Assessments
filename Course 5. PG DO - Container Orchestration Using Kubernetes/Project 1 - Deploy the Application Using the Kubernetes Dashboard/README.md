# Project 1 - Deploy the Application Using the Kubernetes Dashboard





kubectl apply -f namespace.yaml

kubectl apply -f quota.yaml

kubectl apply -f nfs-pv.yaml

Create mysql secret
kubectl create secret generic wordpress-mysql-env --from-literal=MYSQL_ROOT_PASSWORD=password -n cep-project1

kubectl apply -f wordpress/

kubectl apply -f mysql/