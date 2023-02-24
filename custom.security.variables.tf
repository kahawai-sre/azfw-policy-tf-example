
variable "security_resourcegroups_yaml_file_path" {
    default = "./config/security.resourcegroups.yaml"
}

variable "security_ipgroups_yaml_file_path" {
    default = "./config/security.ipgroups.yaml"
}

variable "security_ipprefixes_yaml_file_path" {
    default = "./config/security.ipprefixes.yaml"
}
variable "security_publicips_yaml_file_path" {
    default = "./config/security.publicips.yaml"
}

variable "security_azurefirewallbasepols_yaml_file_path" {
    default = "./config/security.azurefirewallbasepolicies.yaml"
}
variable "security_azurefirewallchildpols_yaml_file_path" {
    default = "./config/security.azurefirewallchildpolicies.yaml"
}

variable "security_azurefirewallpolrulecollectiongroups_ae_yaml_file_path" {
    default = "./config/security.azurefirewallpolicyrulecollectiongroups-ae.yaml"
}
