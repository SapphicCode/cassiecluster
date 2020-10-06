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
      version = "~> 3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.22"
    }
  }
}
