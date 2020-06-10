#!/bin/bash
## Run this setup only if you want to upgrade the default Arista Terraform plugin
## that is already installed

rm -r .terraform/ > /dev/null 2>&1

usage="$(basename "$0") [-h] [-d URL] [-f path] Install terraform plugins

where:
    -h  show this help text
    -d  URL to download Arista Terraform plugins
    -f  Filesystem path to Arista Terraform plugins (default is ./terraform-cloudeos-plugin_latest.tar.gz)"

## specify a URL or path to terraform-cloudeos-plugin_latest.tar.gz
while getopts hd:f: option
do
case "${option}"
in
d) URL=${OPTARG};;
f) TARFILE=${OPTARG};;
h) echo "$usage"
   exit
   ;;
esac
done

echo Get terraform provider binaries
cd test/setup
terraform init

if ! ls .terraform/plugins/darwin_amd64/terraform-provider-aws* 1> /dev/null 2>&1 && ! ls .terraform/plugins/linux_amd64/terraform-provider-aws* 1> /dev/null 2>&1; then
   echo Failed to get aws plugin! Please rerun the setup script.
   rm -r .terraform/
   exit 1
fi

if ! ls .terraform/plugins/darwin_amd64/terraform-provider-template* 1> /dev/null 2>&1 && ! ls .terraform/plugins/linux_amd64/terraform-provider-template* 1> /dev/null 2>&1; then
   echo Failed to get template plugin! Please rerun the setup script.
   rm -r .terraform/
   exit 1
fi

mv .terraform/ ../../.terraform
cd ../../

if [ -n "$URL" ]; then
   echo Download and extract provider-cloudeos binaries from $URL
   if command -v curl > /dev/null 2>&1; then
        curl $URL | tar -xz
   else
        wget $URL -O - | tar -xz
   fi
else
    if [ -z ${TARFILE+x} ]; then
        TARFILE="./terraform-cloudeos-plugin_latest.tar.gz"
    fi
    if [ ! -e $TARFILE ]; then
        echo
        echo ERROR Arista Terraform plugin file $TARFILE not found
        rm -r .terraform/
        exit 1
    fi
    echo Extract provider-cloudeos binaries from $TARFILE
    tar -xf $TARFILE
fi

if ! ls .terraform/plugins/darwin_amd64/terraform-provider-cloudeos* 1> /dev/null 2>&1 || ! ls .terraform/plugins/linux_amd64/terraform-provider-cloudeos* 1> /dev/null 2>&1; then
   echo Failed to get arista plugin! Please rerun the setup script
   rm -r .terraform/
   exit 1
fi

echo Setup Successful!
