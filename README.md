# azfw-policy-tf-example
Example pattern for deployment and ongoing lifecycle management of Azure Firewall Policy and Rule Collecttion Groups, alongside immediate resource dependencies.
1. /config/<resouce_type>.yaml - for all deployed Azure Resources, resource instances and per instance config are defined in YAML format 
2. /custom.security.variables.tf - defines relative paths to the yaml file for each resource type
3. /custom.security.settings.tf - yaml files for each resource type are read using yamldecode in terraform 'local' code. A map is generated for each resource type.
4. /modules/<resource_type>/ - contains terraform modules per resource type. Used to process the map (from locals) for each resource type.
5. /custom.security.main.tf - calls module for each required resource, passing in map from locals

NOTE: example assumes all dependent resources for Azure Firewall Policy are included in the deployment:
- IP Prefixes (for carving out Public IPs from a consistent range)
- Public IPs (from IP Prefixes), for use in NAT rules
- IP Groups (for SRC/DST in rules)
- Azure Firewall Base policy
- Azure Firewall Child Policy
- Azure Firewall Policy Rule Collection Groups, with NAT, Network, and Application rules

## Intent:
- Split "config" from code as an enabler for splitting repos/RBAC based on SoD model
- Make config more human readable using YAML. This lends itself to having operational teams - who may not be IaC experts - make pull requests for changes (arguably at least better than having to update native complex TF variables, or bicep/json)
- "Enforce" use of terraform "maps" (key=>values) as inputs to modules, and for safe state file structure (e.g. avoiding "count")
- Deployment can easily (flexibly) be split across multiple azure subscriptions using Providers. e.g. IP Groups and IP Prefixes could be deployed to 'connectivity' subscription archetype, while Firewall Policy resources are deployed to a 'network security' subscription archetype in the ESLZ. Config can likewise be split to different git repos with associated RBAC and Separation of Duties concerns covered.
- Priovide a highly consistent and re-usable pattern for any Azure (or AWS etc) Deployment 
- Can be layered on top of existing Landing Zones which may have been deployed using a super-module e.g. Azure Terraform Landing Zone module.
