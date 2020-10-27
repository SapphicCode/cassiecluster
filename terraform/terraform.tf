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
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 2.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.14"
    }
  }
}

// authenticate to Vault
variable "approle_id" {}
variable "approle_secret" {}
provider "vault" {
  address = "https://vault.pandentia.qcx.io"

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = var.approle_id
      secret_id = var.approle_secret
    }
  }
}

// instantiate providers with secrets from Vault
data "vault_generic_secret" "aws" {
  path = "terraform/aws"
}
provider "aws" {
  access_key = data.vault_generic_secret.aws.data.access_key
  secret_key = data.vault_generic_secret.aws.data.secret_key
  region     = "eu-north-1"
}

data "vault_generic_secret" "google" {
  path = "terraform/google"
}
provider "google" {
  credentials = data.vault_generic_secret.google.data_json
  project     = "sapphiclabs"
  region      = "europe"
}

data "vault_generic_secret" "hcloud" {
  path = "terraform/hcloud"
}
provider "hcloud" {
  token = data.vault_generic_secret.hcloud.data.token
}

data "vault_generic_secret" "cloudflare" {
  path = "terraform/cloudflare"
}
provider "cloudflare" {
  api_token = data.vault_generic_secret.cloudflare.data.token
}

data "vault_generic_secret" "digitalocean" {
  path = "terraform/digitalocean"
}
provider "digitalocean" {
  token = data.vault_generic_secret.digitalocean.data.token
}
