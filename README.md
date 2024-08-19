# k8s
### Overview
**This repo contains kubernetes manifests for for deploying the [vote-app application](https://github.com/michaelkedey/example-voting-app)**
- [fork](https://github.com/michaelkedey/k8s/fork) and [clone](https://github.com/michaelkedey/k8s.git) the [k8s repo](https://github.com/michaelkedey/k8s/fork) to stay updated with any changes.
**This repo contains codes for :**
-[ansible](./ansible/)
    - in this configuration, i used `terraform` to provission an ansible control host and a fleet of servers
    - in the ansible configurations, i have defined `roles` and `playbooks` to manage the fleet of servers from the control host
    - i have defind roles to `ping`, check commecetivity to `specific ports` and perform `apache` installations on the server fleets.
- [argo_cd](./argo_cd)
    - this manifest file defines how you can deploy the [vote-app application](https://github.com/michaelkedey/example-voting-app) via `argo_cd`, a continous delivery (cicd) tool.
        - [fork](https://github.com/michaelkedey/practice-devops-assignments/fork) the [practice-devops-assignmnets repo](https://github.com/michaelkedey/practice-devops-assignments/fork) and refer to [assignment_014](https://github.com/michaelkedey/practice-devops-assignments/tree/main/assignment_014) for how to set up your `argo_cd` server. 
- [eks - amazon elastic kubernetes service](./eks/terraform/)
    - here, I have deffined in `terraform` how to set up an `eks` cluster, complete with the nrtworking required to succesfully deploy the [vote-app application](https://github.com/michaelkedey/example-voting-app)
    - there are modules which contains the cluster setup, networking and jumper server
    - refer to the [eks - amazon elastic kubernetes service](./eks/terraform/)directory structure for how to set up a similar cluster via `terraform`
    - to run this code:
        -  (fork)[https://github.com/michaelkedey/k8s/fork] and [clone](https://github.com/michaelkedey/k8s.git) the [k8s repo]
        -  make sure you have `terraform` configured on your local
        -  make sure you have `awscli` configured with the correct iam credentials
        -  `cd` to the `eks` directory
            ```
            cd eks/terraform
            ```
        - change the `backend`  configuration to local
            -  open the [providers.tf](./eks/terraform/providers.tf) file and comment out the backend configuration
            -  open the `.format.sh` script and modify the init command by removing the backend arguement
                ```
                terraform init
                ```
            - open the `env/.terraform.tfvars` file and change the the key_name to the `iam key` you have in `aws`
            - chnage the private-key to the path to the downloaded `key pair` on your local machine
        - execute the `.format.sh` to initialize terraform on your local macchine, and format and valifdate the code
        - run `terraform plan` to plan the resources that will be created
        - run `terraform apply` and submit yes when prompted, to create the resources
        - get the `cluster name` and `jumper server public ip` from the outputs in the terminal 
    - **remember `eks` is very expensive to run, therefor resources must be destroyed after pcatice**
    - access the cluster from your local machine
        - run
        ```
        aws eks update-kubeconfig --name <cluster-name> --region <cluster-region>
        ```  
    - verify the eks cluster is accessible from your loca; environemnt
        - run
        ```
        kubectl config get-contexts
        ```  
    - destroy your `eks`
        ```
        terraform destroy --auto-approve
        ```
- [helm](./helm/)
    - this contains `helm` charts which completely define how to deploy the [vote-app application](https://github.com/michaelkedey/example-voting-app) via `helm`
    - it has 2 charts [vote-app-char-1](./helm/vote-app-chart-1/) and [vote-app-char-2](./helm/vote-app-chart-2/)
    - both charts contain similar configurations to deploy the [vote-app application](https://github.com/michaelkedey/example-voting-app)  
    - **happy helming**
- [pod_scalling](./pod_scalling/)
    - here, I have deffined similar helm charts for the `vote-app` but with extra resources or features.
    - this include :
      - [hpa - horizontal pod scaling](./pod_scalling/hpa/)
      - [vpa - vertical pod scaling](./pod_scalling/vpa/)
      - [modified metrics server](./pod_scalling/metrics-server/)
    - **happy helming**
- [s3_helm_repo](./s3_helm_repo/)
  - this contains `terraform` configurations to set up an `s3` bucket as a `helm` `repository
  - to add my `vote-app-repo` to your helm charts
    - add the repo
        ```
        helm repo add s3-vote-app-repo https://helm-myoneansonlyhelmrepobucket.s3.us-east-1.amazonaws.com
        ```
    - update repo list
        ```
        helm repo update
        ```
    - install the `vote-app` via the new repo you just added
        ```
        helm install vote-app s3-vote-app-repo/vote-app-chart-1
        ```
    - **happy helming**


### Directory Structure

```plaintext
$ tree
.
|-- README.md    
|-- ansible      
|   |-- inventory
|   |-- playbooks
|   |   |-- apache.yaml 
|   |   |-- apache2.yaml
|   |   `-- networking.yaml
|   |-- roles
|   |   |-- apache
|   |   |   |-- defaults
|   |   |   |   `-- main.yaml
|   |   |   |-- handlers
|   |   |   |-- meta    
|   |   |   |   `-- main.yaml
|   |   |   |-- tasks     
|   |   |   |   `-- main.yaml    
|   |   |   |-- templates        
|   |   |   |   `-- index.html.j2
|   |   |   `-- vars
|   |   `-- networking
|   |       |-- README.md
|   |       |-- defaults
|   |       |-- handlers
|   |       |-- tasks
|   |       `-- vars
|   `-- server_fleet
|       |-- env
|       |   `-- backend.tfvars
|       |-- main.tf
|       |-- modules
|       |   |-- master
|       |   |   |-- data.tf
|       |   |   |-- iam.tf
|       |   |   |-- master.tf
|       |   |   |-- output.tf
|       |   |   |-- provider.tf
|       |   |   |-- ssm_agent.sh
|       |   |   `-- variables.tf
|       |   |-- networking
|       |   |   |-- locals.tf
|       |   |   |-- network.tf
|       |   |   |-- output.tf
|       |   |   |-- provider.tf
|       |   |   |-- store.tf
|       |   |   `-- variables.tf
|       |   `-- servers
|       |       |-- data.tf
|       |       |-- locals.tf
|       |       |-- outputs.tf
|       |       |-- providers.tf
|       |       |-- servers.tf
|       |       `-- variables.tf
|       |-- output.tf
|       |-- providers.tf
|       `-- variables.tf
|-- argo_cd
|   `-- vote_app.yaml
|-- eks
|   |-- kubeconfig
|   `-- terraform
|       |-- env
|       |   `-- backend.tfvars
|       |-- main.tf
|       |-- modules
|       |   |-- cluster
|       |   |   |-- cluster.tf
|       |   |   |-- outputs.tf
|       |   |   |-- provider.tf
|       |   |   |-- ssm_agent.sh
|       |   |   `-- variables.tf
|       |   |-- jumper_server
|       |   |   |-- bastion.tf
|       |   |   |-- output.tf
|       |   |   |-- provider.tf
|       |   |   |-- ssm_agent.sh
|       |   |   `-- variables.tf
|       |   `-- networking
|       |       |-- cluster_network.tf
|       |       |-- locals.tf
|       |       |-- output.tf
|       |       |-- provider.tf
|       |       |-- store.tf
|       |       `-- variables.tf
|       |-- outputs.tf
|       |-- providers.tf
|       `-- variables.tf
|-- get_helm.sh
|-- helm
|   |-- vote-app-chart-1
|   |   |-- Chart.yaml
|   |   |-- charts
|   |   |-- templates
|   |   |   |-- _helpers.tpl
|   |   |   |-- deployments
|   |   |   |   |-- db.yaml
|   |   |   |   |-- redis.yaml
|   |   |   |   |-- result.yaml
|   |   |   |   |-- vote.yaml
|   |   |   |   `-- worker.yaml
|   |   |   |-- ingress
|   |   |   |   `-- ingress.yaml
|   |   |   |-- roleBindings
|   |   |   |   `-- all_access_role_binding.yaml
|   |   |   |-- roles
|   |   |   |   `-- all_access_roles.yaml
|   |   |   |-- secrets
|   |   |   |   `-- secret.yaml
|   |   |   |-- service-accounts
|   |   |   |   `-- allAccess.yaml
|   |   |   |-- svcs
|   |   |   |   |-- db-svc.yaml
|   |   |   |   |-- redis-svc.yaml
|   |   |   |   |-- result-scv.yaml
|   |   |   |   `-- vote-svc.yaml
|   |   |   `-- volumes
|   |   |       |-- pv
|   |   |       |   |-- db_pv.yaml
|   |   |       |   `-- redis_pv.yaml
|   |   |       `-- pvc
|   |   |           |-- db_pvc.yaml
|   |   |           `-- redis_pvc.yaml
|   |   |-- values
|   |   |   |-- dev-values.yaml
|   |   |   |-- prod-values.yaml
|   |   |   `-- staging-values.yaml
|   |   `-- values.yaml
|   `-- vote-app-chart-2
|       |-- Chart.yaml
|       |-- charts
|       |-- templates
|       |   |-- _helpers.tpl
|       |   |-- deployments
|       |   |   `-- deploy.yaml
|       |   |-- ingress
|       |   |   `-- ingress.yaml
|       |   |-- roleBindings
|       |   |   `-- all_access_role_binding.yaml
|       |   |-- roles
|       |   |   `-- all_access_roles.yaml
|       |   |-- secrets
|       |   |   `-- secret.yaml
|       |   |-- service-accounts
|       |   |   `-- allAccess.yaml
|       |   |-- svcs
|       |   |   `-- svc.yaml
|       |   `-- volumes
|       |       |-- pv
|       |       |   `-- pvs.yaml
|       |       `-- pvc
|       |           `-- pvcs.yaml
|       |-- values
|       |   |-- dev-values.yaml
|       |   |-- prod-values.yaml
|       |   |-- staging-values.yaml
|       |   `-- values.yaml
|       `-- values.yaml
|-- kube-apiserver.yml
|-- pod_scalling
|   |-- hpa
|   |   |-- helm
|   |   |   `-- vote-app-chart-hpa
|   |   |       |-- Chart.yaml
|   |   |       |-- charts
|   |   |       |-- templates
|   |   |       |   |-- _helpers.tpl
|   |   |       |   |-- deployments
|   |   |       |   |   `-- deploy.yaml
|   |   |       |   |-- hpa
|   |   |       |   |   `-- hpa.yaml
|   |   |       |   |-- ingress
|   |   |       |   |   `-- ingress.yaml
|   |   |       |   |-- roleBindings
|   |   |       |   |   `-- all_access_role_binding.yaml
|   |   |       |   |-- roles
|   |   |       |   |   `-- all_access_roles.yaml
|   |   |       |   |-- secrets
|   |   |       |   |   `-- secret.yaml
|   |   |       |   |-- service-accounts
|   |   |       |   |   `-- allAccess.yaml
|   |   |       |   |-- svcs
|   |   |       |   |   `-- svc.yaml
|   |   |       |   `-- volumes
|   |   |       |       |-- pv
|   |   |       |       |   `-- pvs.yaml
|   |   |       |       `-- pvc
|   |   |       |           `-- pvcs.yaml
|   |   |       |-- values
|   |   |       |   |-- dev-values.yaml
|   |   |       |   |-- prod-values.yaml
|   |   |       |   |-- staging-values.yaml
|   |   |       |   `-- values.yaml
|   |   |       `-- values.yaml
|   |   `-- hpa.yaml
|   |-- metrics-server
|   |   |-- metrics-server-components.yaml
|   |   |-- metrics-server-values.yaml
|   |   `-- prometheus.yaml
|   `-- vpa
|       |-- helm
|       |   `-- vote-app-chart-vpa
|       |       |-- Chart.yaml
|       |       |-- charts
|       |       |-- templates
|       |       |   |-- _helpers.tpl
|       |       |   |-- deployments
|       |       |   |   `-- deploy.yaml
|       |       |   |-- ingress
|       |       |   |   `-- ingress.yaml
|       |       |   |-- roleBindings
|       |       |   |   `-- all_access_role_binding.yaml
|       |       |   |-- roles
|       |       |   |   `-- all_access_roles.yaml
|       |       |   |-- secrets
|       |       |   |   `-- secret.yaml
|       |       |   |-- service-accounts
|       |       |   |   `-- allAccess.yaml
|       |       |   |-- svcs
|       |       |   |   `-- svc.yaml
|       |       |   |-- volumes
|       |       |   |   |-- pv
|       |       |   |   |   `-- pvs.yaml
|       |       |   |   `-- pvc
|       |       |   |       `-- pvcs.yaml
|       |       |   `-- vpa
|       |       |       `-- vpa.yaml
|       |       |-- values
|       |       |   |-- dev-values.yaml
|       |       |   |-- prod-values.yaml
|       |       |   |-- staging-values.yaml
|       |       |   `-- values.yaml
|       |       `-- values.yaml
|       |-- vpa-crd.yaml
|       `-- vpa.yaml
|-- s3_helm_repo
|   |-- env
|   |-- main.tf
|   |-- modules
|   |   |-- repo
|   |   |   |-- outputs.tf
|   |   |   |-- s3.tf
|   |   |   `-- variables.tf
|   |   `-- repo_files
|   |       |-- files.tf
|   |       `-- variables.tf
|   |-- output.tf
|   |-- providers.tf
|   |-- uploads
|   |   |-- index.yaml
|   |   |-- vote-app-chart-1-1.0.0.tgz
|   |   `-- vote-app-chart-2-1.0.0.tgz
|   `-- variables.tf
|-- ssl-script.sh
`-- terraform.tfstate

100 directories, 153 files
```

