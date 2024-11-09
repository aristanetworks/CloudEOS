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


## Azure credentials
creds = {
  client_id = ""
  subscription_id = ""
  tenant_id = ""
  client_secret = ""
}

## AWS IAM profile name that allows CloudEdge router to modify AWS routing tables
## to setup Cloud HA. Check out "CloudEdge MultiCloud Deployment Guide" or
## https://www.arista.com/en/cg-veos-router/veos-router-cloud-configuration
## on how to setup the IAM role
aws_iam_instance_profile = "aws-iam-role" #mandatory

## Cutomization of the parameters below are *optional*

## CloudEdge network requires three subnets for control plane
vtep_ip_cidr          = "172.16.90.0/24" // CIDR block for VTEP IPs
terminattr_ip_cidr    = "172.16.91.0/24" // Loopback IP range for CloudVision connectivity
dps_controlplane_cidr = "172.16.92.0/24" // CIDR block for VXLAN/Dps Control Plane IPs

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
cloudeos_image_offer = "cloudeos-router-payg"

# For BYOL, please specify the license path.
licenses = {
   #ipsec = "../../../userdata/eos_ipsec_license.json"
   #bandwidth = "../../../userdata/eos_bw_license.json"
}


## Username and password to be configured on CloudEOS instances
username = ""
password = ""

#4.32.2F
eos_byol_amis = {
  us-east-1 :  "ami-00e002ea057dad85f",
  us-east-2 :  "ami-02198a5e1897bfe9f",
  us-west-1 : "ami-079c80dced21882e8",
  us-west-2 :  "ami-0f3c278664b7a2ae5",
  ap-east-1 :  "ami-030ca8289bf427b8f",
  ap-south-1 : "ami-0a70f215bcd0069ff",
  ap-northeast-3 : "ami-0d440e601666f94cf",
  ap-northeast-2 : "ami-0cfb8fad45a692c39",
  ap-southeast-1 : "ami-055a15dd3ed3c9dff",
  ap-southeast-2 : "ami-0a72cd88c15cb4422",
  ap-northeast-1 : "ami-0eecb3df648c1307c",
  ca-central-1 : "ami-0a0b6e202f82756a0",
  eu-central-1 : "ami-07023b5773b9807da",
  eu-west-1 : "ami-0185fd1a4b983ed97",
  eu-west-2 : "ami-0505f26dfe3c5c862",
  eu-south-1 : "ami-00e90490622c5464f",
  eu-west-3 : "ami-0d4ed3923983e41c2",
  eu-south-2 : "ami-00c54c7ea894f5a48",
  eu-north-1 : "ami-0e9f4ccb454393079",
  eu-central-2 : "ami-05c1b5f0be5d92f23",
  me-south-1 : "ami-01263852e3711520b",
  me-central-1 : "ami-0dc37da67dc592225",
  sa-east-1 : "ami-05687500ccd1f1334",
}

#4.32.2F
eos_payg_amis = {
  us-east-1 : "ami-0f3d624fef6d9acf3",
  us-east-2 : "ami-001dac282d90deaaa",
  us-west-1 : "ami-0b131511987194ace",
  us-west-2 : "ami-0b2989292c330a0af",
  ap-east-1 : "ami-071c3d7ca196981e0",
  ap-south-1 : "ami-0315558bda3f10cef",
  ap-northeast-3 : "ami-0be04d22aed09dd52",
  ap-northeast-2 : "ami-012a98a75f9f3d9eb",
  ap-southeast-1 : "ami-04165700d5ac3da08",
  ap-southeast-2 : "ami-0dde6d111eef69382",
  ap-northeast-1 : "ami-0b40670ebd6dc7ade",
  ca-central-1 : "ami-0479f7b95426bdbca",
  eu-central-1 : "ami-04518ae07abab0c08",
  eu-west-1 : "ami-099ab2d265195c5ea",
  eu-west-2 : "ami-089aabdbbf13d3656",
  eu-south-1 : "ami-07c8e3dbbd2c67614",
  eu-west-3 : "ami-03fd8859c1a793af0",
  eu-south-2 : "ami-055385c1a272d38f4",
  eu-north-1 : "ami-01ac3e18e928555b2",
  eu-central-2 : "ami-0598f8c30257b3063",
  me-south-1 : "ami-0c43173a945430682",
  me-central-1 : "ami-03f6cb9a80897a9c7",
  sa-east-1 : "ami-0639c2b478a11f80c",
}

availability_zone = {
  us-west-1 : { zone1 : "us-west-1b", zone2 : "us-west-1c" },
  us-east-1 : { zone1 : "us-east-1b", zone2 : "us-east-1c" },
  us-east-2 : { zone1 : "us-east-2b", zone2 : "us-east-2c" },
  us-west-2 : { zone1 : "us-west-2b", zone2 : "us-west-2c" }
}

