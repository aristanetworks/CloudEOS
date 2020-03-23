// PLEASE CUSTOMIZE file for your deployment
## Search "mandatory" for parameters that need to be customized before deployment
topology = "AWS_CLOS"

## Get service_token from Arista Contact and replace empty string below
cvaas = {
  domain : "apiserver.cv-play.corp.arista.io",
  username : "admin",
  server : "www.cv-play.corp.arista.io",
  service_token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJkaWQiOjExMywiZHNuIjoiYWRtaW4iLCJkc3QiOiJ1c2VyIiwiZW1haWwiOiJmYW55YW5nQGFyaXN0YS5jb20iLCJzaWQiOiIyYzBlNjM3OWVkNmZmZjI2ZjcxNDk5ZWQxZDgwMzIwODBiM2Q1N2M0ODI1NDY4NjhhM2Y0NjgyODg0M2NlYTEwLUs1eTRDMTFHang3UlNGTTFtcEdqMFE0Q2EydjktTVZUbWlhUThWS1oifQ.lcAkM52EmJjYQslKKHYGBPZrz5BBk37EBDuvZkcTp8brXpdjpY5ogxUfDPeyhEeqN0eMA8qg8HuGVOcpb93YCg"   #mandatory
}

## Enter keypairs that will be used to login to AWS instances
## If you don't have keypairs create them on AWS console for the following regions
keypair_name = {
  us-west-1 : "systest",  #mandatory
  us-east-1 : "systest",  #mandatory
  us-east-2 : "systest",  #mandatory
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
  region1 : "us-west-1",
  region2 : "us-east-1",
  region3 : "us-east-2"
}

## Currently private AMIs. Contact Arista for access
eos_amis = {
  us-west-1 : "ami-09559c40de4f4aae2",
  us-west-2 : "ami-0416b685220dc59e4",
  us-east-1 : "ami-05c30997c3e1a9c27",
  us-east-2 : "ami-05f1d5470ed6d86f2"
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

