#!/bin/bash

rm -r .terraform/

echo Get terraform provider binaries
cd examples/aws_tworegion_clos/topology
terraform init

if [ ! -e ".terraform/modules/modules.json" ]; then
   echo Failed to get modules.json! Please rerun the setup script.
   rm -r .terraform/
   exit
fi 

if [ ! ls .terraform/plugins/darwin_amd64/terraform-provider-aws* 1> /dev/null 2>&1 ] && [ ! ls .terraform/plugins/linux_amd64/terraform-provider-aws* 1> /dev/null 2>&1 ]; then
   echo Failed to get aws plugin! Please rerun the setup script.
   rm -r .terraform/
   exit
fi

if [ ! ls .terraform/plugins/darwin_amd64/terraform-provider-template* 1> /dev/null 2>&1 ] && [ ! ls .terraform/plugins/linux_amd64/terraform-provider-template* 1> /dev/null 2>&1 ]; then
   echo Failed to get template plugin! Please rerun the setup script.
   rm -r .terraform/
   exit
fi

mv .terraform/ ../../../.terraform
cd ../../../

echo Download and extract provider-arista binaries
wget http://dist/release/CloudEOS-Terraform/SE-EFT1/terraform-arista-plugin_latest.tar.gz -O - | tar -xz

if [ ! ls .terraform/plugins/darwin_amd64/terraform-provider-arista* 1> /dev/null 2>&1 ] || [ ! ls .terraform/linux_amd64/terraform-provider-arista* 1> /dev/null 2>&1 ]; then
   echo Failed to get arista plugin! Please rerun the setup script
   rm -r .terraform/
   exit
fi

echo Setup Successful!
