data "google_compute_image" "my_image" {
  family  = "ubuntu-1604-lts"
  project = "ubuntu-os-cloud"
}

data "template_cloudinit_config" "init" {
  gzip = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = file("cloud_init.conf")
  }


  part {
    content_type = "text/x-shellscript"
    content = file("install.sh")
    filename = "install.sh"
  }
}

resource "google_compute_instance" "default" {
  name         = "gmjtest"
  machine_type = "n1-standard-4"
  zone         = "europe-west3-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    //network ="vpc-shared-sbox-5b79b0aa"
    subnetwork = "europe-west3-sbox-subnet"
   
    access_config {
      // Ephemeral IP
    }
  }

  #metadata_startup_script = data.template_file.init-vm.rendered

  metadata = {
    ssh-keys = "volkdir:${file("~/.ssh/id_rsa.pub")}"
    user-data = data.template_cloudinit_config.init.rendered
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

