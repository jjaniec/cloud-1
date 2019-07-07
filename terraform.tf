terraform {
  backend "remote" {
    organization = "jjaniec"

    workspaces {
      name = "cloud-1"
    }
  }
}
