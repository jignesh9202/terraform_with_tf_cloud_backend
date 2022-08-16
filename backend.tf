terraform {
  cloud {
    organization = "learning_jig"

    workspaces {
      name = "CICD_Pipe"
    }
  }
}