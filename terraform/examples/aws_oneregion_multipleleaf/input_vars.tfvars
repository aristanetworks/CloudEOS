## PLEASE CUSTOMIZE file for your deployment
## Search "mandatory" for parameters that need to be customized before deployment
topology = "AWS_MULTILEAF"

## Get service_token from Arista Contact and replace empty string below
cvaas = {
  domain : "apiserver.arista.io",
  username : "nobody",
  server : "www.arista.io",
  service_token = "" #mandatory
}

## Enter keypairs that will be used to login to AWS instances
## If you don't have keypairs create them on AWS console for the following regions
keypair_name = {
  us-east-1 : "your-east-1-keypair", #mandatory
}

## AWS IAM profile name that allows CloudEOS router to modify AWS routing tables
## to setup Cloud HA. Check out "CloudEOS MultiCloud Deployment Guide" or
## https://www.arista.com/en/cg-veos-router/veos-router-cloud-configuration
## on how to setup the IAM role
aws_iam_instance_profile = "role_with_route_table_permissions" #mandatory

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

## Currently private AMIs. Contact Arista for access
eos_amis = {
  us-east-2 : "ami-0cfe8f89fa642a0ee",
  us-east-1 : "ami-0e7a2bc35081ad6b6",
  us-west-1 : "ami-049d033db1c1830c9",
  us-west-2 : "ami-0f127a20bd7bf04ad",
  ap-east-1 : "ami-017d724c052f7686a",
  ap-south-1 : "ami-05a760d906c21d570",
  ap-northeast-2 : "ami-0c6e65d050c183ec8",
  ap-southeast-1 : "ami-0a1c2c36bc79a2c30",
  ap-southeast-2 : "ami-06ad876529d4d3c32",
  ap-northeast-1 : "ami-0f0330501486d9357",
  ca-central-1 : "ami-0db44bc61ee02faee",
  eu-central-1 : "ami-0bdb781f58945929d",
  eu-west-1 : "ami-092858c965961d499",
  eu-west-2 : "ami-0f0c3008ce4e86348",
  eu-west-3 : "ami-0a65269a8e1927397",
  eu-north-1 : "ami-08a926964c8bdfe3a",
  me-south-1 : "ami-008ef35a062974dde",
  sa-east-1 : "ami-0164e87197dce5114",
  us-gov-east-1 : "ami-20ae4251",
  us-gov-west-1 : "ami-98a590f9",
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

