// PLEASE CUSTOMIZE file for your deployment
## Search "mandatory" for parameters that need to be customized before deployment
topology = "AWS_NOVPC"

## Get service_token from Arista Contact and replace empty string below
cvaas = {
  domain : "apiserver.arista.io",
  username : "nobody",
  server : "www.arista.io",
  service_token = ""   #mandatory
}

## Enter keypairs that will be used to login to AWS instances
## If you don't have keypairs create them on AWS console for the following regions
keypair_name = {
  us-west-1 : "your-west-1-keypair",  #mandatory
  us-east-1 : "your-east-1-keypair",  #mandatory
  us-east-2 : "your-east-2-keypair",  #mandatory
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

## Currently private AMIs. Contact Arista for access
eos_amis = {
  us-west-1 : "ami-09559c40de4f4aae2",
  us-west-2 : "ami-0416b685220dc59e4",
  us-east-1 : "ami-05c30997c3e1a9c27",
  us-east-2 : "ami-05f1d5470ed6d86f2"
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
      Name = "adhipQHTest"
    }
    sg_id  = "sg-0f81411dc64e29167"
    igw_id = "igw-0ddd34235cf694aa6"
  }
  rr_vpc = {
    role     = "CloudEdge"
    vpc_cidr = "10.0.0.0/16"
    vpc_id   = "vpc-061b7b0cc3726df18"
    tags = {
      Name = "adhipQHRR"
    }
    sg_id  = "sg-07cbf735703c27fae"
    igw_id = "igw-06c9b69101f76eccc"
  }
  leaf1_vpc = {
    role     = "CloudLeaf"
    vpc_cidr = "101.0.0.0/16"
    vpc_id   = "vpc-0f99749769af4455a"
    tags = {
      Name = "adhipQHLeaf1"
      Cnps = "dev"
    }
  }
}

subnet_info = {
  edge_subnet = {
    subnet_names      = ["adhipQHTestEdgeSubnet1", "adhipQHTestEdgeSubnet2", "adhipQHEdgeSubnet3", "adhipQHEdgeSubnet4"],
    subnet_id         = ["subnet-0071a6b1fcd21858e", "subnet-0fdf79012d81c354a", "subnet-0520b752154bb9d85", "subnet-0f263f745b5ab9597"],
    subnet_cidr       = ["100.0.1.0/24", "100.0.2.0/24", "100.0.3.0/24", "100.0.4.0/24"]
    availability_zone = ["us-west-1b", "us-west-1b", "us-west-1c", "us-west-1c"]
  }
  rr_subnet = {
    subnet_names      = ["adhipQHRRSubnet1", "adhipQHRRSubnet2"]
    subnet_id         = ["subnet-0050f59bd747a1c19", "subnet-01b590529519cff85"]
    subnet_cidr       = ["10.0.0.0/24", "10.0.1.0/24"]
    availability_zone = ["us-west-1b", "us-west-1b"]
  }
  leaf1_subnet = {
    subnet_names      = ["adhipQHLeafSubnet1", "adhipQHLeafSubnet2", "adhipQHLeafSubnet3", "adhipQHLeafSubnet4"]
    subnet_id         = ["subnet-0cb41b2c3950c3896", "subnet-0a71763d419aacfa8", "subnet-01872e66c237a662d", "subnet-042b5ac0c6349affe"]
    subnet_cidr       = ["101.0.0.0/24", "101.0.1.0/24", "101.0.2.0/24", "101.0.3.0/24"]
    availability_zone = ["us-west-1b", "us-west-1b", "us-west-1b", "us-west-1b"]
  }
}

router_info = {
  rr1 = {
    role       = "CloudEdge"
    intf_names = ["adhipQHTest-RRIntf0"]
    interface_types = {
      "adhipQHTest-RRIntf0" = "public"
    }
    private_ips = {
      "0" : ["10.0.0.101"]
    }
    tags = {
      "Name" = "adhipQHTest-CloudEosRR1"
    }
  }
  rr2 = {
    role       = "CloudEdge"
    intf_names = ["adhipQHTest-RR2Intf0"]
    interface_types = {
      "adhipQHTest-RR2Intf0" = "public"
    }
    private_ips = {
      "0" : ["10.0.1.101"]
    }
    tags = {
      "Name" = "adhipQHTest-CloudEosRR2"
    }
  }
  edge1 = {
    role       = "CloudEdge"
    intf_names = ["adhipQHTest-EdgeIntf0", "adhipQHTest-EdgeIntf1"]
    interface_types = {
      "adhipQHTest-EdgeIntf0" = "public"
      "adhipQHTest-EdgeIntf1" = "internal"
    }
    private_ips = {
      "0" : ["100.0.1.101"]
      "1" : ["100.0.2.101"]
    }
    tags = {
      "Name" = "adhipQHTest-CloudEosEdge1"
    }
  }
  edge2 = {
    role       = "CloudEdge"
    intf_names = ["adhipQHTest-Edge2Intf0", "adhipQHTest-Edge2Intf1"]
    interface_types = {
      "adhipQHTest-Edge2Intf0" = "public"
      "adhipQHTest-Edge2Intf1" = "internal"
    }
    private_ips = {
      "0" : ["100.0.3.101"]
      "1" : ["100.0.4.101"]
    }
    tags = {
      "Name" = "adhipQHTest-CloudEosEdge2"
    }
  }
  leaf11 = {
    intf_names = ["adhipQHTest-Leaf1Intf0", "adhipQHTest-Leaf1Intf1"]
    interface_types = {
      "adhipQHTest-Leaf1Intf0" = "internal"
      "adhipQHTest-Leaf1Intf1" = "private"
    }
    private_ips = {
      "0" : ["101.0.0.101"]
      "1" : ["101.0.1.101"]
    }
    tags = {
      "Name" = "adhipQHTest-CloudEosLeaf1"
      "Cnps" = "Dev"
    }
  }
  leaf12 = {
    intf_names = ["adhipQHTest-Leaf2Intf0", "adhipQHTest-Leaf2Intf1"]
    interface_types = {
      "adhipQHTest-Leaf2Intf0" = "internal"
      "adhipQHTest-Leaf2Intf1" = "private"
    }
    private_ips = {
      "0" : ["101.0.2.101"]
      "1" : ["101.0.3.101"]
    }
    tags = {
      "Name" = "adhipQHTest-CloudEosLeaf2"
      "Cnps" = "Dev"
    }
  }
}
