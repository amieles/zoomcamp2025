terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
# Credentials only needs to be set if you do not have the GOOGLE_APPLICATION_CREDENTIALS set
#  credentials = 
  project = var.project
  region  = "us-central1"
}



resource "google_storage_bucket" "data-lake-bucket" {
  name          = "terraform-bucket-demo-447802"
  location      = "US"

  # Optional, but recommended settings:
  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30  // days
    }
  }

  force_destroy = true
}


resource "google_bigquery_dataset" "dataset" {
  dataset_id = "terraform_dataset_447802"
  project    = var.project
  location   = "US"
}

variable "project" {
  description = "project id"
  default = "test value to be overidden in cli"
  
}