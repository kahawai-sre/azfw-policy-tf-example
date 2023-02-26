# azfw-policy-tf-example

1. /config/<resouce_type>.yaml - resource instances and per instance config are defined in YAML format 
2. /custom.security.variables.tf - defines relative paths to the yaml file for each resource type
3. /custom.security.settings.tf - yaml files for each resource type are read using yamldecode in terraform 'local' code. A map is generated for each resource type.
4. /modules/<resource_type>/ - contains terraform modules per resource type. Used to process the map (from locals) for each resource type.
5. /custom.security.main.tf - calls module for each required resource, passing in map from locals
