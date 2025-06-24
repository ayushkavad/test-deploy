provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_cloud_run_service" "jivana_local" {
  name     = "jivana-local"
  location = var.region
  project  = var.project_id

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/jivana-local"
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

resource "google_cloudbuild_trigger" "github_trigger" {
  name = "nextjs-auto-deploy"

  github {
    owner = var.github_owner
    name  = var.github_repo
    push {
      branch = var.github_branch
    }
  }

  included_files = ["*"]

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "gcr.io/${var.project_id}/jivana-local", "."]
    }

    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["push", "gcr.io/${var.project_id}/jivana-local"]
    }

    step {
      name = "gcr.io/cloud-builders/gcloud"
      args = [
        "run", "deploy", "jivana-local",
        "--image", "gcr.io/${var.project_id}/jivana-local",
        "--region", var.region,
        "--platform", "managed",
        "--allow-unauthenticated"
      ]
    }

    images = [
      "gcr.io/${var.project_id}/jivana-local"
    ]
  }
}

output "cloud_run_url" {
  value = google_cloud_run_service.jivana_local.status[0].url
}
