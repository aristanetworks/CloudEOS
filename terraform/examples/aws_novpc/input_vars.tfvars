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
keypair_name = {
  us-west-1 : "your-west-1-keypair", #mandatory
  us-east-1 : "your-east-1-keypair", #mandatory
  us-east-2 : "your-east-2-keypair", #mandatory
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
  us-east-2 : { zone1 : "us-east-2b", zone2 : "us-east-2c" }
}

## Currently private AMIs. Contact Arista for access
host_amis = {
  us-west-1 : "ami-035dbbb5f679b91cd",
  us-east-1 : "ami-0b161e951484253ab",
  us-east-2 : "ami-083064f66d3878ff7"
}

vpc_info = {
  edge_vpc = {
    role     = "CloudEdge"
    vpc_cidr = "100.0.0.0/16"
    vpc_id   = "vpc-0cab572639b8d6c8f"
    tags = {
      Name = "aristaQHTest"
    }
    sg_id  = "sg-0f81411dc64e29167"
    igw_id = "igw-0ddd34235cf694aa6"
  }
  rr_vpc = {
    role     = "CloudEdge"
    vpc_cidr = "10.0.0.0/16"
    vpc_id   = "vpc-061b7b0cc3726df18"
    tags = {
      Name = "aristaQHRR"
    }
    sg_id  = "sg-07cbf735703c27fae"
    igw_id = "igw-06c9b69101f76eccc"
  }
  leaf1_vpc = {
    role     = "CloudLeaf"
    vpc_cidr = "101.0.0.0/16"
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
    subnet_cidr       = ["100.0.1.0/24", "100.0.2.0/24", "100.0.3.0/24", "100.0.4.0/24"]
    availability_zone = ["us-west-1b", "us-west-1b", "us-west-1c", "us-west-1c"]
  }
  rr_subnet = {
    subnet_names      = ["aristaQHRRSubnet1", "aristaQHRRSubnet2"]
    subnet_id         = ["subnet-0050f59bd747a1c19", "subnet-01b590529519cff85"]
    subnet_cidr       = ["10.0.0.0/24", "10.0.1.0/24"]
    availability_zone = ["us-west-1b", "us-west-1b"]
  }
  leaf1_subnet = {
    subnet_names      = ["aristaQHLeafSubnet1", "aristaQHLeafSubnet2", "aristaQHLeafSubnet3", "aristaQHLeafSubnet4"]
    subnet_id         = ["subnet-0cb41b2c3950c3896", "subnet-0a71763d419aacfa8", "subnet-01872e66c237a662d", "subnet-042b5ac0c6349affe"]
    subnet_cidr       = ["101.0.0.0/24", "101.0.1.0/24", "101.0.2.0/24", "101.0.3.0/24"]
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
      "0" : ["10.0.0.101"]
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
      "0" : ["10.0.1.101"]
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
      "0" : ["100.0.1.101"]
      "1" : ["100.0.2.101"]
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
      "0" : ["100.0.3.101"]
      "1" : ["100.0.4.101"]
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
      "0" : ["101.0.0.101"]
      "1" : ["101.0.1.101"]
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
      "0" : ["101.0.2.101"]
      "1" : ["101.0.3.101"]
    }
    tags = {
      "Name" = "aristaQHTest-CloudEosLeaf2"
      "Cnps" = "dev"
    }
  }
}
