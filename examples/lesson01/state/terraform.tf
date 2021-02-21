terraform {
  backend "remote" {
    organization = "Slalom"
    workspaces { name = "basic-demo-instance" }
  }
}
