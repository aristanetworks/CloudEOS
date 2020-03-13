# Introduction 

This folder has Terraform scripts to launch and configure CloudEOS in various public clouds.

Note that following the instructions will cause instances to be launched in your public cloud
and incur expenses. 

# Prerequisites

1) Public cloud account credentials eg AWS Access key and secret
2) Terraform installed on your laptop/server
3) Security webtoken for CloudVision
4) Create one or more Containers in CVaaS which will be used to provision the routers

# Arista CloudVision Terraform provider 

Since the provider isn't an offical Terraform provider yet, the terraform plugin folder has to be downloaded.

# Steps

## Installing Terraform

Follow the steps at https://learn.hashicorp.com/terraform/getting-started/install.html 

## Get AWS and Arista providers

'''
cd CloudEOS/terraform
./setup.sh
'''

## Setup AWS Credentials

AWS Credentials through Vault Please follow through this [doc](https://docs.google.com/document/d/1BDiVeMnygyjO3suVvEWMm0nJPWdDxlTEpRswfkgqjO4/edit "AWS Credentials through Vault") and make sure you can get AWS access key and secrets. Set the credentials setup the following env variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY by using export commands in bash. 

Run all terraform commands with the above environment variables setup

# Topology Examples : Go the respective example folders and follow instructions. 

The directories containes examples. While you will only have to modify the input_vars.tfvars file to get the topologies to work, feel free to modify the code to create your own topologies to suit the customer’s requirement. 

## Two AWS Regions with leaf routers
This topology lets you create a multi-region setup with 2 Edge VPCs in different regions and
leaf VPCs connected to those Edge VPCs. Leaf VPCs also create host VMs with iperf installed.
These hosts are connected to the Leaf CloudEOS instances and can be used to test end-end connectivity.
and can be used
Please follow examples/aws_tworegion_clos/aws_tworegion_clos.md

## One AWS Region with multiple leaf routers
This topology has a single Edge VPC with multiple Leaf VPCs(4) connected to it. Every VPC has 2 CloudEOS
instances each. And the Leaf VPCs have hosts behind it with iperf installed.

Please follow examples/aws_oneregion_multileaf/aws_oneregion_multileaf.md

## Two AWS Regions with no leaf routers
This topology lets you create a multi-region setup with 2 Edge VPCs in 2 different regions. There
are no Leaf VPCs created in this topology and can help test WAN connectivity across regions.Note, that 
there isn't a host VM added here.

Please follow examples/aws_tworegion_noleaf/aws_tworegion_noleaf.md

# Setting username and password for host

To login to host you can use various steps listed below:

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
