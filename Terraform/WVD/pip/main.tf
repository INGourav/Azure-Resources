resource "azurerm_public_ip" "pip" {
  count = var.pip_count_zero_padding == 0 ? 1 : var.pip_count

  name                = var.pip_count_zero_padding == 0 ? join("", [var.name, "-pip"]) : join("", [var.name, format("%0${var.pip_count_zero_padding}d", count.index + var.pip_count_start), "-pip"])
  location            = var.location
  resource_group_name = var.pip_rsg

  sku               = var.pip_sku
  allocation_method = var.allocation

  tags = {
    Environment = var.environment
    BuildBy     = var.buildby
    BuildDate   = var.builddate
  }
}