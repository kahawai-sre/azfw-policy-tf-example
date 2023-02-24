

variable "vnetlink_resource_id" {
}

variable "private_dns_zone_name" {
}

variable "virtual_network_id" {
}

variable "rgistrationEnabled" {
    default = true
}

variable "connectivity_vnetlinks_to_update_yaml_file_path" {
  default = "./config/connectivity.dnsprivatezones.vnetlinks.autoregistrations.yaml"
}

