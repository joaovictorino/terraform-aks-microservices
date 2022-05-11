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

# instalar Elastic Stack
kubectl apply -f infra/elastic/01-namespace.yaml
kubectl apply -f infra/elastic/02-elastic.yaml

sleep 180

kubectl apply -f infra/elastic/03-kibana.yaml
kubectl apply -f infra/elastic/04-filebeat.yaml

sleep 60

# instalar istio
istioctl install -y

# verificar instalação
istioctl verify-install

# instalar monitoramento
kubectl apply -f infra/istio/monitoring/01-prometheus.yaml
kubectl apply -f infra/istio/monitoring/02-grafana.yaml
kubectl apply -f infra/istio/monitoring/03-jaeger.yaml
kubectl apply -f infra/istio/monitoring/04-kiali.yaml
sleep 30
kubectl apply -f infra/istio/monitoring/05-kiali-monitoring.yaml

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
# kubectl port-forward deployment/kibana 5601 -n kube-logging
# kubectl port-forward sts/elasticsearch-master 9200 -n kube-logging
# curl http://localhost:9200/_cat/indices?v
# curl http://springapp.westus.cloudapp.azure.com/
# istioctl dashboard [kiali grafana prometheus]