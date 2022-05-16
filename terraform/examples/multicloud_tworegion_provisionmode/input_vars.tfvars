// PLEASE CUSTOMIZE file for your deployment
## Search "mandatory" for parameters that need to be customized before deployment
topology = "topoMcp" #mandatory

## Get service_token from Arista Contact and replace empty string below
cvaas = {
  domain : "apiserver.arista.io",
  server : "www.arista.io",
  service_token : "" #mandatory
}

# Optional var set for a cloudeos_toplogy resource. Specifies that all the routers
# deployed shall only be onboarded to cvp (mapped to container followed by a reconcile).
# No config for the device is created or managed by cvp. Used to automate deployment
# of individual cloudeos instances, rather than deploy and manage a topology or fabric.
# When not specified (or left as empty), it signals deployment of a proper topology
deploy_mode = "provision"

## Enter keypairs that will be used to login to AWS instances
## If you don't have keypairs create them on AWS console for the following regions
## only keypairs for regions mentioned in aws_regions block is needed
keypair_name = {
  us-west-1 : "your-keypair",
  us-east-1 : "your-keypair",
  us-east-2 : "your-keypair",
  us-west-2 : "your-keypair",
}

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

## Azure credentials
creds = {
  client_id = ""
  subscription_id = ""
  tenant_id = ""
  client_secret = ""
}

## Username and password to be configured on CloudEOS instances
username = ""
password = ""


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

## Currently private AMIs. Contact Arista for access
eos_payg_amis = {
  us-east-2 : "ami-0f288d79d6c54df9c",
  us-east-1 : "ami-09294bb4c66837ba9",
  us-west-1 : "ami-023b9d398d45e5d1e",
  us-west-2 : "ami-01bda3983d6485129",
  ap-east-1 : "ami-02416a3369c25adf4",
  ap-south-1 : "ami-02ffb289a15e749f2",
  ap-northeast-2 : "ami-05afb6df71e95b345",
  ap-southeast-1 : "ami-0c022f2d5f4bf735c",
  ap-southeast-2 : "ami-05d16e7c75bcdbb5c",
  ap-northeast-1 : "ami-0aeab162992b5d86b",
  ca-central-1 : "ami-0c5a12e947d33b477",
  eu-central-1 : "ami-0d36a790c9f9184e8",
  eu-west-1 : "ami-06457449fb0c0a67f",
  eu-west-2 : "ami-05c3ead0a3bb34188",
  eu-west-3 : "ami-07f2f957eab49eb25",
  eu-north-1 : "ami-0da73caeb2cd3be33",
  me-south-1 : "ami-08f26941374da7c2d",
  sa-east-1 : "ami-01b10014647135f51",
  us-gov-east-1 : "ami-919f73e0",
  us-gov-west-1 : "ami-c2b285a3",
}

## Currently private AMIs. Contact Arista for access
eos_byol_amis = {
  us-east-2 : "ami-0b9b9dae8e26dce8f"
  us-east-1 : "ami-01b3f10b686914a0f"
  us-west-1 : "ami-05353b133e4111818"
  us-west-2 : "ami-078397da04136ce0f"
  ap-east-1 : "ami-06314509ee4a6dd42"
  ap-south-1 : "ami-0d7521074732ee85d"
  ap-northeast-2 : "ami-025b68427e6f84151"
  ap-southeast-1 : "ami-017164487a3707109"
  ap-southeast-2 : "ami-01d788bb97841f661"
  ap-northeast-1 : "ami-0101a293f881f3008"
  ca-central-1 : "ami-0b005ba02058dbe5e"
  eu-central-1 : "ami-0d635fb4a51b9fac0"
  eu-west-1 : "ami-0e2b3dcc4c78f3ba7"
  eu-west-2 : "ami-0e9c5d6d6f423060c"
  eu-west-3 : "ami-0d8e384e9578f0140"
  eu-north-1 : "ami-0f75e9e617b728d68"
  me-south-1 : "ami-073eb9385b115d112"
  sa-east-1 : "ami-0ad37d4011b233f51"
  us-gov-east-1 : "ami-0399dce0a2e0058d0"
  us-gov-west-1 : "ami-03eae1534b4343fe6"
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
  edge1subnet : {
    subnet_prefixes = ["10.0.0.0/24", "10.0.1.0/24"]
    subnet_names    = ["edge1Subnet0", "edge1Subnet1"]
  }
}

cloudeos_info = {
  edge1cloudeos1 : {
    publicip_name = "edge1cloudeos1Pip"
    intf_names    = ["edge1cloudeos1Intf0", "edge1cloudeos1Intf1"]
    interface_types = {
      "edge1cloudeos1Intf0" = "public"
      "edge1cloudeos1Intf1" = "internal"
    }
    disk_name              = "edge1cloudeos1disk"
    private_ips            = { "0" : ["10.0.0.101"], "1" : ["10.0.1.101"] }
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
