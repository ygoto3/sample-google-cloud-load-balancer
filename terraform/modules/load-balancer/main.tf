resource "google_compute_global_address" "lb-address" {
    name = "lb-address"
}

resource "google_compute_url_map" "backend-service-url-map" {
    name = "backend-service-url-map"
    default_service = var.backend_service_self_link
}

resource "google_compute_target_http_proxy" "target-http-proxy" {
    name = "target-http-proxy"
    url_map = google_compute_url_map.backend-service-url-map.self_link
}

resource "google_compute_global_forwarding_rule" "global-forwarding-rule-http" {
    name = "global-forwarding-rule-http"
    target = google_compute_target_http_proxy.target-http-proxy.self_link
    port_range = "80"
    ip_address = google_compute_global_address.lb-address.address
}

output "load-balancer-ip" {
    value = google_compute_global_address.lb-address.address
}
