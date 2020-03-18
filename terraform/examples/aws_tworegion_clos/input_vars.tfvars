// PLEASE CUSTOMIZE file for your deployment
topology = "AWS_CLOS"

## CloudEOS network requires three subnets for control plane
vtep_ip_cidr          = "172.16.0.0/24" // CIDR block for VTEP IPs
terminattr_ip_cidr    = "172.16.1.0/24" // Loopback IP range for CloudVision connectivity
dps_controlplane_cidr = "172.16.2.0/24" // CIDR block for VXLAN/Dps Control Plane IPs

keypair_name = {
  us-west-1 : "systest",
  us-west-2 : "systest",
  us-east-1 : "systest",
  us-east-2 : "systest"
}

clos_cv_container = "CloudEOS"
wan_cv_container  = "CloudEOS"

## Get service_token from Arista Contact
cvaas = {
  domain : "apiserver.arista.io",
  username : "admin",
  server : "www.arista.io/",
  service_token = ""
}

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

eos_amis = {
  us-west-1 : "ami-017900c328c2edfbe",
  us-west-2 : "ami-0c6aba6a8b862f7ac",
  us-east-1 : "ami-0ee27fb355f900646",
  us-east-2 : "ami-0f3dd5c4e5e81f9f4"
}

availability_zone = {
  us-west-1 : { zone1 : "us-west-1b", zone2 : "us-west-1c" },
  us-east-1 : { zone1 : "us-east-1b", zone2 : "us-east-1c" },
  us-east-2 : { zone1 : "us-east-2b", zone2 : "us-east-2c" }
}

host_amis = {
  us-west-1 : "ami-035dbbb5f679b91cd",
  us-east-1 : "ami-0b161e951484253ab",
  us-east-2 : "ami-083064f66d3878ff7"
}
