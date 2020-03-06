// Please uncomment the following lines and modify them for your deployment
// update CloudEOS SE MultiCloud POC CIDR Reservations https://docs.google.com/spreadsheets/d/1HkANmxzbowQlqqQHdI2e8qcZ1LqY7QDaTnr-BofdhLg/edit?usp=sharing
// Follow [CloudEOS SE MultiCloud POC Guide](https://docs.google.com/document/d/1DW9niGGAMtc0LGWt2OBlaGZQBTWDlTYgygnEli2JNoo/edit#) and create containers on CVAAS. They can be containers with no configlets attached to them or you can have any configlet that contains configuration that you want to push to the router when it comes up

// All the lines below need to the customized and uncommented before you run terraform
topology = "adhipQHTest"

vtep_ip_cidr            = "5.0.0.0/16"  // CIDR block for VTEP IPs
terminattr_ip_cidr      = "5.1.0.0/16"  // Loopback IP range for terminattr source
dps_controlplane_cidr   = "5.2.0.0/16"  // CIDR block for Dps Control Plane IPs

keypair_name = { us-west-1 : "systest",
                 us-west-2 : "systest",
                  us-east-1 : "systest",
                  us-east-2 : "systest" }

clos_cv_container = "CloudLeafDev"
wan_cv_container  = "CloudEdgeDev"

// All of the above lines need to the customized and uncommented before you run terraform

// for play replace staging to play below
cvaas = { domain : "apiserver.cv-staging.corp.arista.io",
          username : "admin",
          server : "www.cv-staging.corp.arista.io",
          // service token for cv_play c-clouddeploy tenant
          // service_token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJkaWQiOjExMywiZHNuIjoiYWRtaW4iLCJkc3QiOiJ1c2VyIiwiZW1haWwiOiJmYW55YW5nQGFyaXN0YS5jb20iLCJzaWQiOiIyYzBlNjM3OWVkNmZmZjI2ZjcxNDk5ZWQxZDgwMzIwODBiM2Q1N2M0ODI1NDY4NjhhM2Y0NjgyODg0M2NlYTEwLUs1eTRDMTFHang3UlNGTTFtcEdqMFE0Q2EydjktTVZUbWlhUThWS1oifQ.lcAkM52EmJjYQslKKHYGBPZrz5BBk37EBDuvZkcTp8brXpdjpY5ogxUfDPeyhEeqN0eMA8qg8HuGVOcpb93YCg"
          // service token for cv_play arista-systest-poc tenant
          // service_token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJkaWQiOjE3MCwiZHNuIjoiYWRtaW4iLCJkc3QiOiJ1c2VyIiwiZW1haWwiOiJkYWlzeUBhcmlzdGEuY29tIiwic2lkIjoiZGM4YjE4NmJhOTljYTcwZWFlNzgzMTg5ZjgwNmIxMDBiYWJiZWQ2MDhhMGI1ZDJlZmVjOGJhNTVkNGIyZjQzMS1HVWFZby1tVkRUWnpTS0E1c3FHeGJnVFVUYk9JSU5PTDYzbkNRZmUwIn0.Dnilu_-A9cBvEHEuYl_L7mdxtpGd2amRE16wZx9ra0guUT6CToNfWQFqkcypRkKLXYEsEhZKHcdN_WcoL64RQg"
          // service token for cv_staging c-arista tenant
          service_token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJkaWQiOjgsImRzbiI6ImFkbWluIiwiZHN0IjoidXNlciIsImVtYWlsIjoieGd1b0BhcmlzdGEuY29tIiwic2lkIjoiOWY2MjA4ZDI4YWMxY2U5YjRiZjI3ZjgzYTMzNjljNjZhZDFlZjRiMDVhMzViMjEzNjUwMzJmMzZiNGNmZDMzNi1RaVNfeU1XRkVZVEtBTHVmMW9aY0o2YTJNS3lwQjFXR0pLdmJIRTFQIn0.9t_h7lhs7CpACwKYLBiSKbdHPid7oXe9SNe3Ai5g9hhRtZNlN0cR2lHCv6fvjhk1LPBcYQfRgP5ya0v8NyUM-g"
        }

instance_type = { rr:"c5.xlarge",
                  edge:"c5.xlarge",
                  leaf:"c5.xlarge" }

aws_regions = { region1 : "us-west-1",
                region2 : "us-east-1",
                region3 : "us-east-2" }

eos_amis = { us-west-1 : "ami-017900c328c2edfbe",
             us-west-2 : "ami-0c6aba6a8b862f7ac",
             us-east-1 : "ami-0ee27fb355f900646",
             us-east-2 : "ami-0f3dd5c4e5e81f9f4" }

availability_zone = { us-west-1 : {zone1 : "us-west-1b", zone2 : "us-west-1c"},
                      us-east-1 : {zone1 : "us-east-1b", zone2 : "us-east-1c"},
                      us-east-2 : {zone1 : "us-east-2b", zone2 : "us-east-2c"} }

