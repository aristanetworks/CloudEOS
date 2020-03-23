# Introduction 

This folder has Terraform scripts to launch and configure CloudEOS in various public clouds.

*Note that following the instructions will cause instances to be launched in your public cloud and incur expenses. Make sure you destroy the resources after testing*

# Prerequisites

1) Public cloud account credentials eg AWS Access key and secret
2) Terraform installed on your laptop/server
3) CloudVision access - Please contact your Arista rep or sales@arista.com to get access to CloudVision, Security webtoken for CloudVision, Arista Terraform provider plugins 
4) Subscribe to Arista CloudEOS PAYG offer in the cloud marketplace
5) Create a Container in CloudVision which will be used to provision the routers. Steps are outlined in "CloudEOS MultiCloud Deployment Guide"

## Installing Terraform

Follow the steps at https://learn.hashicorp.com/terraform/getting-started/install.html 

## Get AWS and Arista providers

Since the Arista Terraform provider isn't bundled with terraform yet please contact Arista to get terraform-arista-plugin_latest.tar.gz and save it CloudEOS/terraform folder.

'''
cd CloudEOS/terraform
./setup.sh
'''

## Setup AWS Credentials

Security credentials for AWS from your IT Team or from your AWS account; Terraform will need these to authenticate with AWS and create resources. 

Set the following environment variables in your shell
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN

Run the terraform deployment with the above environment variables set.

# Deploying Topologies

The examples directory contains terraform files for various topologies that you can deploy. While you will only have to modify the input_vars.tfvars file to get the topologies to work, feel free to modify the code to create your own topologies to suit your requirement. 

## Change directory to the example topology

It is recommended that if this is the first time, try out "aws_oneregion_multipleleaf" and then "aws_tworegion_cloudha"

```bash
cd examples/aws_oneregion_multipleleaf
```

## Update Input variables

Please update the input parameters in **input_vars.tfvars** for the example topology before you deploy them. 

## Create Topology, Route Reflector, Edge and Leaf Routers

It's necessary to create resources in the following order.
1. Topology and Route Reflector
2. Edge
3. Leaf

## For MAC OS
1. To create Topology and Route Reflector

*Please note that in some topologies like aws_tworegion_clos this step is combined with the next step of creating edge resources. In that case you can skip this step and start with step 2 or createing edge reources*

Assuming current directory to be this directory. Execute to below commands to
create topology and route reflector.

```bash
cd topology
terraform init --plugin-dir=../../../.terraform/plugins/darwin_amd64/
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

2. To create Edge resources
Assuming current directory to be this directory.

```bash
cd edge
terraform init --plugin-dir=../../../.terraform/plugins/darwin_amd64/
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

3. To create Leaf resources
Assuming current directory to be this directory.

```bash
cd leaf
terraform init --plugin-dir=../../../.terraform/plugins/darwin_amd64/
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

**Don't forget to terraform destroy..see steps at the end**

## For Linux 
1. To create Topology and Route Reflector

Assuming current directory to be this directory. Execute to below commands to create topology and route reflector.

*Please note that in some topologies like aws_tworegion_clos this step is combined with the next step of creating edge resources. In that case you can skip this step and start with step 2 or createing edge reources*


```bash
cd topology
terraform init --plugin-dir=../../../.terraform/plugins/linux_amd64/
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

2. To create Edge resources
Assuming current directory to be this directory.

```bash
cd edge
terraform init --plugin-dir=../../../.terraform/plugins/linux_amd64/
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

3. To create Leaf resources

Assuming current directory to be this directory.

```bash
cd leaf
terraform init --plugin-dir=../../../.terraform/plugins/linux_amd64/
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

## To destroy resources

It's necessary to destroy in following order

1. Destory Leaf resources

```bash
terraform destroy -var-file=../input_vars.tfvars
```

2. Destory Edge resources

```bash
terraform destroy -var-file=../input_vars.tfvars
```

3. Destory Topology and Route Reflector resources

```bash
terraform destroy -var-file=../input_vars.tfvars
```

# LINUX host for testing : Setting username and password 

The Linux host comes with iperf3 installed. To login to host you can use various steps listed below:

## Using pem file
Copy the pem file to the cloudeos then ssh to device using pem file.

## Using default username
If you have not provided a custom username and passwd in terraform host
module then you can login to the host using "cloudeos" username and "cloudeos1234!" password.

## Using custom username and password
To setup a custom username and password, you need to set the below variables in host terraform module.

```
username = "foo"
passwd = "$1$SaltSalt$YhgRYajLPrYevs14poKBQ0"
```

The above password is generated from plain-test password "secret" using a salt "SaltSalt" usign the following command.

```
openssl passwd -1 -salt SaltSalt secret
```

Example

```
module "Region2Leaf1host1" {
                source = "../../../module/arista/aws/host"
                instance_type = "c5.xlarge"                            
                username = "foo"
                passwd = "$1$SaltSalt$YhgRYajLPrYevs14poKBQ0"
                // ...
}
```
# iPerf Command Examples

Iperf commands:

## TCP
```bash
iperf3 -s -p 5005 -I 1
iperf3 -c 10.19.1.133 -p -P 8 5005 -t 600 -I 1
```

## UDP
```bash
iperf3 -s -p 5005 -I 1
iperf3 -c 10.19.1.133 -u -p 5005 -b 500M -P 8 --length 900 -t 600 -i 1
```
