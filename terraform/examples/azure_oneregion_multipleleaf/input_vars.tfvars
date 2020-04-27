## PLEASE CUSTOMIZE file for your deployment
## Search "mandatory" for parameters that need to be customized before deployment
topology = "AZ-MultiLeaf"

## Get service_token from Arista Contact and replace empty string below
cvaas = {
  domain : "apiserver.cv-staging.corp.arista.io",
  username : "admin",
  server : "www.cv-staging.corp.arista.io",
  //arista-systest-poc
  service_token : "" //mandatory
}

## Enter keypairs that will be used to login to AWS instances
## If you don't have keypairs create them on AWS console for the following regions

## Cutomization of the parameters below are *optional*

## CloudEdgeDev network requires three subnets for control plane
vtep_ip_cidr          = "100.0.0.0/16" // CIDR block for VTEP IPs
terminattr_ip_cidr    = "101.1.0.0/16" // Loopback IP range for CloudVision connectivity
dps_controlplane_cidr = "100.2.0.0/16" // CIDR block for VXLAN/Dps Control Plane IPs

## CloudVision container names - they need to be created on www.arista.io/cv
## before deployment. Steps to create containers on CloudVision are in
## "CloudEdgeDev MultiCloud Deployment Guide"
clos_cv_container = "CloudLeaf"
wan_cv_container  = "CloudEdge"

azure_regions = {
  region1 : "westus2",
}

## Currently private AMIs. Contact Arista for access

subnet_info = {
  edge1subnet : {
    subnet_prefixes = ["12.0.0.0/24", "12.0.1.0/24", "12.0.2.0/24", "12.0.3.0/24"]
    subnet_names    = ["edge1Subnet0", "edge1Subnet1", "edge1Subnet2", "edge1Subnet3"]
  }
  leaf1subnet = {
    subnet_prefixes = ["16.0.0.0/24", "16.0.1.0/24", "16.0.2.0/24", "16.0.3.0/24"]
    subnet_names    = ["leaf1Subnet0", "leaf1Subnet1", "leaf1Subnet2", "leaf1Subnet3"]
  }
  leaf2subnet = {
    subnet_prefixes = ["17.0.0.0/24", "17.0.1.0/24", "17.0.2.0/24", "17.0.3.0/24"]
    subnet_names    = ["leaf2Subnet0", "leaf2Subnet1", "leaf2Subnet2", "leaf2Subnet3"]
  }
}

cloudeos_info = {
  edge1veos1 : {
    publicip_name = "edge1veos1Pip"
    intf_names    = ["edge1veos1Intf0", "edge1veos1Intf1"]
    interface_types = {
      "edge1veos1Intf0" = "public"
      "edge1veos1Intf1" = "internal"
    }
    tags                   = { "Name" : "azEdge1veos1", "autoshutdown" : "no", "autostop" : "no" }
    disk_name              = "edge1veos1disk"
    storage_name           = "edge1veos1storage"
    private_ips            = { "0" : ["12.0.0.101"], "1" : ["12.0.1.101"] }
    route_name             = "azedge1Rt"
    routetable_name        = "azedge1RtTable"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
    cloudeos_image_version = "4.22.10"
    cloudeos_image_sku     = "eos-4_22_1fx"
  }
  rr1 = {
    publicip_name = "RR1Pip"
    intf_names    = ["RR1Intf0"]
    interface_types = {
      "RR1Intf0" = "public"
    }
    tags                   = { "Name" : "azedgeRR1", "autoshutdown" : "no", "autostop" : "no" }
    disk_name              = "adRR1disk"
    storage_name           = "rr1storage"
    private_ips            = { "0" : ["12.0.2.101"] }
    route_name             = "adedge1Rt"
    routetable_name        = "adedge1RtTable"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
    cloudeos_image_version = "4.22.10"
    cloudeos_image_sku     = "eos-4_22_1fx"
  }
  leaf1veos1 = {
    cloudeos_image_version = "4.22.10"
    cloudeos_image_sku     = "eos-4_22_1fx"
    intf_names             = ["leaf1veos1Intf0", "leaf1veos1Intf1"]
    interface_types = {
      "leaf1veos1Intf0" = "internal"
      "leaf1veos1Intf1" = "private"
    }
    private_ips       = { "0" : ["16.0.0.101"], "1" : ["16.0.1.101"] }
    tags              = { "Name" : "azleaf1veos1", "Cnps" : "Dev" }
    disk_name         = "leaf1veos1disk"
    storage_name      = "azleaf1veos1storage"
    route_name        = "leaf1Rt1"
    routetable_name   = "leaf1RtTable1"
    cloud_ha          = "leaf1"
    filename          = "../../../userdata/eos_ipsec_config.tpl"
    availability_zone = [2]

  }
  leaf1veos2 = {
    cloudeos_image_version = "4.22.10"
    cloudeos_image_sku     = "eos-4_22_1fx"
    intf_names             = ["leaf1veos2Intf0", "leaf1veos2Intf1"]
    interface_types = {
      "leaf1veos2Intf0" = "internal"
      "leaf1veos2Intf1" = "private"
    }
    private_ips       = { "0" : ["16.0.2.101"], "1" : ["16.0.3.101"] }
    tags              = { "Name" : "azleaf1veos2", "Cnps" : "Dev" }
    disk_name         = "leaf1veos2disk"
    storage_name      = "leaf1veos2storage"
    route_name        = "leaf1veos2Rt1"
    routetable_name   = "leaf1veos2RtTable1"
    cloud_ha          = "leaf1"
    filename          = "../../../userdata/eos_ipsec_config.tpl"
    availability_zone = [3]
  }
  leaf2veos1 = {
    intf_names = ["leaf2veos1Intf0", "leaf2veos1Intf1"]
    interface_types = {
      "leaf2veos1Intf0" = "internal"
      "leaf2veos1Intf1" = "private"
    }
    availability_zone      = [3]
    private_ips            = { "0" : ["17.0.0.101"], "1" : ["17.0.1.101"] }
    tags                   = { "Name" : "azleaf2veos1", "Cnps" : "Prod" }
    disk_name              = "leaf2veos1disk"
    storage_name           = "leaf2veos1storage"
    route_name             = "leaf2Rt1"
    routetable_name        = "leaf2RtTable1"
    cloud_ha               = "leaf2"
    cloudeos_image_version = "4.22.10"
    cloudeos_image_sku     = "eos-4_22_1fx"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
  }
}


