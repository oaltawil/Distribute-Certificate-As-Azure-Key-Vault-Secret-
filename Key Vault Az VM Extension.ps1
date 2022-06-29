$ResourceGroupName = "web-01"
$VMName = "web-01"
$Location = "eastus"
$userAssignedIdentityClientId = "8eb49fa0-3f0b-43d3-b93c-c740aa46e9ad"

# Key Vault Secret settings
$Settings = @{
  "secretsManagementSettings" = @{ 
    "pollingIntervalInS"    = "3600"; 
    "certificateStoreName"   = "My"; 
    "certificateStoreLocation" = "LocalMachine"; 
    "observedCertificates"   = @("https://kv-scrapaper-eu-001.vault.azure.net/secrets/dc01scrapaperca") 
  } 
  "authenticationSettings" = @{
    "msiEndpoint" = "http://169.254.169.254/metadata/identity";
    "msiClientId" = $userAssignedIdentityClientId
  }
}

$extName = "KeyVaultForWindows"
$extPublisher = "Microsoft.Azure.KeyVault"
$extType = "KeyVaultForWindows"

# Start the deployment
Set-AzVmExtension -TypeHandlerVersion "1.0" -ResourceGroupName $ResourceGroupName -Location $Location -VMName $VMName -Name $extName -Publisher $extPublisher -Type $extType -Settings $settings

