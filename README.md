# Spring PetClinic Microservices application running on Azure Kubernetes Services (AKS) with Istio installed

## Install AKS with Terraform

Prerequisites:
- az-cli installed
- Terraform installed
- istioctl installed

Logon Azure
````sh
az login
````

Create RBAC key for first execution
````sh
az ad sp create-for-rbac --skip-assignment
````

Inside terraform folder, execute terraform initialization
````sh
terraform init
````

Execute Terraform files
````sh
terraform apply -auto-approve
````

Get AKS credential
````sh
az aks get-credentials --resource-group rg-microservices --name teste-aks
````

Build docker images of microservices
````sh
cd app/customers
docker build -t customers .
cd ../frontend
docker build -t frontend .
cd ../kong
docker build -t configure-kong .
cd ../vets
docker build -t vets .
cd ../visits
docker build -t visits .
````

Tagging images
````sh
docker tag customers:latest testemicroservicesacr.azurecr.io/customers:latest
docker tag frontend:latest testemicroservicesacr.azurecr.io/frontend:latest
docker tag configure-kong:latest testemicroservicesacr.azurecr.io/configure-kong:latest
docker tag vets:latest testemicroservicesacr.azurecr.io/vets:latest
docker tag visits:latest testemicroservicesacr.azurecr.io/visits:latest
````

Logon private Azure Container Registry (ACR)
````sh
az acr login --name testemicroservicesacr
````

Push imagens from local to ACR
````sh
docker push testemicroservicesacr.azurecr.io/customers:latest
docker push testemicroservicesacr.azurecr.io/frontend:latest
docker push testemicroservicesacr.azurecr.io/configure-kong:latest
docker push testemicroservicesacr.azurecr.io/vets:latest
docker push testemicroservicesacr.azurecr.io/visits:latest
````

Apply kubernetes configuration
````sh
kubectl apply -f k8s/01-config
kubectl apply -f k8s/02-db
kubectl apply -f k8s/03-backend
kubectl apply -f k8s/04-api
kubectl apply -f k8s/05-frontend
kubectl apply -f k8s/06-kong
````

Install Istio on AKS
````sh
istioctl install
````

Verify installation
````sh
istioctl verify-install
````

Install Istio configuration files
````sh
kubectl apply -f istio -n aulainfra
````

Install observability tools
````sh
kubectl apply -f istio/monitoring -n aulainfra
````

Access monitoring dashboards
````sh
istioctl dashboard [kiali grafana prometheus]
````

Access application
````sh
curl http://springapp.eastus.cloudapp.azure.com/
````
