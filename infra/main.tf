provider "google" {
  project     = var.project_id
  region      = var.region
}

resource "google_cloud_run_service" "jivana_local" {
  name     = "jivana-local"
  location = var.region
  project  = var.project_id

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
