# Enables the Compute Engine API
resource "google_project_service" "compute_api" {
  service = "compute.googleapis.com"

  disable_on_destroy = true
}

module "gce" {
    source = "../modules/gce"

    project = var.project
    region = var.region
    zone = var.zone
    instance_name = var.instance_name
    instance_group_name = var.instance_group_name
    machine_type = var.machine_type
    image = var.image
    instance_tags = var.instance_tags

    network = google_compute_network.this.self_link
    subnetwork = google_compute_subnetwork.this.self_link

    depends_on = [google_project_service.compute_api]
}

module "load-balancer" {
    source = "../modules/load-balancer"

    project = var.project
    backend_service_self_link = module.gce.backend_service_self_link

    depends_on = [module.gce]
}
