# Using Terraform to provision ecs instances for k8s cluster

## Quick start

```shell
cp terraform.tfvars.template terraform.tfvars
vi terraform.tfvars
terraform init
terraform apply
```

A new vpc with according sub-network, security-group, route-table, etc are created.
New ec2 instances will be created into this vpc with appropriated settings.

## Destroy everything created above

```shell
terraform destroy
```