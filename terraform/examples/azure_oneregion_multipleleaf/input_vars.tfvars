## PLEASE CUSTOMIZE file for your deployment
## Search "mandatory" for parameters that need to be customized before deployment
topology = "Azure" #mandatory

## Get service_token from Arista Contact and replace empty string below
cvaas = {
  domain : "apiserver.arista.io",
  server : "www.arista.io",
  service_token : "" #mandatory
}

## CloudEdge network requires three subnets for control plane.
vtep_ip_cidr          = "172.16.0.0/24" // CIDR block for VTEP IPs
terminattr_ip_cidr    = "172.16.1.0/24" // Loopback IP range for CloudVision connectivity
dps_controlplane_cidr = "172.16.2.0/24" // CIDR block for VXLAN/Dps Control Plane IPs

## CloudVision container names - they need to be created on www.arista.io/cv
## before deployment. Steps to create containers on CloudVision are in
## "CloudEdgedev MultiCloud Deployment Guide"
clos_cv_container = "CloudLeaf"
wan_cv_container  = "CloudEdge"

azure_regions = {
  region1 : "westus2",
}

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
    disk_name              = "edge1veos1disk"
    private_ips            = { "0" : ["12.0.0.101"], "1" : ["12.0.1.101"] }
    route_name             = "azedge1Rt"
    routetable_name        = "azedge1RtTable"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
    cloudeos_image_version = "4.24.01"
    cloudeos_image_name    = "cloudeos-4_24_0-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
  }
  edge1veos2 : {
    publicip_name = "edge1veos2Pip"
    intf_names    = ["edge1veos2Intf0", "edge1veos2Intf1"]
    interface_types = {
      "edge1veos2Intf0" = "public"
      "edge1veos2Intf1" = "internal"
    }
    disk_name              = "edge1veos2disk"
    private_ips            = { "0" : ["12.0.2.101"], "1" : ["12.0.3.101"] }
    route_name             = "azedge1veos2Rt"
    routetable_name        = "azedge1veos2RtTable"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
    cloudeos_image_version = "4.24.01"
    cloudeos_image_name    = "cloudeos-4_24_0-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"

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
    private_ips            = { "0" : ["12.0.4.101"] }
    route_name             = "adedge1Rt"
    routetable_name        = "adedge1RtTable"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
    cloudeos_image_version = "4.24.01"
    cloudeos_image_name    = "cloudeos-4_24_0-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
  }
  leaf1veos1 = {
    cloudeos_image_version = "4.24.01"
    cloudeos_image_name    = "cloudeos-4_24_0-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    intf_names             = ["leaf1veos1Intf0", "leaf1veos1Intf1"]
    interface_types = {
      "leaf1veos1Intf0" = "internal"
      "leaf1veos1Intf1" = "private"
    }
    private_ips       = { "0" : ["16.0.0.101"], "1" : ["16.0.1.101"] }
    tags              = { "Name" : "azleaf1veos1", "Cnps" : "dev" }
    disk_name         = "leaf1veos1disk"
    storage_name      = "azleaf1veos1storage"
    route_name        = "leaf1Rt1"
    routetable_name   = "leaf1RtTable1"
    cloud_ha          = "leaf1"
    filename          = "../../../userdata/eos_ipsec_config.tpl"
    availability_zone = [2]

  }
  leaf1veos2 = {
    cloudeos_image_version = "4.24.01"
    cloudeos_image_name    = "cloudeos-4_24_0-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    intf_names             = ["leaf1veos2Intf0", "leaf1veos2Intf1"]
    interface_types = {
      "leaf1veos2Intf0" = "internal"
      "leaf1veos2Intf1" = "private"
    }
    private_ips       = { "0" : ["16.0.2.101"], "1" : ["16.0.3.101"] }
    tags              = { "Name" : "azleaf1veos2", "Cnps" : "dev" }
    disk_name         = "leaf1veos2disk"
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
    availability_zone      = [2]
    private_ips            = { "0" : ["17.0.0.101"], "1" : ["17.0.1.101"] }
    disk_name              = "leaf2veos1disk"
    storage_name           = "leaf2veos1storage"
    route_name             = "leaf2Rt1"
    routetable_name        = "leaf2RtTable1"
    cloud_ha               = "leaf2"
    cloudeos_image_version = "4.24.01"
    cloudeos_image_name    = "cloudeos-4_24_0-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
  }
  leaf2veos2 = {
    intf_names = ["leaf2veos2Intf0", "leaf2veos2Intf1"]
    interface_types = {
      "leaf2veos2Intf0" = "internal"
      "leaf2veos2Intf1" = "private"
    }
    availability_zone      = [3]
    private_ips            = { "0" : ["17.0.2.101"], "1" : ["17.0.3.101"] }
    disk_name              = "leaf2veos2disk"
    route_name             = "leaf2veos2Rt1"
    routetable_name        = "leaf2veos2RtTable1"
    cloud_ha               = "leaf2"
    cloudeos_image_version = "4.24.01"
    cloudeos_image_name    = "cloudeos-4_24_0-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
  }
}


