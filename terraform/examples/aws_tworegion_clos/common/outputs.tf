output "topology" {
  value = "sonu"
}

output "keypair_name" {
  value = "systest"
}

output "cvaas" {
  value = {
    domain = "apiserver.cv-play.corp.arista.io"
    username = "admin"
    server = "www.cv-play.corp.arista.io"
    service_token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJkaWQiOjExMywiZHNuIjoiYWRtaW4iLCJkc3QiOiJ1c2VyIiwiZW1haWwiOiJwcmFuaWdhbUBhcmlzdGEuY29tIiwic2lkIjoiOTEwOTE4MWEyYjQyNDExYjk1MmUxMDQ4N2E3M2FlNThjMGZiMGVhMWU5MjA0ZGZlYTJiZTBjODAwMGNlMDc3OC1WQlF5d0Zrdmd0a2ZRZTdKdl9JQUk1QVcwTnE0akxzVHFNaDB0VkcxIn0.QSLmmeHy8PU-Sv8Lfw-AJEX6H9rnmcHzLTSgzJCfbPtPoosgqBha_CWBd2YmYF5R7hiP99a5P-nHR9r75PHv-w"
  }
}

output "instance_type" {
  value = {
    rr = "c5.xlarge"
    edge = "c5.xlarge"
    leaf = "c5.xlarge"
  }
}

output "aws_regions" {
  value = {
    region1 = "us-west-1"
    region2 = "us-east-1"
    region3 = "us-east-2"
  }
}

output "eos_amis" {
  value = {
    us-west-1 = "ami-008dcfac638957625"
    us-east-1 = "ami-0dc7d48e0ec0e454d"
    us-east-2 = "ami-0c9033e6ba32cc036"
  }
}

output "availability_zone" {
  value = {
    us-west-1 = {
      zone1 = "us-west-1b"
      zone2 = "us-west-1c"
    }
    us-east-1 = {
      zone1 = "us-east-1b"
      zone2 = "us-east-1c"
    }
    us-east-2 = {
      zone1 = "us-east-2b"
      zone2 = "us-east-2c"
    }    
  }
}

output "host_amis" {
    value = {
      us-west-1 = "ami-035dbbb5f679b91cd"
      us-east-1 = "ami-0b161e951484253ab"
      us-east-2 = "ami-083064f66d3878ff7"
    }
}
