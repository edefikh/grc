# grc
Governance and Compliance Tips and tricks with automations
Below is an example script to create a Conditional Access policy using the Microsoft Graph PowerShell module. This script assumes you are targeting users and requiring multi-factor authentication (MFA) as part of the policy.

Prerequisites:
Install the Microsoft Graph PowerShell module:
powershell
Copy
Edit
Install-Module Microsoft.Graph -Scope CurrentUser

Connect to Microsoft Graph:
powershell
Copy
Edit
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess"

Ensure you have the necessary permissions in Azure AD to manage Conditional Access policies.


Creating a PowerShell script to configure Conditional Access (CA) policies in Microsoft Azure requires the AzureAD or Microsoft.Graph PowerShell module. Microsoft recommends the newer Microsoft Graph SDK for managing Conditional Access policies, as it is more up-to-date.

Below is an example script to create a Conditional Access policy using the Microsoft Graph PowerShell module. This script assumes you are targeting users and requiring multi-factor authentication (MFA) as part of the policy.

Prerequisites:
Install the Microsoft Graph PowerShell module:
powershell
Copy
Edit
Install-Module Microsoft.Graph -Scope CurrentUser
Connect to Microsoft Graph:
powershell
Copy
Edit
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess"
Ensure you have the necessary permissions in Azure AD to manage Conditional Access policies.
PowerShell Script Example:
powershell
Copy
Edit
# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess"

# Define the Conditional Access Policy parameters
$policyName = "Require MFA for All Users"
$description = "This policy enforces MFA for all users except for emergency access accounts."
$state = "enabled" # Can be 'enabled', 'disabled', or 'enabledForReportingButNotEnforced'

# Define Users to Include and Exclude
$usersIncluded = @("All")
$usersExcluded = @("emergency_account@yourdomain.com") # Replace with your actual emergency account(s)

# Define Conditions
$conditions = @{
    Applications = @{
        IncludeApplications = @("*") # Applies to all cloud apps
        ExcludeApplications = @()
    }
    Locations = @{
        IncludeLocations = @("*") # Applies to all locations
        ExcludeLocations = @()
    }
    Platforms = @{
        IncludePlatforms = @("all")
        ExcludePlatforms = @()
    }
    Devices = @{
        DeviceFilter = @{
            Mode = "exclude"
            Rule = "device.deviceTrustType -eq 'Compliant'"
        }
    }
}

# Define Grant Controls
$grantControls = @{
    Operator = "OR"
    BuiltInControls = @("mfa")
}

# Create the Conditional Access Policy
$policy = @{
    DisplayName = $policyName
    State = $state
    Conditions = $conditions
    GrantControls = $grantControls
    Assignments = @{
        Users = @{
            IncludeUsers = $usersIncluded
            ExcludeUsers = $usersExcluded
        }
        Applications = $conditions.Applications
    }
}

# Create the policy via Microsoft Graph
try {
    New-MgConditionalAccessPolicy -BodyParameter $policy
    Write-Host "Conditional Access Policy '$policyName' created successfully."
} catch {
    Write-Error "Failed to create Conditional Access Policy. Error: $_"
}
Explanation:
Connect-MgGraph: Connects to Microsoft Graph with the necessary scopes to create CA policies.
Policy Parameters: Includes policy name, state, users, applications, locations, and grant controls.
Conditions: Specifies which users, apps, platforms, and device types the policy applies to.
Grant Controls: Specifies that MFA is required for this policy.
Error Handling: Captures and displays errors during the policy creation process.

Notes:
Replace placeholders like emergency_account@yourdomain.com and ensure your conditions and grants match your organization's requirements.
Test the policy in a non-production environment before rolling it out to ensure it behaves as expected.
Always exclude emergency accounts to avoid accidental lockouts.
