provider "google" {
    credentials = file("thinking-case-409512-8e7147443ac2.json")
    project     = "thinking-case-409512"
    region      = "us-central1" 
}

variable "project_id" {
    description = "Google Cloud Project ID"
    type        = string
    default     = "thinking-case-409512"  
}

# Create a GKE cluster
resource "google_container_cluster" "wafi_cluster" {
    name     = "wafi-gke-cluster"
    location = "us-central1" 

    node_pool {
        name       = "default-pool"
        initial_node_count = 1

        node_config {
            machine_type = "n1-standard-4" 
        }
    }

    master_auth {
        client_certificate_config {
            issue_client_certificate = false
        }
    }
}

# Configure kubectl to use the GKE cluster
resource "null_resource" "configure_kubectl" {
    provisioner "local-exec" {
        command = "gcloud container clusters get-credentials ${google_container_cluster.wafi_cluster.name} --region ${google_container_cluster.wafi_cluster.location} --project ${var.project_id}"
    }

    depends_on = [google_container_cluster.wafi_cluster]
}
