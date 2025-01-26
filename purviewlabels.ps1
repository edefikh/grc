# Load Microsoft Graph PowerShell Module
Import-Module Microsoft.Graph

# Variables
$TenantId = "your-tenant-id"                  # Replace with your Tenant ID
$ClientId = "your-client-id"                  # Replace with your App Registration Client ID
$ClientSecret = "your-client-secret"          # Replace with your App Registration Client Secret

# Authenticate to Microsoft Graph
$SecureClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force
$AppCredential = New-Object Microsoft.Graph.Authentication.ClientCredential -ArgumentList $SecureClientSecret
$GraphAuthProvider = [Microsoft.Graph.Authentication.GraphAuthenticationProviderFactory]::CreateClientCredentialProvider($ClientId, $TenantId, $AppCredential)
Connect-MgGraph -AuthProvider $GraphAuthProvider

# Set the API version
$GraphVersion = "v1.0"

# Define Sensitivity Label Properties
$LabelName = "Confidential"                   # Name of the sensitivity label
$Description = "Classifies data as confidential." # Description for the label
$Color = "#FF0000"                           # Label color in Hex format
$ContentFormats = @("email", "file")         # Supported formats for this label
$EncryptionPolicy = @{
    "@odata.type" = "#microsoft.graph.sensitivityLabelAssignmentMethod"
    "isMandatory" = $true                    # Makes label mandatory
}

# Build the body for creating a new label
$SensitivityLabelBody = @{
    "displayName" = $LabelName
    "description" = $Description
    "color" = $Color
    "isActive" = $true
    "contentFormats" = $ContentFormats
    "labelActions" = @($EncryptionPolicy)
}

# Convert the body to JSON
$SensitivityLabelJson = $SensitivityLabelBody | ConvertTo-Json -Depth 10

# Call Microsoft Graph API to create the label
$GraphUri = "https://graph.microsoft.com/$GraphVersion/security/labels/sensitivityLabels"
$Response = Invoke-RestMethod -Uri $GraphUri -Method POST -Body $SensitivityLabelJson -Headers @{
    "Authorization" = "Bearer $($GraphAuthProvider.AuthenticateAsync().Result.Token)"
    "Content-Type" = "application/json"
}

# Display the response
if ($Response -ne $null) {
    Write-Host "Sensitivity label created successfully!" -ForegroundColor Green
    Write-Output $Response
} else {
    Write-Host "Failed to create sensitivity label." -ForegroundColor Red
}
