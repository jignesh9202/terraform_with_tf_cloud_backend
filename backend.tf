
terraform {
  cloud {
   
    organization = "learning_jig"
    hostname = "app.terraform.io"

    workspaces {
      name = "CICD_Pipe"
    }
  }
}