topology = "CloudEOSJenkinsTest"

vtep_ip_cidr            = "5.0.0.0/16"  // CIDR block for VTEP IPs 
terminattr_ip_cidr      = "6.0.0.0/16"  // Loopback IP range for terminattr source
dps_controlplane_cidr   = "7.0.0.0/16"  // CIDR block for Dps Control Plane IPs 

keypair_name = { us-west-1 : "systest",
                 us-west-2 : "systest",
                 us-east-1 : "systest",
                 us-east-2 : "systest" }

clos_cv_container = "CloudLeaf"
wan_cv_container  = "CloudEdge"


cvaas = { domain : "apiserver.cv-play.corp.arista.io", 
          username : "admin", 
          server : "www.cv-play.corp.arista.io", 
          // service token for cv_play c-clouddeploy tenant
          service_token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJkaWQiOjExMywiZHNuIjoiYWRtaW4iLCJkc3QiOiJ1c2VyIiwiZW1haWwiOiJmYW55YW5nQGFyaXN0YS5jb20iLCJzaWQiOiIyYzBlNjM3OWVkNmZmZjI2ZjcxNDk5ZWQxZDgwMzIwODBiM2Q1N2M0ODI1NDY4NjhhM2Y0NjgyODg0M2NlYTEwLUs1eTRDMTFHang3UlNGTTFtcEdqMFE0Q2EydjktTVZUbWlhUThWS1oifQ.lcAkM52EmJjYQslKKHYGBPZrz5BBk37EBDuvZkcTp8brXpdjpY5ogxUfDPeyhEeqN0eMA8qg8HuGVOcpb93YCg"
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
