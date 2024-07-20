resource "google_compute_address" "this" {
    name = "instance-ip"
    region = var.region
    project = var.project
}

resource "google_compute_instance" "this" {
    name = var.instance_name
    machine_type = var.machine_type
    zone = var.zone
    project = var.project
    boot_disk {
        initialize_params {
            image = var.image
            size = 10
            type = "pd-standard"
        }
    }
    network_interface {
        network = var.network
        subnetwork = var.subnetwork
        access_config {
            nat_ip = google_compute_address.this.address
        }
    }
    metadata_startup_script = "sudo apt update; sudo apt install nginx -y; sudo systemctl start nginx"
    tags = ["web"]
}

resource "google_compute_instance_group" "this" {
    name = var.instance_group_name
    zone = var.zone
    project = var.project
    instances = [google_compute_instance.this.self_link]
    named_port {
        name = "http"
        port = 80
    }
}

resource "google_compute_health_check" "health-check-backend-service" {
    name = "http-basic-check"

    check_interval_sec = 5
    timeout_sec = 5
    healthy_threshold = 4
    unhealthy_threshold = 5

    http_health_check {
        port = 80
    }
}

resource "google_compute_backend_service" "backend-service" {
    name = "backend-service"
    project = var.project
    port_name = "http"
    protocol = "HTTP"
    timeout_sec = 3000
    health_checks = [google_compute_health_check.health-check-backend-service.self_link]

    backend {
        group = google_compute_instance_group.this.self_link
    }

    # enable_cdn = true
    # cdn_policy {
    #     signed_url_cache_max_age_sec = 300
    # }
}

output "backend_service_self_link" {
    value = google_compute_backend_service.backend-service.self_link
}
