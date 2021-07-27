#!/usr/bin/env python
# Copyright (c) 2021 Arista Networks, Inc.  All rights reserved.
# Arista Networks, Inc. Confidential and Proprietary.

from __future__ import absolute_import, division, print_function

from cvprac.cvp_client import CvpClient
import urllib3
import json
import sys
import argparse

def parseArgs():
   parser = argparse.ArgumentParser(
       description='Creates configlet and applies to device in CVaaS')

   parser.add_argument('--mode', action='store', choices=['create', 'destroy'],
                       help='Mode of either create or destroy')

   parser.add_argument('--server', action='store',
                       help='CVaaS Server where the device is deployed')

   parser.add_argument('--token', action='store',
                       help='Service Token used for API with CVaaS')

   parser.add_argument('--device-name', action='store',
                       help='Hostanme of the device to which the configlet is to be applied')

   parser.add_argument('--config-file', action='store',
                       help='Configlet file to be read for application to device')

   args = parser.parse_args()
   args.verbose = True
   return args

args = parseArgs()

mode = args.mode  # create or destroy
cvaas_node = args.server # ex  "www.cv-staging.corp.arista.io"
cvaas_service_token = args.token  # Service Token created in CVaaS
device_name = args.device_name # Device name as found in CVaaS
configlet_file = args.config_file

configlet_string = ''
with open(configlet_file, 'r') as f:
  configlet_string = f.read()

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# cvprac api reference
# https://github.com/aristanetworks/cvprac/blob/develop/cvprac/cvp_api.py

client = CvpClient()

client.connect(
   nodes=[cvaas_node],
   username='', password='', is_cvaas=True,
   cvaas_token=cvaas_service_token
)

configlet_name = device_name + '_aws_tgw_connect'
device_info = client.api.get_device_by_name(device_name)

if mode == 'create':
   # create configlet
   client.api.add_configlet(configlet_name, configlet_string)
   # get configlet info by name
   configlet_info = client.api.get_configlet_by_name(configlet_name)
   # apply configlet to a switch
   response_data = client.api.apply_configlets_to_device('ADD_AWS_TGW_CONNECT', device_info, [configlet_info], create_task=True)
   # execute task
   client.api.execute_task(response_data['data']['taskIds'][0])
elif mode == 'destroy':
   # get configlet info by name
   configlet_info = client.api.get_configlet_by_name(configlet_name)
   # remove configlet from device
   response_data = client.api.remove_configlets_from_device('REMOVE_AWS_TGW_CONNECT', device_info, [configlet_info], create_task=True)
   # execute task
   client.api.execute_task(response_data['data']['taskIds'][0])
   # delete configlet
   result = client.api.delete_configlet(configlet_info['name'], configlet_info['key'])
