# k8s
**Directory Structure**
# Project Structure

```plaintext
$ tree
.
|-- README.md
|-- argo_cd
|   `-- vote_app.yaml
`-- helm
    |-- get_helm.sh
    |-- h1
    |   `-- vote-app-chart
    |       |-- Chart.yaml
    |       |-- charts
    |       |-- templates
    |       |   |-- _helpers.tpl
    |       |   |-- deployments
    |       |   |   |-- db.yaml
    |       |   |   |-- redis.yaml
    |       |   |   |-- result.yaml
    |       |   |   |-- vote.yaml
    |       |   |   `-- worker.yaml
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
    |       |   |   |-- db-svc.yaml
    |       |   |   |-- redis-svc.yaml
    |       |   |   |-- result-scv.yaml
    |       |   |   `-- vote-svc.yaml
    |       |   `-- volumes
    |       |       |-- pv
    |       |       |   |-- db_pv.yaml
    |       |       |   `-- redis_pv.yaml
    |       |       `-- pvc
    |       |           |-- db_pvc.yaml
    |       |           `-- redis_pvc.yaml
    |       |-- values
    |       |   |-- dev-values.yaml
    |       |   |-- prod-values.yaml
    |       |   `-- staging-values.yaml
    |       `-- values.yaml
    |-- h2
    |   `-- vote-app-chart
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
    `-- pod_scalling
        |-- hpa
        |   `-- vote-app-chart
        |       |-- Chart.yaml
        |       |-- charts
        |       |-- templates
        |       |   |-- _helpers.tpl
        |       |   |-- deployments
        |       |   |   `-- deploy.yaml
        |       |   |-- hpa
        |       |   |   `-- hpa.yaml
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
        `-- vpa
            `-- vote-app-chart
                |-- Chart.yaml
                |-- charts
                |-- templates
                |   |-- _helpers.tpl
                |   |-- deployments
                |   |   `-- deploy.yaml
                |   |-- ingress
                |   |   `-- ingress.yaml
                |   |-- roleBindings
                |   |   `-- all_access_role_binding.yaml
                |   |-- roles
                |   |   `-- all_access_roles.yaml
                |   |-- secrets
                |   |   `-- secret.yaml
                |   |-- service-accounts
                |   |   `-- allAccess.yaml
                |   |-- svcs
                |   |   `-- svc.yaml
                |   |-- volumes
                |   |   |-- pv
                |   |   |   `-- pvs.yaml
                |   |   `-- pvc
                |   |       `-- pvcs.yaml
                |   `-- vpa
                |       `-- vpa.yaml
                |-- values
                |   |-- dev-values.yaml
                |   |-- prod-values.yaml
                |   |-- staging-values.yaml
                |   `-- values.yaml
                `-- values.yaml

65 directories, 77 files
```
