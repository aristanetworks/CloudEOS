// Please uncomment the following lines and modify them for your deployment
// update CloudEOS SE MultiCloud POC CIDR Reservations https://docs.google.com/spreadsheets/d/1HkANmxzbowQlqqQHdI2e8qcZ1LqY7QDaTnr-BofdhLg/edit?usp=sharing
// Follow [CloudEOS SE MultiCloud POC Guide](https://docs.google.com/document/d/1DW9niGGAMtc0LGWt2OBlaGZQBTWDlTYgygnEli2JNoo/edit#) and create containers on CVAAS. They can be containers with no configlets attached to them or you can have any configlet that contains configuration that you want to push to the router when it comes up

// All the lines below need to the customized and uncommented before you run terraform
// topology = "CloudEOSEft"

// vtep_ip_cidr            = "5.0.0.0/16"  // CIDR block for VTEP IPs 
// terminattr_ip_cidr      = "6.0.0.0/16"  // Loopback IP range for terminattr source
// dps_controlplane_cidr   = "7.0.0.0/16"  // CIDR block for Dps Control Plane IPs 

// keypair_name = { us-west-1 : "systest",
//                  us-west-2 : "systest",
//                  us-east-1 : "systest",
//                  us-east-2 : "systest" }

// clos_cv_container = "CloudLeaf"
// wan_cv_container  = "CloudEdge"

// All of the above lines need to the customized and uncommented before you run terraform

// AWS IAM profile for Cloud HA so CloudEOS can change AWS routing tables
aws_iam_instance_profile = "awslogs2"

// for play replace staging to play below
cvaas = {
  domain : "apiserver.cv-staging.corp.arista.io",
  username : "admin",
  server : "www.cv-staging.corp.arista.io",
  // service token for cv_play c-clouddeploy tenant
  // service_token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJkaWQiOjExMywiZHNuIjoiYWRtaW4iLCJkc3QiOiJ1c2VyIiwiZW1haWwiOiJmYW55YW5nQGFyaXN0YS5jb20iLCJzaWQiOiIyYzBlNjM3OWVkNmZmZjI2ZjcxNDk5ZWQxZDgwMzIwODBiM2Q1N2M0ODI1NDY4NjhhM2Y0NjgyODg0M2NlYTEwLUs1eTRDMTFHang3UlNGTTFtcEdqMFE0Q2EydjktTVZUbWlhUThWS1oifQ.lcAkM52EmJjYQslKKHYGBPZrz5BBk37EBDuvZkcTp8brXpdjpY5ogxUfDPeyhEeqN0eMA8qg8HuGVOcpb93YCg"
  // service token for cv_play arista-systest-poc tenant
  // service_token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJkaWQiOjE3MCwiZHNuIjoiYWRtaW4iLCJkc3QiOiJ1c2VyIiwiZW1haWwiOiJkYWlzeUBhcmlzdGEuY29tIiwic2lkIjoiZGM4YjE4NmJhOTljYTcwZWFlNzgzMTg5ZjgwNmIxMDBiYWJiZWQ2MDhhMGI1ZDJlZmVjOGJhNTVkNGIyZjQzMS1HVWFZby1tVkRUWnpTS0E1c3FHeGJnVFVUYk9JSU5PTDYzbkNRZmUwIn0.Dnilu_-A9cBvEHEuYl_L7mdxtpGd2amRE16wZx9ra0guUT6CToNfWQFqkcypRkKLXYEsEhZKHcdN_WcoL64RQg"
  // service token for cv_staging c-arista tenant
  service_token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJkaWQiOjgsImRzbiI6ImFkbWluIiwiZHN0IjoidXNlciIsImVtYWlsIjoieGd1b0BhcmlzdGEuY29tIiwic2lkIjoiOWY2MjA4ZDI4YWMxY2U5YjRiZjI3ZjgzYTMzNjljNjZhZDFlZjRiMDVhMzViMjEzNjUwMzJmMzZiNGNmZDMzNi1RaVNfeU1XRkVZVEtBTHVmMW9aY0o2YTJNS3lwQjFXR0pLdmJIRTFQIn0.9t_h7lhs7CpACwKYLBiSKbdHPid7oXe9SNe3Ai5g9hhRtZNlN0cR2lHCv6fvjhk1LPBcYQfRgP5ya0v8NyUM-g"
}

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

eos_amis = {
  us-west-1 : "ami-017900c328c2edfbe",
  us-west-2 : "ami-0c6aba6a8b862f7ac",
  us-east-1 : "ami-0ee27fb355f900646",
  us-east-2 : "ami-0f3dd5c4e5e81f9f4"
}

availability_zone = {
  us-west-1 : { zone1 : "us-west-1b", zone2 : "us-west-1c" },
  us-east-1 : { zone1 : "us-east-1b", zone2 : "us-east-1c" },
  us-east-2 : { zone1 : "us-east-2b", zone2 : "us-east-2c" }
}

host_amis = {
  us-west-1 : "ami-035dbbb5f679b91cd",
  us-east-1 : "ami-0b161e951484253ab",
  us-east-2 : "ami-083064f66d3878ff7" }
