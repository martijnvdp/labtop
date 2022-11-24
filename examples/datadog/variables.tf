variable "datadogKeys" {
  type = object({
    api = string
    app = string
  })
  description = "Datadog keys"
}
