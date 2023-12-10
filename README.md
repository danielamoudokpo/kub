## Ecrivez ici les inscriptions et explications pour déployer l'infrastructure et l'application sur Azure

## start minikub

```bash
minikube start
```

## get pods to verifie

```bash
kubectl get pods
```

## login azur in terraform folder

```bash
cd terraform
az login
```

## init project in terraform folder

```bash
terraform init
```

## plan achitercture in terraform folder

```bash
terraform plan
```

## apply change in terraform folder

```bash
terraform apply
```

## Move into flask-app folder and log inside the ACR

```bash
cd .. && cd flask-app
az acr login --name <acr-name>
```

## Create a Docker image and push it to the ACR

## lowercase acrname

```bash
docker build -t <your-acr-name>.azurecr.io/flask-app:v1 .
docker push <your-acr-name>.azurecr.io/flask-app:v1
```

## Move inside the kubernetes folder and log inside the cluster

```bash
cd .. && cd kubernetes
az aks get-credentials --overwrite-existing -n <cluster name> -g <resource group name>
```

## Add the ingress-nginx repository

```bash
helm create flask-app
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

## Deploy Redis

```bash
kubectl create namespace redis
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-redis bitnami/redis --namespace redis
```

## Deploy flask-app

```bash
kubectl apply -f flask-app/flask-app.yaml
```

## Deploy Ingress

## Add your ip address in flask-ingress.yaml before deployement

```bash
kubectl apply -f flask-app/flask-ingress.yaml
```

## (Optional) Verify if all services are up and running

```bash
kubectl get services -o wide -w
```
