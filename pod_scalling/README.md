- if you're running in the cloud, you can install the metric-server by running 
    ```
    $ kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    ```
- if you're running locally, you can run the [metrics-server.yaml](metrics-server/metrics-server.yaml) file.
    ```
    $ kubectl apply -f metrics-server/metrics-server.yaml
    ```
- if you run into `readines probe failed` error for the metrics-server pods while using the first option, consider using the [metrics-server.yaml](metrics-server/metrics-server.yaml) file to deploy the [metrics-server](metrics-server/metrics-server.yaml) locally.
- kubectl auto-sacle deploy my-deply --cpu-percent=50 --min=1 --max=10
- helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server
helm repo update metrics-server

helm install metrics-server metrics-server/metrics-server --version 3.11.0\
  --namespace metrics-server \
  --create-namespace \
  -f "metrics-server-v3.11.0.yaml"


  kubectl edit clusterrolebinding metrics-server:system:auth-delegator --editor="code --wait"
  kubectl edit clusterrolebinding metrics-server:system:auth-delegator

  kubectl get clusterrolebinding metrics-server:system:auth-delegator -o yaml > metrics-server-rbac.yaml

$ docker port <CONTAINER_ID>
22/tcp -> 127.0.0.1:58408
2376/tcp -> 127.0.0.1:58409

scp -i $(minikube ssh-key) -P 58408 /media/myuser/sourceFolder docker@127.0.0.1:/home/docker/destiationFolde