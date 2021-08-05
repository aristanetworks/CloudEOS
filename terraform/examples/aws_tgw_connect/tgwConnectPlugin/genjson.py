#!/usr/bin/env python
# Copyright (c) 2021 Arista Networks, Inc.  All rights reserved.
# Arista Networks, Inc. Confidential and Proprietary.

from __future__ import absolute_import, division, print_function

import argparse
import json
import subprocess
import sys

def getArgsParser():
   parser = argparse.ArgumentParser(
         description="Generates input json for tgw connect")
   parser.add_argument("-o", "--out", action="store",
         help="Path to the json file to write", required=True)
   return parser

parser = getArgsParser()
args = parser.parse_args()

tfstate = None
try:
   tfstate = subprocess.check_output(["terraform", "output", "-json", "-state=../tgwAndTopo/terraform.tfstate"],
         stderr=subprocess.STDOUT)
except subprocess.CalledProcessError as e:
   rc = e.returncode
   errMsg = e.output
   print(errMsg)
   sys.exit(rc)

decodedTfstate = tfstate.decode('utf8').replace("'", '"')
tfstatejson = json.loads(decodedTfstate)

trivialFields = []
trivialFields += [ "python_path" ]
trivialFields += [ "cvaas_server" ]
trivialFields += [ "cvaas_service_account_token" ]
trivialFields += [ "aws_region" ]
trivialFields += [ "tag_prefix" ]
trivialFields += [ "segments" ]
trivialFields += [ "connect_vpc_id" ]
trivialFields += [ "tgw_id" ]
trivialFields += [ "tgw_route_table_id" ]
trivialFields += [ "tgw_cidr" ]

tgwConnectJson = {}
for field in trivialFields:
   tgwConnectJson.update( tfstatejson[field]["value"] )

deviceFields = []
deviceFields += ["connect_vpc_subnet_id"]
deviceFields += ["connect_vpc_subnet_route_table_id"]
deviceFields += ["underlay_ip"]
deviceFields += ["bgp_asn"]
deviceFields += ["bgp_peering_cidr"]

devicesJson = {}
for deviceKey, device in tfstatejson["EdgeNames"]["value"].iteritems():
   deviceNestedJson = {}
   for field in deviceFields:
      deviceNestedJson.update( { field : tfstatejson[field]["value"][deviceKey] } )
   devicesJson.update( { device : deviceNestedJson } )

tgwConnectJson.update( { "devices" : devicesJson } )

with open(args.out, 'w') as f:
   f.write(json.dumps(tgwConnectJson, indent=4))
