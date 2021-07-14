# Introduction
The `module` folder has Terraform modules with multiple resources that are used together. We have created modules for VPC/VNET, Subnets, Routers and hosts.
These modules are used to deploy and setup the Cloud Provider underlay on which CloudEOS overlay network fabric will be created. The `example` folder has pre defined network topologies that use these modules to
build out a topology for you.

## Modules
The modules folder consists of the `cloudeos` folder which has subdirectories for `aws` and `azure`.

# Deploying Topologies

## Prerequisites
*Note that following the instructions will cause instances to be launched in your public cloud and incur expenses. Make sure you destroy the resources after testing*

1) Public cloud account credentials eg. AWS Access key and secret
2) Terraform installed on your laptop/server
3) CloudVision access - Please contact your Arista rep or sales@arista.com to get access to CloudVision(CVaaS) and create a security web token in CVaaS.
4) Subscribe to the Arista CloudEOS PAYG offer in the cloud marketplace
5) Create a Container in CloudVision which will be used to provision the routers. Steps are outlined in "CloudEOS MultiCloud Deployment Guide" (Please contact your Arista rep or sales@arista.com to get the guide)

## Installing Terraform

Follow the steps at https://learn.hashicorp.com/terraform/getting-started/install.html

## Setup AWS Credentials

Security credentials for AWS from your IT Team or from your AWS account; Terraform will need these to authenticate with AWS and create resources.

Set the following environment variables in your shell
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN

Run the terraform deployment with the above environment variables set.

## Setup Azure Credentials

Follow the guidelines to create and setup the keys for Azure [here](https://www.terraform.io/docs/providers/azurerm/index.html#authenticating-to-azure).


# Deploying Topologies

The examples directory contains terraform files for various topologies that you can deploy. While you will only have to modify the input_vars.tfvars file to get the topologies to work, feel free to modify the code to create your own topologies to suit your requirement.

## Change directory to the example topology

For example, if you want to deploy a topology in AWS in a single region,
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

1. To create Topology and Route Reflector

Assuming current directory to be "examples/name-of-topology" Eg "examples/aws_oneregion_multipleleaf". Execute to below commands to create topology and route reflector.

*Please note that in some topologies like aws_tworegion_clos this step is combined with the next step of creating edge resources. In that case you can skip this step and start with step 2 or createing edge reources*


```bash
cd topology
terraform init
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

2. To create Edge resources
Assuming current directory to be "examples/name-of-topology" Eg "examples/aws_oneregion_multipleleaf".

```bash
cd edge
terraform init
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

3. To create Leaf resources

Assuming current directory to be "examples/name-of-topology" Eg "examples/aws_oneregion_multipleleaf".

```bash
cd leaf
terraform init
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

## To destroy resources

It's necessary to destroy in following order. Assuming current directory to be "examples/name-of-topology" (eg. "examples/aws_oneregion_multipleleaf")

1. Destroy Leaf resources

```bash
cd leaf
terraform destroy -var-file=../input_vars.tfvars
```

2. Destroy Edge resources

```bash
cd edge
terraform destroy -var-file=../input_vars.tfvars
```

3. Destroy Topology and Route Reflector resources

```bash
cd topology
terraform destroy -var-file=../input_vars.tfvars
```

# LINUX host for testing : Setting username and password

The Linux host comes with iperf3 installed. The Linux host isn't accessible from the Internet so you will have to login through the edge and the leaf routers. To login to the host you can use one of the following methods
to access the hosts.

## Using pem file
Copy the pem file to the host and then ssh to the device using pem file.

## Using default username
If you have not provided a custom username and password ( see below ) to the terraform host module, then you can login to the host using "cloudeos" username and "cloudeos1234!" password.

## Using custom username and password
To setup a custom username and password, you need to set the following variables in the host terraform module.

```
username = "foo"
passwd = "$1$SaltSalt$YhgRYajLPrYevs14poKBQ0"
```

The above password is generated from plain-test password "secret" using a salt "SaltSalt" using the following command.

```
openssl passwd -1 -salt SaltSalt secret
```

Example

Use the generated output from the above command as the input to the `password` field in the host module. However, when you SSH
to the device, use the plain text string that you used above.

```
module "Region2Leaf1host1" {
                source = "../../../module/cloudeos/aws/host"
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
