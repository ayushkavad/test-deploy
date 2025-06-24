provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_cloud_run_service" "jivana_local" {
  name     = "jivana-local"
  location = var.region
  project  = var.project_id

  autogenerate_revision_name = true 

  template {
    spec {
      containers {
        image = var.image_url
        ports {
          container_port = 3000
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  lifecycle {
    ignore_changes = [
      metadata,
      template[0].metadata,
      template[0].spec[0].containers[0].resources,
      template[0].spec[0].containers[0].env
    ]
  }
}

resource "google_cloud_run_service_iam_member" "allusers" {
  location = var.region
  project  = var.project_id
  service  = google_cloud_run_service.jivana_local.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "url" {
  value = google_cloud_run_service.jivana_local.status[0].url
}
