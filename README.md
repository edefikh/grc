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
