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
