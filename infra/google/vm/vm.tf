resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "n1-standard-4"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = data.template_file.init-vm.rendered

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}


data "template_file" "init-vm" {
  template = "${file("${path.module}/install.sh")}"


  vars = {
    clustername    = "test"
   
  }
}