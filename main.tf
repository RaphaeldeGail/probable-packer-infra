/**
 * # Probable Packer Infra
 * 
 * This code sets up a simple infrastructure on GCP for creating packer instances on it.
 * 
 * ## Infrastructure description
 *
 * The code creates a private Google network, hosting the packer instance.
 *
 * The network has a default route to the internet only availables for instances with a the name of the build as a tag (the **name** variable).
 *
 * The network also allows inbound SSH connections to any instance with the same tag as for the route.
 *
 * This simple setup allows for a creation of a google instance, with access to the internet, and reachable by a packer client for provisioning.
 *
 * ## Usage
 *
 * Set the values of the required variables, either in a file or with environment variables.
 *
 * Authenticate to Google Cloud Platform with a relevant account or set the environment variable **GOOGLE_APPLICATION_CREDENTIALS** to the path of a JSON service account key.
 *
 * Simply run:
 *
 * ```bash
 * terraform init
 * terraform apply
 * ```
 *
 * with appropriate options.
 *
 */

terraform {
  required_version = "~> 1.1.2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.5.0"
    }
  }
  backend "gcs" {
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

locals {
  // Default IP address range for the worksapce network
  base_cidr_block = "10.1.0.0/27"
}

resource "google_compute_network" "network" {
  name        = join("-", [var.name, "network"])
  description = "Main network for the packer build."

  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "subnetwork" {
  name        = join("-", [var.name, "subnet"])
  description = "Subnetwork hosting packer instance."

  network       = google_compute_network.network.id
  ip_cidr_range = cidrsubnet(local.base_cidr_block, 2, 0)
}

resource "google_compute_route" "default_route" {
  name        = join("-", ["from", var.name, "to", "internet"])
  description = "Default route from the packer instance to the internet."

  network          = google_compute_network.network.name
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
  tags             = [var.name]
}

resource "google_compute_firewall" "to_front" {
  name        = join("-", ["allow", "from", "any", "to", var.name, "tcp", "22"])
  description = "Allow requests from the internet to the ${var.name} packer instance."

  network   = google_compute_network.network.id
  direction = "INGRESS"
  priority  = 10

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.name]
}