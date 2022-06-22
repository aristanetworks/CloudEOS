// PLEASE CUSTOMIZE file for your deployment
## Search "mandatory" for parameters that need to be customized before deployment
topology = "AWS_NOVPC"

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
  us-west-1 : "your-west-1-keypair",
  us-east-1 : "your-east-1-keypair",
  us-east-2 : "your-east-2-keypair",
  us-west-2 : "your-west-2-keypair",
}

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
  us-east-2 : { zone1 : "us-east-2b", zone2 : "us-east-2c" }
  us-west-2 : { zone1 : "us-west-2b", zone2 : "us-west-2c" }
}

## Currently private AMIs. Contact Arista for access
host_amis = {
  us-west-1 : "ami-035dbbb5f679b91cd",
  us-east-1 : "ami-0b161e951484253ab",
  us-east-2 : "ami-083064f66d3878ff7",
  us-west-2 : "ami-0205b2cab53dacf39"
}

vpc_info = {
  edge_vpc = {
    role     = "CloudEdge"
    vpc_cidr = "10.0.0.0/16"
    vpc_id   = "vpc-0cab572639b8d6c8f"
    tags = {
      Name = "aristaQHTest"
    }
    sg_id  = "sg-0f81411dc64e29167"
    igw_id = "igw-0ddd34235cf694aa6"
  }
  rr_vpc = {
    role     = "CloudEdge"
    vpc_cidr = "10.1.0.0/16"
    vpc_id   = "vpc-061b7b0cc3726df18"
    tags = {
      Name = "aristaQHRR"
    }
    sg_id  = "sg-07cbf735703c27fae"
    igw_id = "igw-06c9b69101f76eccc"
  }
  leaf1_vpc = {
    role     = "CloudLeaf"
    vpc_cidr = "10.2.0.0/16"
    vpc_id   = "vpc-0f99749769af4455a"
    tags = {
      Name = "aristaQHLeaf1"
      Cnps = "dev"
    }
    sg_default_id = "sg-0933b8999b9d730ca"
  }
}

subnet_info = {
  edge_subnet = {
    subnet_names      = ["aristaQHTestEdgeSubnet1", "aristaQHTestEdgeSubnet2", "aristaQHEdgeSubnet3", "aristaQHEdgeSubnet4"],
    subnet_id         = ["subnet-0071a6b1fcd21858e", "subnet-0fdf79012d81c354a", "subnet-0520b752154bb9d85", "subnet-0f263f745b5ab9597"],
    subnet_cidr       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
    availability_zone = ["us-west-1b", "us-west-1b", "us-west-1c", "us-west-1c"]
  }
  rr_subnet = {
    subnet_names      = ["aristaQHRRSubnet1", "aristaQHRRSubnet2"]
    subnet_id         = ["subnet-0050f59bd747a1c19", "subnet-01b590529519cff85"]
    subnet_cidr       = ["10.1.0.0/24", "10.1.1.0/24"]
    availability_zone = ["us-west-1b", "us-west-1b"]
  }
  leaf1_subnet = {
    subnet_names      = ["aristaQHLeafSubnet1", "aristaQHLeafSubnet2", "aristaQHLeafSubnet3", "aristaQHLeafSubnet4"]
    subnet_id         = ["subnet-0cb41b2c3950c3896", "subnet-0a71763d419aacfa8", "subnet-01872e66c237a662d", "subnet-042b5ac0c6349affe"]
    subnet_cidr       = ["10.2.0.0/24", "10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
    availability_zone = ["us-west-1b", "us-west-1b", "us-west-1b", "us-west-1b"]
  }
}

router_info = {
  rr1 = {
    role       = "CloudEdge"
    intf_names = ["aristaQHTest-RRIntf0"]
    interface_types = {
      "aristaQHTest-RRIntf0" = "public"
    }
    private_ips = {
      "0" : ["10.1.0.101"]
    }
    tags = {
      "Name" = "aristaQHTest-CloudEosRR1"
    }
  }
  rr2 = {
    role       = "CloudEdge"
    intf_names = ["aristaQHTest-RR2Intf0"]
    interface_types = {
      "aristaQHTest-RR2Intf0" = "public"
    }
    private_ips = {
      "0" : ["10.1.1.101"]
    }
    tags = {
      "Name" = "aristaQHTest-CloudEosRR2"
    }
  }
  edge1 = {
    role       = "CloudEdge"
    intf_names = ["aristaQHTest-EdgeIntf0", "aristaQHTest-EdgeIntf1"]
    interface_types = {
      "aristaQHTest-EdgeIntf0" = "public"
      "aristaQHTest-EdgeIntf1" = "internal"
    }
    private_ips = {
      "0" : ["10.0.1.101"]
      "1" : ["10.0.2.101"]
    }
    tags = {
      "Name" = "aristaQHTest-CloudEosEdge1"
    }
  }
  edge2 = {
    role       = "CloudEdge"
    intf_names = ["aristaQHTest-Edge2Intf0", "aristaQHTest-Edge2Intf1"]
    interface_types = {
      "aristaQHTest-Edge2Intf0" = "public"
      "aristaQHTest-Edge2Intf1" = "internal"
    }
    private_ips = {
      "0" : ["10.0.3.101"]
      "1" : ["10.0.4.101"]
    }
    tags = {
      "Name" = "aristaQHTest-CloudEosEdge2"
    }
  }
  leaf11 = {
    intf_names = ["aristaQHTest-Leaf1Intf0", "aristaQHTest-Leaf1Intf1"]
    interface_types = {
      "aristaQHTest-Leaf1Intf0" = "internal"
      "aristaQHTest-Leaf1Intf1" = "private"
    }
    private_ips = {
      "0" : ["10.2.0.101"]
      "1" : ["10.2.1.101"]
    }
    tags = {
      "Name" = "aristaQHTest-CloudEosLeaf1"
      "Cnps" = "dev"
    }
  }
  leaf12 = {
    intf_names = ["aristaQHTest-Leaf2Intf0", "aristaQHTest-Leaf2Intf1"]
    interface_types = {
      "aristaQHTest-Leaf2Intf0" = "internal"
      "aristaQHTest-Leaf2Intf1" = "private"
    }
    private_ips = {
      "0" : ["10.2.2.101"]
      "1" : ["10.2.3.101"]
    }
    tags = {
      "Name" = "aristaQHTest-CloudEosLeaf2"
      "Cnps" = "dev"
    }
  }
}
