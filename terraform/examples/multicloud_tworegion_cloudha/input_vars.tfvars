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
## only keypairs for regions mentioned in aws_regions block is needed
keypair_name = {
  us-west-1 : "your-keypair",
  us-east-1 : "your-keypair",
  us-east-2 : "your-keypair",
  us-west-2 : "your-keypair"
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

# Arista provides two license models BYOL, PAYG. Choose between the two
# by using cloudeos-router-byol/cloudeos-router-payg respectively.
cloudeos_image_offer = "cloudeos-router-byol"

# For BYOL, please specify the license path.
licenses = {
   #ipsec = "../../../userdata/eos_ipsec_license.json"
   #bandwidth = "../../../userdata/eos_bw_license.json"
}

## CloudEOS 4.27.3F Marketplace AMIs
eos_payg_amis = {
  us-east-2 : "ami-0c954bc79b1343460",
  us-east-1 : "ami-0b25960803617132c",
  us-west-1 : "ami-0e28925a64a092e52",
  us-west-2 : "ami-0b399219de92cd0e8",
  ap-east-1 : "ami-0459a44ce39d09619",
  ap-south-1 : "ami-0784bd854a29dee10",
  ap-northeast-2 : "ami-045597ce2c159615a",
  ap-southeast-1 : "ami-077f98b78ebdc71b7",
  ap-southeast-2 : "ami-033993422f56b3ecf",
  ap-northeast-1 : "ami-004fd8b20a2820008",
  ca-central-1 : "ami-0a8cd8929666d53e7",
  eu-central-1 : "ami-0eb23ac0cc8cec64a",
  eu-west-1 : "ami-0938471fc2f806a4f",
  eu-west-2 : "ami-045975d15d0b0cbf3",
  eu-west-3 : "ami-0aa94ed7881543696",
  eu-north-1 : "ami-054516419c033fe8e",
  me-south-1 : "ami-073cf45c8eaaf4bb2",
  sa-east-1 : "ami-0f19d35afe40fbfcd",
  us-gov-east-1 : "ami-059baafc9f9b3b183",
  us-gov-west-1 : "ami-0478a8669a7ba752a",
}

## CloudEOS 4.27.3F Marketplace AMIs
eos_byol_amis = {
  us-east-2 : "ami-0ddf4df251d8d7583"
  us-east-1 : "ami-01aaa6ae80c6f93d6"
  us-west-1 : "ami-0e0c05273b7debb48"
  us-west-2 : "ami-0d39124ce43eecc69"
  ap-east-1 : "ami-05f4a1d8f90eeafae"
  ap-south-1 : "ami-029f3ead20106a36d"
  ap-northeast-2 : "ami-0e1888c0406733a0f"
  ap-southeast-1 : "ami-0c208c79f69e820f9"
  ap-southeast-2 : "ami-07e4b55cc56b97474"
  ap-northeast-1 : "ami-0ab88e4174862e536"
  ca-central-1 : "ami-0b79e13b7cbf280a7"
  eu-central-1 : "ami-0cf7ddb71ba53729e"
  eu-west-1 : "ami-07bc425b5dfaeaa70"
  eu-west-2 : "ami-06ac1d164b3a30f3a"
  eu-west-3 : "ami-05d9b632ebd02562f"
  eu-north-1 : "ami-02066bcb990f5bfc0"
  me-south-1 : "ami-03525b64e8786e103"
  sa-east-1 : "ami-098b3aac6eaa43da0"
  us-gov-east-1 : "ami-0dfb8499e56921e16"
  us-gov-west-1 : "ami-0868cac5fc61075aa"
}

availability_zone = {
  us-west-1 : { zone1 : "us-west-1b", zone2 : "us-west-1c" },
  us-east-1 : { zone1 : "us-east-1b", zone2 : "us-east-1c" },
  us-east-2 : { zone1 : "us-east-2b", zone2 : "us-east-2c" },
  us-west-2 : { zone1 : "us-west-2b", zone2 : "us-west-2c" }
}

## Currently private AMIs. Contact Arista for access
host_amis = {
  us-west-1 : "ami-035dbbb5f679b91cd",
  us-east-1 : "ami-0b161e951484253ab",
  us-east-2 : "ami-083064f66d3878ff7",
  us-west-2 : "ami-0205b2cab53dacf39"
}

#azure cloudeos info
subnet_info = {
  azureRR1Subnet : {
    subnet_prefixes = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    subnet_names    = ["rr1Subnet0", "rr1Subnet1", "rr1Subnet2", "rr1Subnet3"]
  }
  edge1subnet : {
    subnet_prefixes = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
    subnet_names    = ["edge1Subnet0", "edge1Subnet1", "edge1Subnet2", "edge1Subnet3","rr1subnet0"]
  }
  leaf1subnet = {
    subnet_prefixes = ["10.2.0.0/24", "10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
    subnet_names    = ["leaf1Subnet0", "leaf1Subnet1", "leaf1Subnet2", "leaf1Subnet3"]
  }
  leaf2subnet = {
    subnet_prefixes = ["10.3.0.0/24", "10.3.1.0/24", "10.3.2.0/24", "10.033.0/24"]
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
    private_ips            = { "0" : ["10.1.4.101"] }
    route_name             = "azrr1Rt"
    routetable_name        = "azrr1RtTable"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
    cloudeos_image_version = "4.27.3"
    cloudeos_image_name    = "cloudeos-4_27_3-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    #Arista provides two license models BYOL, PAYG. To use BYOL use the following
    # values by uncommenting and commenting above.
    # When using BYOL, you need to provide paths to licenses.
    #cloudeos_image_version = "4.24.31"
    #cloudeos_image_name    = "cloudeos-4_24_3_1-byol"
    #cloudeos_image_offer   = "cloudeos-router-byol"
    #licenses = {
    #   ipsec = "../../../userdata/eos_ipsec_license.json"
    #   bandwidth = "../../../userdata/eos_bw_license.json"
    #}
  }
  edge1cloudeos1 : {
    publicip_name = "edge1cloudeos1Pip"
    intf_names    = ["edge1cloudeos1Intf0", "edge1cloudeos1Intf1"]
    interface_types = {
      "edge1cloudeos1Intf0" = "public"
      "edge1cloudeos1Intf1" = "internal"
    }
    disk_name              = "edge1cloudeos1disk"
    private_ips            = { "0" : ["10.1.0.101"], "1" : ["10.1.1.101"] }
    route_name             = "azedge1Rt"
    routetable_name        = "azedge1RtTable"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
    cloudeos_image_version = "4.27.3"
    cloudeos_image_name    = "cloudeos-4_27_3-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    #Arista provides two license models BYOL, PAYG. To use BYOL use the following
    # values by uncommenting and commenting above.
    # When using BYOL, you need to provide paths to licenses.
    #cloudeos_image_version = "4.24.31"
    #cloudeos_image_name    = "cloudeos-4_24_3_1-byol"
    #cloudeos_image_offer   = "cloudeos-router-byol"
    #licenses = {
    #   ipsec = "../../../userdata/eos_ipsec_license.json"
    #   bandwidth = "../../../userdata/eos_bw_license.json"
    #}
  }
  edge1cloudeos2 : {
    publicip_name = "edge1cloudeos2Pip"
    intf_names    = ["edge1cloudeos2Intf0", "edge1cloudeos2Intf1"]
    interface_types = {
      "edge1cloudeos2Intf0" = "public"
      "edge1cloudeos2Intf1" = "internal"
    }
    disk_name              = "edge1cloudeos2disk"
    private_ips            = { "0" : ["10.1.2.101"], "1" : ["10.1.3.101"] }
    route_name             = "azedge1cloudeos2Rt"
    routetable_name        = "azedge1cloudeos2RtTable"
    filename               = "../../../userdata/eos_ipsec_config.tpl"
    cloudeos_image_version = "4.27.3"
    cloudeos_image_name    = "cloudeos-4_27_3-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    #Arista provides two license models BYOL, PAYG. To use BYOL use the following
    # values by uncommenting and commenting above.
    # When using BYOL, you need to provide paths to licenses.
    #cloudeos_image_version = "4.24.31"
    #cloudeos_image_name    = "cloudeos-4_24_3_1-byol"
    #cloudeos_image_offer   = "cloudeos-router-byol"
    #licenses = {
    #   ipsec = "../../../userdata/eos_ipsec_license.json"
    #   bandwidth = "../../../userdata/eos_bw_license.json"
    #}

  }
  leaf1cloudeos1 = {
    cloudeos_image_version = "4.27.3"
    cloudeos_image_name    = "cloudeos-4_27_3-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    #Arista provides two license models BYOL, PAYG. To use BYOL use the following
    # values by uncommenting and commenting above.
    # When using BYOL, you need to provide paths to licenses.
    #cloudeos_image_version = "4.24.31"
    #cloudeos_image_name    = "cloudeos-4_24_3_1-byol"
    #cloudeos_image_offer   = "cloudeos-router-byol"
    #licenses = {
    #   ipsec = "../../../userdata/eos_ipsec_license.json"
    #   bandwidth = "../../../userdata/eos_bw_license.json"
    #}
    intf_names             = ["leaf1cloudeos1Intf0", "leaf1cloudeos1Intf1"]
    interface_types = {
      "leaf1cloudeos1Intf0" = "internal"
      "leaf1cloudeos1Intf1" = "private"
    }
    private_ips       = { "0" : ["10.2.0.101"], "1" : ["10.2.1.101"] }
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
    cloudeos_image_version = "4.27.3"
    cloudeos_image_name    = "cloudeos-4_27_3-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    #Arista provides two license models BYOL, PAYG. To use BYOL use the following
    # values by uncommenting and commenting above.
    # When using BYOL, you need to provide paths to licenses.
    #cloudeos_image_version = "4.24.31"
    #cloudeos_image_name    = "cloudeos-4_24_3_1-byol"
    #cloudeos_image_offer   = "cloudeos-router-byol"
    #licenses = {
    #   ipsec = "../../../userdata/eos_ipsec_license.json"
    #   bandwidth = "../../../userdata/eos_bw_license.json"
    #}
    intf_names             = ["leaf1cloudeos2Intf0", "leaf1cloudeos2Intf1"]
    interface_types = {
      "leaf1cloudeos2Intf0" = "internal"
      "leaf1cloudeos2Intf1" = "private"
    }
    private_ips       = { "0" : ["10.2.2.102"], "1" : ["10.2.3.102"] }
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
    private_ips            = { "0" : ["10.3.0.101"], "1" : ["10.3.1.101"] }
    disk_name              = "leaf2cloudeos1disk"
    storage_name           = "leaf2cloudeos1storage"
    route_name             = "leaf2Rt1"
    routetable_name        = "leaf2RtTable1"
    cloud_ha               = "leaf2"
    cloudeos_image_version = "4.27.3"
    cloudeos_image_name    = "cloudeos-4_27_3-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    #Arista provides two license models BYOL, PAYG. To use BYOL use the following
    # values by uncommenting and commenting above.
    # When using BYOL, you need to provide paths to licenses.
    #cloudeos_image_version = "4.24.31"
    #cloudeos_image_name    = "cloudeos-4_24_3_1-byol"
    #cloudeos_image_offer   = "cloudeos-router-byol"
    #licenses = {
    #   ipsec = "../../../userdata/eos_ipsec_license.json"
    #   bandwidth = "../../../userdata/eos_bw_license.json"
    #}
    filename               = "../../../userdata/eos_ipsec_config.tpl"
  }
  leaf2cloudeos2 = {
    intf_names = ["leaf2cloudeos2Intf0", "leaf2cloudeos2Intf1"]
    interface_types = {
      "leaf2cloudeos2Intf0" = "internal"
      "leaf2cloudeos2Intf1" = "private"
    }
    availability_zone      = [3]
    private_ips            = { "0" : ["10.3.2.102"], "1" : ["10.3.3.102"] }
    disk_name              = "leaf2cloudeos2disk"
    route_name             = "leaf2cloudeos2Rt1"
    routetable_name        = "leaf2cloudeos2RtTable1"
    cloud_ha               = "leaf2"
    cloudeos_image_version = "4.27.3"
    cloudeos_image_name    = "cloudeos-4_27_3-payg-free"
    cloudeos_image_offer   = "cloudeos-router-payg"
    #Arista provides two license models BYOL, PAYG. To use BYOL use the following
    # values by uncommenting and commenting above.
    # When using BYOL, you need to provide paths to licenses.
    #cloudeos_image_version = "4.24.31"
    #cloudeos_image_name    = "cloudeos-4_24_3_1-byol"
    #cloudeos_image_offer   = "cloudeos-router-byol"
    #licenses = {
    #   ipsec = "../../../userdata/eos_ipsec_license.json"
    #   bandwidth = "../../../userdata/eos_bw_license.json"
    #}
    filename               = "../../../userdata/eos_ipsec_config.tpl"
  }
}

ingress_allowlist = {
  edge_vpc = {
    ssh = ["0.0.0.0/0"]
    default = ["0.0.0.0/0"]
  }
  leaf_vpc = {
    default = ["0.0.0.0/0"]
  }
}
