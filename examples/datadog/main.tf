module "eks" {
  source = "../../"

  datadogKeys = {
    api = var.datadogKeys.api
    app = var.datadogKeys.app
  }

  kindCluster = {
    config = {
      controlNodes = 1
      workerNodes  = 2
    }
  }
}
