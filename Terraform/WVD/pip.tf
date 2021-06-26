module "pip" {
  source = ".//pip"

  # pip_count               = 2
  # pip_count_start         = 3
  # pip_count_zero_padding  = 2

  name       = "advm-01-pip"
  pip_rsg    = azurerm_resource_group.advm.name
  pip_sku    = "Standard"
  allocation = "Static"


  location      = var.location
  environment   = "WVD"
  tag_buildby   = "Gourav Kumar"
  tag_builddate = 20200623
}