variable "credentials" {}

variable "project" {}
variable "region" {}
variable "zone" {}
variable "network_name" {
    default = "sample-network"
}
variable "subnetwork_name" {
    default = "sample-subnetwork"
}
variable "instance_name" {
    default = "sample-instance"
}
variable "machine_type" {
    default = "e2-micro"
}
variable "image" {
    default = "debian-cloud/debian-12"
}
variable "instance_group_name" {
    default = "sample-instance-group"
}
variable "instance_tags" {
    default = ["web"]
}
