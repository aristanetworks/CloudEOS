
*Please read the main [README](../../README.md) to go over the steps to setup your environment and deploy this example topology.*

# Topology overview

This topology has an Edge VPC with multiple Leaf VPCs(4) connected to it in the same region. Every VPC has 2 CloudEOS instances each. And the Leaf VPCs have hosts behind it with iperf3 installed.

![Topology](./aws_oneregion_multipleleaf.png)

