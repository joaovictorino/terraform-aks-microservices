# login azure (primeira execução)
az login

# criar chaves de acesso ao Azure para o terraform (primeira execução)
az ad sp create-for-rbac --skip-assignment

cd terraform

# iniciar terraform (primeira execução)
terraform init

# planejar alterações
terraform plan

# alterar ambiente
terraform apply

# obter credenciais do AKS
az aks get-credentials --resource-group rg-microservices --name teste-aks

# compilar imagens
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

# subir configuração da aplicação
kubectl apply -f k8s/01-config
kubectl apply -f k8s/02-db
kubectl apply -f k8s/03-backend
kubectl apply -f k8s/04-api
kubectl apply -f k8s/05-frontend
kubectl apply -f k8s/06-kong