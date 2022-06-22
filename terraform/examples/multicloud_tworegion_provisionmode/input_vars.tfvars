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
