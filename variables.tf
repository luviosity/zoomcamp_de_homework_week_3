variable "local_project_path" {
  description = "Path to your local project to bind the volumes"
  default     = "/Users/luviosity/Documents/apps/py/zoomcamp_homework/week_3_dwh"
}

variable "mage_container_path" {
  description = "Container path for mage"
  default     = "/home/src/"
}

variable "project_name" {
  description = "Mage project name"
  default     = "zoomcamp_homework_week_3"
}

variable "environment" {
  description = "deploy environment"
  default     = "DEV"
}

variable "credentials" {
  description = "My Credentials"
  default     = "./keys/key.json"
}

variable "gcp_project" {
  description = "GCP project id"
  default     = "terraform-demo-412521"
}

variable "region" {
  description = "Region"
  default     = "europe-west3"
}

variable "location" {
  description = "Project Location"
  default     = "EU"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "ny_taxi"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}

variable "container_path_to_credentials" {
  description = "Path to the credentials inside a container"
  default     = "/home/src/keys/key.json"
}
