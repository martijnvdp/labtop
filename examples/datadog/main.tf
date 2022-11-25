module "eks" {
  source = "../../"

  # only add keys after initial cluster creation
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
