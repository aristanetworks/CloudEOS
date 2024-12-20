v2.0.0 (20 Dec 2024)
f03302e terraform/examples: update azure topologies to use 4.32.2 images
107ecc9 terraform/examples: change aws ami ids to those for 4.32.2 images

v1.0.8 (23 Sep 2024)
1115dca terraform/examples: use different ip prefixes for address assignment
5da234f terraform/examples: update cloudeos provider to v1.2.2 or newer

v1.0.7 (4 April 2024)
1e020c5 terraform/examples: udpate expired aws host amis
ac59491 correct input vars for aws_tgw_multiregion
a7d97e8 multicloud_tworegion_cloudha: add creds to azure provider
7406115 examples/aws_tworegion_cloudha: fix interface ips
bff2e2c terraform/examples: seperate out ip addresses at one common place
3338e7b terraform/examples: refactor cidrs at one common place
24c5a68 comment route reflector portion as we are not using it

v1.0.6 (16 Oct 2022)
 cloudeos/terraform: upgrade cloudeos provider to 1.2.0
 terraform/examples: Add azure prefix to vpc_info to azure topology
 terraform/examples: Refactor hardcoded values of us-east-1 in aws_tgw_connect
 terraform/examples: Add note in readme for aws_oneregion_multipleleaf
 terraform/examples: Fix leaf error in aws_oneregion_multipleleaf
 terraform/examples: Fix input_vars for aws_oneregion_multipleleaf
 terraform/examples: Fix router subnet for aws_oneregion_multipleleaf
 examples: Document ingress_allowlist
 terraform/examples: Use latest AMI with CloudEOS4.27.3F
 examples: Fix readme to refer to the modified image names

v1.0.5 (14 June 2022)
 modules: Drop deprecated template provider as a dependency
 examples: Fix the interface ip for multipleleaf
 examples: Update all diagrams with new IPs
 examples: Allow passing allowed source IPs for ingress rules in examples
 examples: Use private IP ranged in all examples
 modules: Allow specifying source IPs for ingress rules in all SGs
 terraform/example: Use 4.27.3 cloudEOS image

v1.0.4 (19 April 2022)
 terraform/module: Refactor security rule from security group
 terraform: restrict azurerm provider's version to < 3.0
 examples: Reorganize input vars in azure_oneregion_multipleleaf
 examples: Reorganize input vars in azure_oneregion_multipleleaf_v2

v1.0.3 (20 Jan 2022)
 terraform/examples: Add us-west-2 region as an option for deployments
 terraform/examples: Remove variable aws_iam_instance_profile in multicloud_tworegion_provisionmode
 modules: Remove usage of deprecated map function
 terraform/examples: Refactor hardcoded values in aws_tgw_multiregion
