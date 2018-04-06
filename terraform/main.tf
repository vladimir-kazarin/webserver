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

resource "google_compute_instance_template" "default" {
  name = "tf-server"
  disk {
    image = "cos-stable"
  }
}

resource "google_compute_instance_group_manager" "default" {
  base_instance_name = "app"
  instance_template  = "${google_compute_instance_template.tf-server.self_link}"
  target_size = 2

}
