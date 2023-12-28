provider "google" {
    credentials = file("${var.credentials_file}")
    project     = var.project_id
    region      = var.region
}

variable "project_id" {
    description = "Google Cloud Project ID"
    type        = string
    default     = "thinking-case-409512"  
}

variable "credentials_file" {
    description = "Path to the Google Cloud credentials file"
    type        = string
    default     = "thinking-case-409512-8e7147443ac2.json"
}

variable "region" {
    description = "Google Cloud region"
    type        = string
    default     = "us-central1"
}

variable "machine_type" {
    description = "Machine type for the default node pool"
    type        = string
    default     = "n1-standard-4"
}

module "gke_cluster" {
    source = "./modules/gke_cluster"
}

# Configure kubectl to use the GKE cluster
resource "null_resource" "configure_kubectl" {
    provisioner "local-exec" {
        command = "gcloud container clusters get-credentials ${module.gke_cluster.gke_cluster_name} --region ${var.region} --project ${var.project_id}"
    }

    depends_on = [module.gke_cluster]
}