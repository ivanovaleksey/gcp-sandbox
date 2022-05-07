terraform {
  cloud {
    organization = "example-org-38a8e8"

    workspaces {
      name = "gcp-sandbox"
    }
  }
}
