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
