## PLEASE CUSTOMIZE file for your deployment
## Search "mandatory" for parameters that need to be customized before deployment
topology = "AwsTgw"

## Get service_token from Arista Contact and replace empty string below
cvaas = {
  domain : "apiserver.arista.io",
  server : "www.arista.io",
  service_token : "" #mandatory
}

## Enter keypairs that will be used to login to AWS instances
## If you don't have keypairs create them on AWS console for the following regions
keypair_name = {
  us-east-1 : "your-east-1-keypair", #mandatory
}

## Cutomization of the parameters below are *optional*

## CloudEOS network requires three subnets for control plane
vtep_ip_cidr          = "172.16.0.0/24" // CIDR block for VTEP IPs
terminattr_ip_cidr    = "172.16.1.0/24" // Loopback IP range for CloudVision connectivity
dps_controlplane_cidr = "172.16.2.0/24" // CIDR block for VXLAN/Dps Control Plane IPs

## CloudVision container names - they need to be created on www.arista.io/cv
## before deployment. Steps to create containers on CloudVision are in
## "CloudEOS MultiCloud Deployment Guide"
clos_cv_container = "CloudEOS"
wan_cv_container  = "CloudEOS"

instance_type = {
  rr : "c5.xlarge",
  edge : "c5.xlarge",
  leaf : "c5.xlarge"
}

aws_regions = {
  region2 : "us-east-1",
}

eos_amis = {
  us-east-2 : "ami-040bdeb60b08e1d49",
  us-east-1 : "ami-036a5d80077d33df2",
  us-west-1 : "ami-03fad7766e0b75f6f",
  us-west-2 : "ami-0b79ee29825b3572d",
  ap-east-1 : "ami-04c20631185dbf232",
  ap-south-1 : "ami-0695f8ce878519fd8",
  ap-northeast-2 : "ami-0b5b16761c092ea73",
  ap-southeast-1 : "ami-0b963dd70c4dbf1c9",
  ap-southeast-2 : "ami-0181c2d94c63daf1d",
  ap-northeast-1 : "ami-004fd8b20a2820008",
  ca-central-1 : "ami-094db4a5eda8f5a41",
  eu-central-1 : "ami-090a73c4f72292ff1",
  eu-west-1 : "ami-06400e4914b6139b3",
  eu-west-2 : "ami-0d549eba7f4bddd04",
  eu-west-3 : "ami-0bab55b4126ba77c0",
  eu-north-1 : "ami-0323ca3f0e3c7c3fa",
  me-south-1 : "ami-0f418921435870c30",
  sa-east-1 : "ami-042e8b81d03e84285",
  us-gov-east-1 : "ami-05906714d9e7a6520",
  us-gov-west-1 : "ami-080be51bffd37f337",
}

availability_zone = {
  us-west-1 : { zone1 : "us-west-1b", zone2 : "us-west-1c" },
  us-east-1 : { zone1 : "us-east-1b", zone2 : "us-east-1c" },
  us-east-2 : { zone1 : "us-east-2b", zone2 : "us-east-2c" }
}

## Currently private AMIs. Contact Arista for access
host_amis = {
  us-west-1 : "ami-035dbbb5f679b91cd",
  us-east-1 : "ami-0b161e951484253ab",
  us-east-2 : "ami-083064f66d3878ff7"
}

tgwLeafHosts = {
  leaf3 = {
	region = "us-east-1",
	subnetids = ["subnet-02973b860c334efcb", "subnet-0eb8f54b319fc2bd5"]
  }
  leaf4 = {
	region = "us-east-1",
        subnetids = ["subnet-0f1b9b3802a84650a", "subnet-0c71774d6b4ee7b9a"]
  }
}
