resource "google_compute_network" "this" {
    name = var.network_name
    project = var.project
    auto_create_subnetworks = false
}

resource "google_compute_firewall" "http" {
    name = "allow-http-https"
    allow {
        protocol = "tcp"
        ports = ["80", "443"]
    }
    direction = "INGRESS"
    network = google_compute_network.this.id
    priority = 1000
    source_ranges = ["0.0.0.0/0"]
    target_tags = var.instance_tags
}

resource "google_compute_subnetwork" "this" {
    name = var.subnetwork_name
    ip_cidr_range = "10.0.1.0/24"
    region = var.region
    network = google_compute_network.this.id
}
