variable "security_contact_email" {}
variable "security_contact_phone" {}
variable "security_contact_tier" {
  default = "Free"
}

resource "azurerm_security_center_contact" "main" {
  alert_notifications = true
  alerts_to_admins = true
  email = var.security_contact_email
  phone = var.security_contact_phone
}

resource "azurerm_security_center_subscription_pricing" "main" {
  tier = var.security_contact_tier
}