host_amis = { us-west-1 : "ami-035dbbb5f679b91cd",
              us-east-1 : "ami-0b161e951484253ab",
              us-east-2 : "ami-083064f66d3878ff7" }

vpc_info = {
  edge_vpc = {
    role = "CloudEdge"
    vpc_cidr = "100.0.0.0/16"
    vpc_id = "vpc-0cab572639b8d6c8f"
    tags = {
        Name = "adhipQHTest"
    }
    sg_id = "sg-0f81411dc64e29167"
    igw_id = "igw-0ddd34235cf694aa6"
  }
  rr_vpc = {
    role = "CloudEdge"
    vpc_cidr = "10.0.0.0/16"
    vpc_id = "vpc-061b7b0cc3726df18"
    tags = {
        Name = "adhipQHRR"
    }
    sg_id = "sg-07cbf735703c27fae"
    igw_id = "igw-06c9b69101f76eccc"
  }
  leaf1_vpc = {
    role = "CloudLeaf"
    vpc_cidr = "101.0.0.0/16"
    vpc_id = "vpc-0f99749769af4455a"
    tags = {
        Name = "adhipQHLeaf1"
        Cnps = "dev"
    }
  }
}

subnet_info = {
  edge_subnet = {
    subnet_names = ["adhipQHTestEdgeSubnet1", "adhipQHTestEdgeSubnet2", "adhipQHEdgeSubnet3", "adhipQHEdgeSubnet4"],
    subnet_id = ["subnet-0071a6b1fcd21858e", "subnet-0fdf79012d81c354a", "subnet-0520b752154bb9d85", "subnet-0f263f745b5ab9597"],
    subnet_cidr = ["100.0.1.0/24", "100.0.2.0/24","100.0.3.0/24","100.0.4.0/24"]
    availability_zone = ["us-west-1b", "us-west-1b","us-west-1c","us-west-1c"]
  }
  rr_subnet = {
    subnet_names = ["adhipQHRRSubnet1", "adhipQHRRSubnet2"]
    subnet_id = ["subnet-0050f59bd747a1c19","subnet-01b590529519cff85"]
    subnet_cidr = ["10.0.0.0/24", "10.0.1.0/24"]
    availability_zone = ["us-west-1b", "us-west-1b"]
  }
  leaf1_subnet = {
    subnet_names = ["adhipQHLeafSubnet1", "adhipQHLeafSubnet2", "adhipQHLeafSubnet3", "adhipQHLeafSubnet4"]
    subnet_id = ["subnet-0cb41b2c3950c3896", "subnet-0a71763d419aacfa8","subnet-01872e66c237a662d","subnet-042b5ac0c6349affe"]
    subnet_cidr = ["101.0.0.0/24", "101.0.1.0/24","101.0.2.0/24", "101.0.3.0/24"]
    availability_zone = ["us-west-1b", "us-west-1b", "us-west-1b","us-west-1b"]
  }
}

router_info = {
  rr1 = {
    role = "CloudEdge"
    intf_names = ["adhipQHTest-RRIntf0"]
    interface_types = {
      "adhipQHTest-RRIntf0" = "public"
    }
    private_ips = {
      "0": ["10.0.0.101"]
    }
    tags = {
      "Name" = "adhipQHTest-CloudEosRR1"
    }
  }
  rr2 = {
    role = "CloudEdge"
    intf_names = ["adhipQHTest-RR2Intf0"]
    interface_types = {
      "adhipQHTest-RR2Intf0" = "public"
    }
    private_ips = {
      "0": ["10.0.1.101"]
    }
    tags = {
      "Name" = "adhipQHTest-CloudEosRR2"
    }
  }
  edge1 = {
    role = "CloudEdge"
    intf_names = ["adhipQHTest-EdgeIntf0","adhipQHTest-EdgeIntf1"]
    interface_types = {
    "adhipQHTest-EdgeIntf0" = "public"
    "adhipQHTest-EdgeIntf1" = "internal"
    }
    private_ips = {
      "0": ["100.0.1.101"]
      "1": ["100.0.2.101"]
    }
    tags = {
      "Name" = "adhipQHTest-CloudEosEdge1"
    }
  }
  edge2 = {
    role = "CloudEdge"
    intf_names = ["adhipQHTest-Edge2Intf0","adhipQHTest-Edge2Intf1"]
    interface_types = {
      "adhipQHTest-Edge2Intf0" = "public"
      "adhipQHTest-Edge2Intf1" = "internal"
    }
    private_ips = {
      "0": ["100.0.3.101"]
      "1": ["100.0.4.101"]
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
      "0": ["101.0.0.101"]
      "1": ["101.0.1.101"]
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
      "0": ["101.0.2.101"]
      "1": ["101.0.3.101"]
    }
    tags = {
      "Name" = "adhipQHTest-CloudEosLeaf2"
      "Cnps" = "Dev"
    }
  }
}
