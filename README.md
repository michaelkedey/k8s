# k8s
**Directory Structure**
# Project Structure

```plaintext
$ tree
.
|-- README.md        
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
|-- helm
|   |-- get_helm.sh
|   |-- helm1
|   |   `-- vote-app-chart
|   |       |-- Chart.yaml
|   |       |-- charts
|   |       |-- templates
|   |       |   |-- _helpers.tpl        
|   |       |   |-- deployments
|   |       |   |   |-- db.yaml
|   |       |   |   |-- redis.yaml
|   |       |   |   |-- result.yaml     
|   |       |   |   |-- vote.yaml
|   |       |   |   `-- worker.yaml     
|   |       |   |-- ingress
|   |       |   |   `-- ingress.yaml
|   |       |   |-- roleBindings        
|   |       |   |   `-- all_access_role_binding.yaml
|   |       |   |-- roles
|   |       |   |   `-- all_access_roles.yaml
|   |       |   |-- secrets
|   |       |   |   `-- secret.yaml     
|   |       |   |-- service-accounts    
|   |       |   |   `-- allAccess.yaml
|   |       |   |-- svcs
|   |       |   |   |-- db-svc.yaml     
|   |       |   |   |-- redis-svc.yaml
|   |       |   |   |-- result-scv.yaml 
|   |       |   |   `-- vote-svc.yaml
|   |       |   `-- volumes
|   |       |       |-- pv
|   |       |       |   |-- db_pv.yaml
|   |       |       |   `-- redis_pv.yaml
|   |       |       `-- pvc
|   |       |           |-- db_pvc.yaml 
|   |       |           `-- redis_pvc.yaml
|   |       |-- values
|   |       |   |-- dev-values.yaml     
|   |       |   |-- prod-values.yaml    
|   |       |   `-- staging-values.yaml
|   |       `-- values.yaml
|   `-- helm2
|       `-- vote-app-chart
|           |-- Chart.yaml
|           |-- charts
|           |-- templates
|           |   |-- _helpers.tpl        
|           |   |-- deployments
|           |   |   `-- deploy.yaml
|           |   |-- ingress
|           |   |   `-- ingress.yaml
|           |   |-- roleBindings
|           |   |   `-- all_access_role_binding.yaml
|           |   |-- roles
|           |   |   `-- all_access_roles.yaml
|           |   |-- secrets
|           |   |   `-- secret.yaml
|           |   |-- service-accounts    
|           |   |   `-- allAccess.yaml
|           |   |-- svcs
|           |   |   `-- svc.yaml
|           |   `-- volumes
|           |       |-- pv
|           |       |   `-- pvs.yaml
|           |       `-- pvc
|           |           `-- pvcs.yaml   
|           |-- values
|           |   |-- dev-values.yaml     
|           |   |-- prod-values.yaml
|           |   |-- staging-values.yaml 
|           |   `-- values.yaml
|           `-- values.yaml
|-- kube-apiserver.yml
|-- pod_scalling
|   |-- hpa
|   |   |-- helm
|   |   |   `-- vote-app-chart
|   |   |       |-- Chart.yaml
|   |   |       |-- charts
|   |   |       |-- templates
|   |   |       |   |-- _helpers.tpl    
|   |   |       |   |-- deployments
|   |   |       |   |   `-- deploy.yaml 
|   |   |       |   |-- hpa
|   |   |       |   |   `-- hpa.yaml
|   |   |       |   |-- ingress
|   |   |       |   |   `-- ingress.yaml|   |   |       |   |-- roleBindings    
|   |   |       |   |   `-- all_access_role_binding.yaml
|   |   |       |   |-- roles
|   |   |       |   |   `-- all_access_roles.yaml
|   |   |       |   |-- secrets
|   |   |       |   |   `-- secret.yaml
|   |   |       |   |-- service-accounts|   |   |       |   |   `-- allAccess.yaml
|   |   |       |   |-- svcs
|   |   |       |   |   `-- svc.yaml
|   |   |       |   `-- volumes
|   |   |       |       |-- pv
|   |   |       |       |   `-- pvs.yaml|   |   |       |       `-- pvc
|   |   |       |           `-- pvcs.yaml
|   |   |       |-- values
|   |   |       |   |-- dev-values.yaml 
|   |   |       |   |-- prod-values.yaml|   |   |       |   |-- staging-values.yaml
|   |   |       |   `-- values.yaml     
|   |   |       `-- values.yaml
|   |   `-- hpa.yaml
|   |-- metrics-server
|   |   |-- metrics-server-components.yaml
|   |   |-- metrics-server-values.yaml  
|   |   `-- prometheus.yaml
|   `-- vpa
|       |-- helm
|       |   `-- vote-app-chart
|       |       |-- Chart.yaml
|       |       |-- charts
|       |       |-- templates
|       |       |   |-- _helpers.tpl
|       |       |   |-- deployments     
|       |       |   |   `-- deploy.yaml 
|       |       |   |-- ingress
|       |       |   |   `-- ingress.yaml|       |       |   |-- roleBindings    
|       |       |   |   `-- all_access_role_binding.yaml
|       |       |   |-- roles
|       |       |   |   `-- all_access_roles.yaml
|       |       |   |-- secrets
|       |       |   |   `-- secret.yaml
|       |       |   |-- service-accounts|       |       |   |   `-- allAccess.yaml
|   `-- allAccess.yaml
|       |       |   |-- svcs
|       |       |   |   `-- svc.yaml
|       |       |   |-- volumes
|       |       |   |   |-- pv                              |   `-- pvc
|       |       |   |   |   `-- pvs.yaml|       |       |   
|   `-- pvc
|       |       |   |       `-- pvcs.yaml
|       |       |   `-- vpa
|       |       |       `-- vpa.yaml
|       |       |-- values                                  |-- staging-values.yaml
|       |       |   |-- dev-values.yaml
|       |       |   |-- prod-values.yaml|       |       |   
|-- staging-values.yaml
|       |       |   `-- values.yaml
|       |       `-- values.yaml
|       |-- vpa-crd.yaml
|       `-- vpa.yaml
|-- ssl-script.sh
`-- terraform.tfstate

75 directories, 108 files

```

