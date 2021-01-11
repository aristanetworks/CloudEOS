// PLEASE CUSTOMIZE file for your deployment
## Search "mandatory" for parameters that need to be customized before deployment
topology = "topoMc" #mandatory

## Get service_token from Arista Contact and replace empty string below
cvaas = {
  domain : "apiserver.arista.io",
  server : "www.arista.io",
  service_token : "" #mandatory
}

## Enter keypairs that will be used to login to AWS instances
## If you don't have keypairs create them on AWS console for the following regions
keypair_name = {
  us-west-1 : "your-keypair", #mandatory
  us-east-1 : "your-keypair", #mandatory
  us-east-2 : "your-keypair", #mandatory
}

## AWS IAM profile name that allows CloudEdge router to modify AWS routing tables
## to setup Cloud HA. Check out "CloudEdge MultiCloud Deployment Guide" or
## https://www.arista.com/en/cg-veos-router/veos-router-cloud-configuration
## on how to setup the IAM role
aws_iam_instance_profile = "aws-iam-role" #mandatory

## Cutomization of the parameters below are *optional*

## CloudEdge network requires three subnets for control plane
vtep_ip_cidr          = "172.16.0.0/24" // CIDR block for VTEP IPs
terminattr_ip_cidr    = "172.16.1.0/24" // Loopback IP range for CloudVision connectivity
dps_controlplane_cidr = "172.16.2.0/24" // CIDR block for VXLAN/Dps Control Plane IPs

## CloudVision container names - they need to be created on www.arista.io/cv
## before deployment. Steps to create containers on CloudVision are in
## "CloudEdge MultiCloud Deployment Guide"
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

