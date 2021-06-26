resource "random_string" "password_vm" {
  length      = 32
  upper       = true
  min_upper   = 5
  lower       = true
  min_lower   = 5
  number      = true
  min_numeric = 5
  special     = false
}

output "password_vm" {
  value = random_string.password_vm.result
}