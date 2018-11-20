# Using Terraform to provision a k8s cluster on aws

## Quick start

```shell
cd rancher-server
cp terraform.tfvars.template terraform.tfvars
vi terraform.tfvars
terraform init
terraform apply -auto-approve

cd ../k8s-cluster
cp terraform.tfvars.template terraform.tfvars
vi terraform.tfvars
terraform init
terraform apply -auto-approve
```

A new vpc with according sub-network, security-group, route-table, etc are created.
New ec2 instances will be created into this vpc with appropriated settings.
A Rancher server will be started.
A Rancher based kubernetes cluster will be created.

## Destroy everything created above

```shell
cd rancher-server
terraform destroy
cd ../k8s-cluster
terraform destroy
```
