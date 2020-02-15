# Introduction 

This folder has Terraform scripts to launch and configure CloudEOS in various public clouds.

Note that following the instructions will cause instances to be launched in your public cloud
and incur expenses. 

# Prerequisites

1) Public cloud account credentials eg AWS Access key and secret
2) Terraform installed on your laptop/server
3) Security webtoken for CloudVision

# Arista CloudVision Terraform provider 

Since the provider isn't an offical Terraform provider yet, the terraform plugin folder has to be downloaded.

# Steps

## Installing Terraform

Follow the steps at https://learn.hashicorp.com/terraform/getting-started/install.html 

## Get AWS and Arista providers

'''
cd CloudEOS/terraform
wget http://dist/release/CloudEOS-Terraform/SE-EFT1/terraform-plugins.tar.gz -O - | tar -xz
'''

## Setup AWS Credentials

AWS Credentials through Vault Please follow through this [doc](https://docs.google.com/document/d/1BDiVeMnygyjO3suVvEWMm0nJPWdDxlTEpRswfkgqjO4/edit "AWS Credentials through Vault") and make sure you can get AWS access key and secrets. Set the credentials setup the following env variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY by using export commands in bash. 

Optionally you if you want to write them to the aws CLI native path
echo "[default]" > ~/.aws/credentials
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials

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

