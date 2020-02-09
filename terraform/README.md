# Introduction 

This folder has Terraform scripts to launch and configure CloudEOS in various public clouds.

Note that following the instructions will cause instances to be launched in your public cloud
and incur expenses. 

# Prerequisites

1) Public cloud account credentials eg AWS Access key and secret.
2) Terraform installation.

# Arista CloudVision Terraform provider 

Since the provider isn't an offical Terraform provider yet, the provider binary is in the repository.

# Steps

## Installing Terraform

Follow the steps at https://learn.hashicorp.com/terraform/getting-started/install.html 

## Get AWS and Arista providers

The below steps assumes current working directory as this directory containing README file.
1. Create directory *.terraform/plugins/linux_amd64* and add 'arista cvp provider', 'aws provider'
   and 'aws template'.

```bash
> ls
AristaTesting-IPSec.json  AristaTesting-vEOS.json  README.md  examples  module  userdata
>
> mkdir .terraform
> mkdir .terraform/plugins
> mkdir .terraform/plugins/linux_amd64
```

Copy arista, aws provider and template to *.terraform/plugins/linux_amd64* directory.

```bash
ll .terraform/plugins/linux_amd64/
total 205508
-rwxrwxr-x 1 xxxx xxxx  36374026 Feb  9 05:27 terraform-provider-arista
-rwxrwxr-x 1 xxxx xxxx 153243648 Feb  9 05:27 terraform-provider-aws_v2.47.0_x4
-rwxrwxr-x 1 xxxx xxxx  20812960 Feb  9 05:27 terraform-provider-template_v2.1.2_x4
```
### Update Input variables
Before deploying resources look at the input parameters passed to terraform like ami,
instance_type, regions etc.

File containing input parameters: *examples/aws_tworegion_clos/terraform.tfvars*

You can update the values based on your requirement.

# create Topology, Route Reflector, Edge and Leaf Routers

It's necessary to create resources in the following order.
1. Topology and Route Reflector
2. Edge
3. Leaf

1. To create Topology and Route Reflector

Assuming current directory to be this directory. Execute to below commands to
create topology and route reflector.

```bash
cd examples/aws_tworegion_clos/topology/
terraform init --plugin-dir=../../../.terraform/plugins/linux_amd64/
terraform plan -var-file=../terraform.tfvars
terraform apply -var-file=../terraform.tfvars
```

2. To create Edge resources
Assuming current directory to be this directory.

```bash
cd examples/aws_tworegion_clos/edge/
terraform init --plugin-dir=../../../.terraform/plugins/linux_amd64/
terraform plan -var-file=../terraform.tfvars
terraform apply -var-file=../terraform.tfvars
```

3. To create Leaf resources

Assuming current directory to be this directory.

```bash
cd examples/aws_tworegion_clos/leaf/
terraform init --plugin-dir=../../../.terraform/plugins/linux_amd64/
terraform plan -var-file=../terraform.tfvars
terraform apply -var-file=../terraform.tfvars
```

## To destroy resources

It's necessary to destroy in following order
1. Leaf
2. Edge
3. Topology and Route Reflector

1. To destory Leaf resources

```bash
terraform destroy -var-file=../terraform.tfvars
```

2.To destory Edge resources

```bash
terraform destroy -var-file=../terraform.tfvars
```

3. To destory Topology and Route Reflector resources

```bash
terraform destroy -var-file=../terraform.tfvars
```