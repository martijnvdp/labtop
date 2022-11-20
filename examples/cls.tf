module "eks" {
  source = "git::https://github.com/martijnvdp/labtop.git?ref=v0.0.1"

  kindCluster = {
    name    = "labtop"
    version = "v1.21.14"

    config = {
      controlNodes = 1
      workerNodes  = 2
    }
  }
}
