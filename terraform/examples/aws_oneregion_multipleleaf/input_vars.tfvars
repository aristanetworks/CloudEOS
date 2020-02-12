topology = "multipleLeaf"

keypair_name = { us-west-1 : "systest",
                 us-west-2 : "systest",
                 us-east-1 : "systest",
                 us-east-2 : "systest" }

cvaas = { domain : "apiserver.cv-play.corp.arista.io", 
          username : "admin", 
          server : "www.cv-play.corp.arista.io", 
          //clouddeploy
          //service_token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJkaWQiOjExMywiZHNuIjoiYWRtaW4iLCJkc3QiOiJ1c2VyIiwiZW1haWwiOiJwcmFuaWdhbUBhcmlzdGEuY29tIiwic2lkIjoiOTEwOTE4MWEyYjQyNDExYjk1MmUxMDQ4N2E3M2FlNThjMGZiMGVhMWU5MjA0ZGZlYTJiZTBjODAwMGNlMDc3OC1WQlF5d0Zrdmd0a2ZRZTdKdl9JQUk1QVcwTnE0akxzVHFNaDB0VkcxIn0.QSLmmeHy8PU-Sv8Lfw-AJEX6H9rnmcHzLTSgzJCfbPtPoosgqBha_CWBd2YmYF5R7hiP99a5P-nHR9r75PHv-w" 
          //arista-systest
          service_token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJkaWQiOjE3MCwiZHNuIjoiYWRtaW4iLCJkc3QiOiJ1c2VyIiwic2lkIjoiN2IyMTdmNTc4NThiNjQ3NWExZDU0ODI5MGM3MGU5ODFiYzZlNzc4OGFiMTBkZDk1ZmFiMTM0ZWM4MGQ2YjFhNy01MjNOa2cwcUg4LUIwRDdYR1FoZXBaa2Z1Ym5iQi1fT2l5QUtzeEV3In0.7Kx_G8YQHrXQBxLH87h1_Y3n98V-aS293VMDTvcJlV6GoDDfseqVHP1B7LOPgjbX73PjcKAGmoSYWFts0eYeSg"
        }

instance_type = { rr:"c5.xlarge",
                  edge:"c5.xlarge",
                  leaf:"c5.xlarge" }

aws_regions = { region1 : "us-west-1",
                region2 : "us-east-1",
                region3 : "us-east-2" }

eos_amis = { us-west-1 : "ami-06c9d181b46328b47",
             us-east-1 : "ami-02cfb0ab93718c454",
             us-east-2 : "ami-09a466b4086fa3492" }

availability_zone = { us-west-1 : {zone1 : "us-west-1b", zone2 : "us-west-1c"},
                      us-east-1 : {zone1 : "us-east-1b", zone2 : "us-east-1c"},
                      us-east-2 : {zone1 : "us-east-2b", zone2 : "us-east-2c"} }

host_amis = { us-west-1 : "ami-035dbbb5f679b91cd",
              us-east-1 : "ami-0b161e951484253ab",
              us-east-2 : "ami-083064f66d3878ff7" }
