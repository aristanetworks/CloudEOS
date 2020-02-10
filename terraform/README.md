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

cd CloudEOS/terraform
Download plugins
wget http://dist/release/CloudEOS-Terraform/SE-EFT1/terraform-plugins.tar.gz
tar -xvf terraform-plugins.tar.gz

## Go the respective example folders and follow instructions.

### Topology - Two AWS Regions with leaf routers
Please follow examples/aws_tworegion_clos/aws_tworegion_clos.md