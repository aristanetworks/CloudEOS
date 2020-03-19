
*Please read "../../README.md on steps to setup your env and deploy the topology*

# Topology overview

This topology is a multi-region setup with 2 Edge VPCs in different regions (region 2 and region 3) and leaf VPCs connected to those Edge VPCs. Each VPC has two availability zones with CloudEOS deployed as a Cloud HA pair. The edge routers are connected to a CloudEOS Route Reflector deployed in a VPC in region 1. 

Leaf VPCs also create host VMs with iperf3 installed. These hosts are connected to the Leaf CloudEOS instances and can be used to test end-end connectivity.
