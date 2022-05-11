#!/bin/bash

cd infra/terraform

# iniciar terraform (primeira execução)
terraform init -upgrade

# alterar ambiente
terraform apply -auto-approve

# compilar imagens
cd ../../app/customers
docker build -t customers .
cd ../frontend
docker build -t frontend .
cd ../kong
docker build -t configure-kong .
cd ../vets
docker build -t vets .
cd ../visits
docker build -t visits .

# taggear a imagem com latest
docker tag customers:latest testemicroservicesacr.azurecr.io/customers:latest
docker tag frontend:latest testemicroservicesacr.azurecr.io/frontend:latest
docker tag configure-kong:latest testemicroservicesacr.azurecr.io/configure-kong:latest
docker tag vets:latest testemicroservicesacr.azurecr.io/vets:latest
docker tag visits:latest testemicroservicesacr.azurecr.io/visits:latest

# login no repositorio de imagem do Azure (privado)
az acr login --name testemicroservicesacr

# subir imagem
docker push testemicroservicesacr.azurecr.io/customers:latest
docker push testemicroservicesacr.azurecr.io/frontend:latest
docker push testemicroservicesacr.azurecr.io/configure-kong:latest
docker push testemicroservicesacr.azurecr.io/vets:latest
docker push testemicroservicesacr.azurecr.io/visits:latest

# obter credenciais do AKS
az aks get-credentials --resource-group rg-microservices --name teste-aks --overwrite-existing

cd ../../

# instalar EFK
kubectl apply -f infra/efk/01-namespace.yaml
kubectl apply -f infra/efk/02-elastic-svc.yaml
kubectl apply -f infra/efk/03-elastic-stateful.yaml
kubectl apply -f infra/efk/04-kibana-svc.yaml
kubectl apply -f infra/efk/05-kibana-deployment.yaml
kubectl apply -f infra/efk/06-fluentd-security.yaml
kubectl apply -f infra/efk/07-fluentd-daemon.yaml

# instalar istio
istioctl install -y

# verificar instalação
istioctl verify-install

# instalar monitoramento
kubectl apply -f infra/istio/monitoring

# subir configuração da aplicação
kubectl apply -f infra/k8s/01-config
kubectl apply -f infra/k8s/02-db
kubectl apply -f infra/k8s/03-backend
kubectl apply -f infra/k8s/04-api
kubectl apply -f infra/k8s/05-frontend
kubectl apply -f infra/k8s/06-kong

# instalar virtual services
kubectl apply -f infra/istio -n aulainfra

# acessar
# kubectl port-forward --namespace kube-logging svc/kibana 5602:5601
# curl http://springapp.westus.cloudapp.azure.com/
# istioctl dashboard [kiali grafana prometheus]