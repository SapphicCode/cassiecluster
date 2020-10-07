terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "SapphicLabs"

    workspaces {
      name = "cassiecluster"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.9"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.11"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.22"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 3.42"
    }
  }
}

provider "google" {}
