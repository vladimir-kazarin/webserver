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
