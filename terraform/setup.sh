#!/bin/bash

rm -r .terraform/

echo Get terraform provider binaries
cd examples/aws_tworegion_clos/topology
terraform init

mv .terraform/ ../../../.terraform
cd ../../../

echo Download and extract provider-arista binaries
wget http://dist/release/CloudEOS-Terraform/SE-EFT1/terraform-arista-plugin_latest.tar.gz -O - | tar -xz