## Currently private AMIs. Contact Arista for access
host_amis = {
  us-east-1 : "ami-0fe630eb857a6ec83",
  us-west-1 : "ami-014b33341e3a1178e",
  us-east-2 : "ami-0d77c9d87c7e619f9",
  us-west-2 : "ami-0f7197c592205b389"
}


## VPCs in AWS and VNET in Azure refer to the same concept.
## Consider the VPCs here as VNET.
vpc_info = {
    azure_edge1_vpc = {
      vpc_cidr = "10.1.0.0/16"
      subnet_cidr = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
      interface_ips = ["10.1.0.101", "10.1.1.101", "10.1.2.101", "10.1.3.101"]
    }
    azure_leaf1_vpc = {
      vpc_cidr = "10.2.0.0/16"
      subnet_cidr = ["10.2.0.0/24", "10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
      interface_ips = ["10.2.0.101", "10.2.1.101", "10.2.2.101", "10.2.3.101", "10.2.1.10", "10.2.3.10"]
    }
    azure_leaf2_vpc = {
      vpc_cidr = "10.3.0.0/16"
      subnet_cidr = ["10.3.0.0/24", "10.3.1.0/24", "10.3.2.0/24", "10.3.3.0/24"]
      interface_ips = ["10.3.0.101", "10.3.1.101", "10.3.2.101", "10.3.3.101", "10.3.1.10", "10.3.3.10"]
    }
    rr_vpc = {
      vpc_cidr = "10.4.0.0/16"
      subnet_cidr = ["10.4.0.0/24"]
      interface_ips = ["10.4.0.101"]
    }
    region2_edge_vpc = {
      vpc_cidr = "10.5.0.0/16"
      subnet_cidr = ["10.5.0.0/24", "10.5.1.0/24", "10.5.2.0/24", "10.5.3.0/24"]
      interface_ips = ["10.5.0.101", "10.5.1.101", "10.5.2.101", "10.5.3.101"]
    }
    region3_edge_vpc = {
      vpc_cidr = "10.6.0.0/16"
      subnet_cidr = ["10.6.0.0/24", "10.6.1.0/24", "10.6.2.0/24", "10.6.3.0/24"]
      interface_ips = ["10.6.0.101", "10.6.1.101", "10.6.2.101", "10.6.3.101"]
    }
    region2_leaf1_vpc = {
      vpc_cidr = "10.7.0.0/16"
      subnet_cidr = ["10.7.0.0/24", "10.7.1.0/24", "10.7.2.0/24", "10.7.3.0/24"]
      interface_ips = ["10.7.0.101", "10.7.1.101", "10.7.2.101", "10.7.3.101", "10.7.1.102", "10.7.3.102"]
    }
    region2_leaf2_vpc = {
      vpc_cidr = "10.8.0.0/16"
      subnet_cidr = ["10.8.0.0/24", "10.8.1.0/24", "10.8.2.0/24", "10.8.3.0/24"]
      interface_ips = ["10.8.0.101", "10.8.1.101", "10.8.2.101", "10.8.3.101", "10.8.1.102", "10.8.3.102"]
    }
     region3_leaf1_vpc = {
      vpc_cidr = "10.9.0.0/16"
      subnet_cidr = ["10.9.0.0/24", "10.9.1.0/24", "10.9.2.0/24", "10.9.3.0/24"]
      interface_ips = ["10.9.0.101", "10.9.1.101", "10.9.2.101", "10.9.3.101", "10.9.1.102", "10.9.3.102"]
    }
     region3_leaf2_vpc = {
      vpc_cidr = "10.10.0.0/16"
      subnet_cidr = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
      interface_ips = ["10.10.0.101", "10.10.1.101", "10.10.2.101", "10.10.3.101", "10.10.1.102", "10.10.3.102"]
    }
}

cloudeos_info = {
  /*
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
  */
  edge1cloudeos1 : {
    publicip_name = "edge1cloudeos1Pip"
    intf_names    = ["edge1cloudeos1Intf0", "edge1cloudeos1Intf1"]
    interface_types = {
      "edge1cloudeos1Intf0" = "public"
      "edge1cloudeos1Intf1" = "internal"
    }
    disk_name              = "edge1cloudeos1disk"
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

// This is the list of source cidrs from which inbound traffic (of different protocols) should be
// allowed to the CloudEOS instance via security groups - allowSSHIKE for edges and leafSG for leaves
// The default - 0.0.0.0/0, allows all source IPs
ingress_allowlist = {
  edge_vpc = {
    ssh = ["0.0.0.0/0"]         // Source IPs allowed for SSH
    default = ["0.0.0.0/0"]     // Source IPs allowed for ICMP, DPS (UDP over port 4793), BFD (UDP
                                // over port 3784) and IPSEC (UDP over port 4500 + 500)
  }
  leaf_vpc = {
    default = ["0.0.0.0/0"]     // Source IPs for all protocols in the topology
  }
}
