# Collection of usefull scripts for MS Azure to harden tenant
Governance and Compliance Tips and tricks with automations
Below is an example script to create a Conditional Access policy using the Microsoft Graph PowerShell module. This script assumes you are targeting users and requiring multi-factor authentication (MFA) as part of the policy.

#enable conditional access script explained
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


#screenlok script
Steps to Deploy in Microsoft Azure
Save the Script: Save the above script as Set-ScreenLock.ps1.

Deploy to Azure-Managed Machines:

If using Azure Intune, you can deploy this script as a custom script to managed devices:

In the Azure Portal, navigate to Microsoft Intune > Devices > Scripts > Add.
Upload the script and assign it to a device group.
Alternatively, use Azure Automation to execute the script on managed machines:

Set up a Runbook in Azure Automation and upload the script.
Assign the Runbook to execute on target VMs.
Run Locally for Testing:

To test locally, open PowerShell as an Administrator and run the script.
Validation
Check Registry Settings:

Navigate to HKEY_CURRENT_USER\Control Panel\Desktop using regedit and verify that:
ScreenSaveTimeOut is 3600.
ScreenSaveActive is 1.
ScreenSaverIsSecure is 1.
Test Lock Behavior:

Wait for 60 minutes or lock the machine manually to confirm the password is required upon resume.


Creating labels in Microsoft Purview can help you classify and protect data effectively. Below is a PowerShell script to create sensitivity labels in Microsoft Purview using the Microsoft Graph API and the required modules.

Prerequisites:
Azure AD App Registration: Ensure you’ve registered an application in Azure AD with the necessary permissions to manage sensitivity labels.
Permissions: The app should have delegated or application permissions for SecurityLabels.ReadWrite.All in Microsoft Graph.
Microsoft.Graph Module: Install the Microsoft Graph PowerShell SDK (Install-Module Microsoft.Graph).
