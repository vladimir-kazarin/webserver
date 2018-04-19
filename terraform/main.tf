terraform {
 backend "gcs" {
   project = "comp698-vak1003"
   bucket  = "comp698-vak1003-terraform-state"
   prefix  = "terraform-state"
 }
}
provider "google" {
  region = "us-central1"
}

resource "google_compute_instance_template" "tf-server" {
  name = "tf-server"
  project = "comp698-vak1003"
  disk {
    source_image = "cos-cloud/cos-stable"
  }
  machine_type = "n1-standard-1"
  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["http-server"] 

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_write",
    ]
  }
  metadata {
      gce-container-declaration = <<EOF
  spec:
    containers:
    - image: 'gcr.io/comp698-vak1003/github-vladimir-kazarin-webserver:7e0540af2209c55e94bc3ec7ca1cd8cd2eed66dd'
      name: service-container
      stdin: false
      tty: false
    restartPolicy: Always
EOF
  }
}

resource "google_compute_instance_template" "tf-server2" {
  name = "tf-server2"
  project = "comp698-vak1003"
  disk {
    source_image = "cos-cloud/cos-stable"
  }
  machine_type = "n1-standard-1"
  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["http-server"]

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_write",
    ]
  }
  metadata {
      gce-container-declaration = <<EOF
  spec:
    containers:
    - image: 'gcr.io/comp698-vak1003/github-vladimir-kazarin-webserver:1982b19d53ecbc9848bb809fd3ef019720975493'
      name: service-container
      stdin: false
      tty: false
    restartPolicy: Always
EOF
  }
}

resource "google_compute_instance_group_manager" "default" {
  name = "tf-manager"
  project = "comp698-vak1003"
  zone = "us-central1-f"
  base_instance_name = "prod"
  instance_template  = "${google_compute_instance_template.tf-server.self_link}"
  target_size = 2
}

resource "google_compute_instance_group_manager" "default2" {
  name = "tf-manager2"
  project = "comp698-vak1003"
  zone = "us-central1-f"
  base_instance_name = "staging"
  instance_template  = "${google_compute_instance_template.tf-server2.self_link}"
  target_size = 1
}

resource "google_storage_bucket" "image-store" {
  project  = "comp698-vak1003"
  name     = "ilikebruins"
  location = "us-central1"
}

