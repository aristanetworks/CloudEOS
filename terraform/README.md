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

cd CloudEOS/terraform
wget http://dist/release/CloudEOS-Terraform/SE-EFT1/terraform-plugins.tar.gz -O - | tar -xz

## Go the respective example folders and follow instructions.

### Topology Examples - 
#### Two AWS Regions with leaf routers
This topology lets you create a multi-region setup with 2 Edge VPCs in different regions and
leaf VPCs connected to those Edge VPCs. Leaf VPCs also create host VMs with iperf installed.
These hosts are connected to the Leaf CloudEOS instances and can be used to test end-end connectivity.
and can be used
Please follow examples/aws_tworegion_clos/aws_tworegion_clos.md

#### One AWS Region with multiple leaf routers
This topology has a single Edge VPC with multiple Leaf VPCs(4) connected to it. Every VPC has 2 CloudEOS
instances each. And the Leaf VPCs have hosts behind it with iperf installed.

Please follow examples/aws_oneregion_multileaf/aws_oneregion_multileaf.md

#### Two AWS Regions with no leaf routers
This topology lets you create a multi-region setup with 2 Edge VPCs in 2 different regions. There
are no Leaf VPCs created in this topology and can help test WAN connectivity across regions.Note, that 
there isn't a host VM added here.

Please follow examples/aws_tworegion_noleaf/aws_tworegion_noleaf.md

