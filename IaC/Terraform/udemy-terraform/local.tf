resource "random_pet" "my-pet" {
  prefix    = var.prefix
  separator = "."
  length    = 1
  sensitive = true
}