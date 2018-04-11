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
  }
}

resource "google_compute_instance_group_manager" "default" {
  name = "tf-manager"
  project = "comp698-vak1003"
  zone = "us-central1-f"
  base_instance_name = "app"
  instance_template  = "${google_compute_instance_template.tf-server.self_link}"
  target_size = 2

}

resource "google_storage_bucket" "image-store" {
  project  = "comp698-vak1003"
  name     = "ilikebruins"
  location = "us-central1"
}
