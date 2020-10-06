terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "SapphicLabs"
    
    workspaces {
      name = "cassiecluster"
    }
  }
}