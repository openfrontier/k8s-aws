# Using Terraform to provision ecs instances for k8s cluster

## Quick start

```shell
cp terraform.tfvars.template terraform.tfvars
vi terraform.tfvars
terraform init
terraform apply
```

A new vpc with according sub-network, security-group, route-table, etc are created.
A New ec2 instances will be created into this vpc with appropriated settings.
A Rancher server will be started on the ec2 instance.

## Destroy everything created above

```shell
terraform destroy
```
