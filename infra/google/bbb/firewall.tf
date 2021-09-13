resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = data.google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "22", "443", "8443","4443", "8080", "1000-2000"]
  }

allow {
    protocol = "udp"
    ports    = ["16384-32768"]
  }

source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "ssh" {
  name    = "ssh-firewall"
  network = data.google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
source_ranges = ["172.17.0.4/32"]
}


data "google_compute_network" "default" {
  name = "vpc-shared-sbox-5b79b0aa"
}