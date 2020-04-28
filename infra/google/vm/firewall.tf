resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = data.google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "1000-2000"]
  }
source_ranges = ["0.0.0.0/0"]
}

data "google_compute_network" "default" {
  name = "default"
}