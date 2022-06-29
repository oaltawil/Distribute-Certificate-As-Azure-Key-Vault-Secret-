# Define Variables
$subscriptionName = "Visual Studio Enterprise"
$vaultName = "kv-scrapaper-eu-001"
$secretName = "dc01scrapaperca"
$certificateFilePath = "$Env:Temp\$secretName.cer"

# Install the NuGet package provider
Install-PackageProvider -Name NuGet -Force

# Install PowerShellGet and its dependency PackageManagement
Install-Module -Name PowerShellGet -AllowClobber -Force

# Install Az.KeyVault and its dependency Az.Accounts
Install-Module -Name Az.KeyVault -AllowClobber -Force

# Sign-in to Azure using the user assigned managed identity of the virtual machine
Connect-AzAccount -Identity -Environment AzureCloud -Subscription $subscriptionName

# Import the Az.KeyVault module
Import-Module Az.KeyVault

# Read the key vault secret containing the certificate stored as a base-64 string
$secretBase64EncodedString = Get-AzKeyVaultSecret -VaultName $vaultName -Name $secretName -AsPlainText

# Convert the base-64 string to a byte array
$secretByteArray = [System.Convert]::FromBase64String($secretBase64EncodedString)

# Convert the byte array to a certificate object (class = X509Certificate2)
$certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]$secretByteArray

# Save the certificate object to a ".cer" certificate file in the Temp folder
Export-Certificate -Cert $certificate -Type CERT -FilePath $certificateFilePath -Force

# Import the certificate file to the local computer's "Trusted Root Certification Authority" certificate store
Import-Certificate -FilePath $certificateFilePath -CertStoreLocation "Cert:\LocalMachine\Root" -Confirm:$false

# Delete the certificate file from the Temp folder
Remove-Item -Path $certificateFilePath -Force