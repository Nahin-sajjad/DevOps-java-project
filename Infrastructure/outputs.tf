output "jenkins_master_public_ip" {
  value = azurerm_public_ip.jenkins_master_ip.ip_address
}