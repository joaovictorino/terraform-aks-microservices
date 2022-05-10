# Instalação do Istio para Observabilidade

Pré-requisitos
- istioctl instalado

Instalar o Istio no cluster Kubernetes
````sh
istioctl install
````

Verificar se está tudo certo na instalação
````sh
istioctl verify-install
````

Incluir no namespace que seja monitorado a injeção do Istio (opcional)
````sh
kubectl label namespace default istio-injection=enabled
````

Fazer deploy dos arquivos do Istio
````sh
kubectl apply -f istio -n aulainfra
````

Fazer deploy das ferramentas de monitoramento
````sh
kubectl apply -f istio/monitoring -n aulainfra
````

Acessar os dashboards de monitoramento
````sh
istioctl dashboard [kiali grafana prometheus]
````
