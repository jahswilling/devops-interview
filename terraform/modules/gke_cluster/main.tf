
resource "google_container_cluster" "wafi_cluster" {
    name     = var.cluster_name
    location = var.region 

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


# modules/gke_cluster/outputs.tf

output "gke_cluster_name" {
    value = google_container_cluster.wafi_cluster.name
}