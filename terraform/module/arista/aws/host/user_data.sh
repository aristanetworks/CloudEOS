#!/bin/bash
# Copyright (c) 2019 Arista Networks, Inc.  All rights reserved.
# Arista Networks, Inc. Confidential and Proprietary.
# Subject to Arista Networks, Inc.'s EULA.
# FOR INTERNAL USE ONLY. NOT FOR DISTRIBUTION.

sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
service sshd restart