azure_regions = {
  region1 : "westus2",
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

#azure cloudeos info
subnet_info = {
  azureRR1Subnet : {
    subnet_prefixes = ["11.0.0.0/24", "11.0.1.0/24", "11.0.2.0/24", "11.0.3.0/24"]
    subnet_names    = ["rr1Subnet0", "rr1Subnet1", "rr1Subnet2", "rr1Subnet3"]
  }
  edge1subnet : {
    subnet_prefixes = ["12.0.0.0/24", "12.0.1.0/24", "12.0.2.0/24", "12.0.3.0/24", "12.0.4.0/24"]
    subnet_names    = ["edge1Subnet0", "edge1Subnet1", "edge1Subnet2", "edge1Subnet3","rr1subnet0"]
  }
  leaf1subnet = {
    subnet_prefixes = ["18.0.0.0/24", "18.0.1.0/24", "18.0.2.0/24", "18.0.3.0/24"]
    subnet_names    = ["leaf1Subnet0", "leaf1Subnet1", "leaf1Subnet2", "leaf1Subnet3"]
  }
  leaf2subnet = {
    subnet_prefixes = ["19.0.0.0/24", "19.0.1.0/24", "19.0.2.0/24", "19.0.3.0/24"]
    subnet_names    = ["leaf2Subnet0", "leaf2Subnet1", "leaf2Subnet2", "leaf2Subnet3"]
  }
}

cloudeos_info = {
  rr1cloudeos1 : {
    publicip_name = "rr1cloudeos1Pip"
    intf_names    = ["rr1cloudeos1Intf0"]
    interface_types = {
      "rr1cloudeos1Intf0" = "public"
    }
    disk_name              = "rr1cloudeos1disk"
    storage_name           = "rr1cloudeos1disk"
    private_ips            = { "0" : ["12.0.4.101"] }
    route_name             = "azrr1Rt"
    routetable_name        = "azrr1RtTable"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
    cloudeos_image_version = "4.24.01"
    cloudeos_image_name    = "cloudeos-4_24_0-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
  }
  edge1cloudeos1 : {
    publicip_name = "edge1cloudeos1Pip"
    intf_names    = ["edge1cloudeos1Intf0", "edge1cloudeos1Intf1"]
    interface_types = {
      "edge1cloudeos1Intf0" = "public"
      "edge1cloudeos1Intf1" = "internal"
    }
    disk_name              = "edge1cloudeos1disk"
    private_ips            = { "0" : ["12.0.0.101"], "1" : ["12.0.1.101"] }
    route_name             = "azedge1Rt"
    routetable_name        = "azedge1RtTable"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
    cloudeos_image_version = "4.24.01"
    cloudeos_image_name    = "cloudeos-4_24_0-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
  }
  edge1cloudeos2 : {
    publicip_name = "edge1cloudeos2Pip"
    intf_names    = ["edge1cloudeos2Intf0", "edge1cloudeos2Intf1"]
    interface_types = {
      "edge1cloudeos2Intf0" = "public"
      "edge1cloudeos2Intf1" = "internal"
    }
    disk_name              = "edge1cloudeos2disk"
    private_ips            = { "0" : ["12.0.2.101"], "1" : ["12.0.3.101"] }
    route_name             = "azedge1cloudeos2Rt"
    routetable_name        = "azedge1cloudeos2RtTable"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
    cloudeos_image_version = "4.24.01"
    cloudeos_image_name    = "cloudeos-4_24_0-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"

  }
  leaf1cloudeos1 = {
    cloudeos_image_version = "4.24.01"
    cloudeos_image_name    = "cloudeos-4_24_0-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    intf_names             = ["leaf1cloudeos1Intf0", "leaf1cloudeos1Intf1"]
    interface_types = {
      "leaf1cloudeos1Intf0" = "internal"
      "leaf1cloudeos1Intf1" = "private"
    }
    private_ips       = { "0" : ["18.0.0.101"], "1" : ["18.0.1.101"] }
    tags              = { "Name" : "azleaf1cloudeos1", "Cnps" : "dev" }
    disk_name         = "leaf1cloudeos1disk"
    storage_name      = "azleaf1cloudeos1storage"
    route_name        = "leaf1Rt1"
    routetable_name   = "leaf1RtTable1"
    cloud_ha          = "leaf1"
    filename          = "../../../userdata/eos_ipsec_config.tpl"
    availability_zone = [2]

  }
  leaf1cloudeos2 = {
    cloudeos_image_version = "4.24.01"
    cloudeos_image_name    = "cloudeos-4_24_0-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    intf_names             = ["leaf1cloudeos2Intf0", "leaf1cloudeos2Intf1"]
    interface_types = {
      "leaf1cloudeos2Intf0" = "internal"
      "leaf1cloudeos2Intf1" = "private"
    }
    private_ips       = { "0" : ["18.0.2.102"], "1" : ["18.0.3.102"] }
    tags              = { "Name" : "azleaf1cloudeos2", "Cnps" : "dev" }
    disk_name         = "leaf1cloudeos2disk"
    route_name        = "leaf1cloudeos2Rt1"
    routetable_name   = "leaf1cloudeos2RtTable1"
    cloud_ha          = "leaf1"
    filename          = "../../../userdata/eos_ipsec_config.tpl"
    availability_zone = [3]
  }
  leaf2cloudeos1 = {
    intf_names = ["leaf2cloudeos1Intf0", "leaf2cloudeos1Intf1"]
    interface_types = {
      "leaf2cloudeos1Intf0" = "internal"
      "leaf2cloudeos1Intf1" = "private"
    }
    availability_zone      = [2]
    private_ips            = { "0" : ["19.0.0.101"], "1" : ["19.0.1.101"] }
    disk_name              = "leaf2cloudeos1disk"
    storage_name           = "leaf2cloudeos1storage"
    route_name             = "leaf2Rt1"
    routetable_name        = "leaf2RtTable1"
    cloud_ha               = "leaf2"
    cloudeos_image_version = "4.24.01"
    cloudeos_image_name    = "cloudeos-4_24_0-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
  }
  leaf2cloudeos2 = {
    intf_names = ["leaf2cloudeos2Intf0", "leaf2cloudeos2Intf1"]
    interface_types = {
      "leaf2cloudeos2Intf0" = "internal"
      "leaf2cloudeos2Intf1" = "private"
    }
    availability_zone      = [3]
    private_ips            = { "0" : ["19.0.2.102"], "1" : ["19.0.3.102"] }
    disk_name              = "leaf2cloudeos2disk"
    route_name             = "leaf2cloudeos2Rt1"
    routetable_name        = "leaf2cloudeos2RtTable1"
    cloud_ha               = "leaf2"
    cloudeos_image_version = "4.24.01"
    cloudeos_image_name    = "cloudeos-4_24_0-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
  }
}
