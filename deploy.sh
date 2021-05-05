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
az aks get-credentials --resource-group rg-aulainfra --name teste-aks

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
docker tag customers:latest aulainfraacr.azurecr.io/customers:latest
docker tag frontend:latest aulainfraacr.azurecr.io/frontend:latest
docker tag configure-kong:latest aulainfraacr.azurecr.io/configure-kong:latest
docker tag vets:latest aulainfraacr.azurecr.io/vets:latest
docker tag visits:latest aulainfraacr.azurecr.io/visits:latest

# login no repositorio de imagem do Azure (privado)
az acr login --name aulainfraacr

# subir imagem
docker push aulainfraacr.azurecr.io/customers:latest
docker push aulainfraacr.azurecr.io/frontend:latest
docker push aulainfraacr.azurecr.io/configure-kong:latest
docker push aulainfraacr.azurecr.io/vets:latest
docker push aulainfraacr.azurecr.io/visits:latest

# subir configuração da aplicação
kubectl apply -f aks/01-config
kubectl apply -f aks/02-db
kubectl apply -f aks/03-backend
kubectl apply -f aks/04-api
kubectl apply -f aks/05-frontend