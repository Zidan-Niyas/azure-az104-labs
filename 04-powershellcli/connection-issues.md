# Connecting Azure PowerShell to My Subscription: Troubleshooting Log

## Summary

I couldn't connect Azure PowerShell to my subscription and create resources from the terminal. Three problems were stacked on top of each other:

| # | Problem | Cause | Fix |
|---|---------|-------|-----|
| 1 | Device code sign-in failed (error `530035`) | Security defaults block the device code sign-in method | Disabled security defaults (turned out to be optional, see takeaways) |
| 2 | `New-AzResourceGroup` failed with an MFA error | Azure requires MFA to create, update or delete resources from PowerShell/CLI | Register MFA and sign in with it |
| 3 | Couldn't register MFA on my Gmail account | Gmail login is a personal Microsoft account, not a work/school account | Created a new cloud-only user (`LabAdmin`) in my directory and made it Owner |

> Tenant and subscription IDs below are placeholders (`<tenant-id>`, `<subscription-id>`).

## Step by step

### 1. Device code sign-in blocked

Signing in with `Connect-AzAccount -UseDeviceAuthentication` showed "You don't have access to this" with error `530035` ("Access has been blocked by security defaults").

**Cause:** Security defaults block the device code flow.

**What I did:** Disabled security defaults:

`Microsoft Entra ID → Overview → Properties → Manage security defaults → Disabled`

After that, this connected successfully:

```powershell
Connect-AzAccount -Tenant "<tenant-id>" -UseDeviceAuthentication
```

### 2. Creating a resource group failed: MFA required

```powershell
New-AzResourceGroup -Name $ResourceGroupName -Location $Location
```

```text
Resource 'rg-dev-eus' was disallowed by Azure: You are receiving this error because
you tried to create, update or delete Azure resources without authenticating through MFA.
User accounts must be authenticated through MFA to manage your resources.
To resolve this error, go to https://aka.ms/MFAforAzure
```

**Cause:** Azure's mandatory MFA applies to create, update and delete operations from Azure PowerShell and CLI. Read-only commands like `Get-AzTenant` worked without MFA, which is why the sign-in looked fine. This requirement is separate from security defaults and can't be turned off.

### 3. Couldn't set up MFA on my Gmail account

When I tried to register MFA on my existing account, I got:

```text
Selected user account does not exist in tenant 'Microsoft Services' and cannot access
the application '...' in that tenant. The account needs to be added as an external
user in the tenant first.
```

**Cause:** My Gmail address is a **personal Microsoft account**. It appears in my directory as an external (`#EXT#`) user, and the Entra security-info page, which is meant for work/school accounts, routes it to the default "Microsoft Services" tenant, where it doesn't exist.

### 4. Fix: create a cloud-only user

1. Create the user: `Microsoft Entra ID → Users → New user → Create new user`
   - Username: `labadmin@<your-domain>.onmicrosoft.com`
2. Give it access to the subscription:
   `Subscriptions → Personal-Lab → Access control (IAM) → Add → Add role assignment → Owner → LabAdmin → Review + assign`
3. Sign in as `LabAdmin` in an InPrivate window and register MFA by adding **Microsoft Authenticator** at https://mysignins.microsoft.com/security-info

### 5. Reconnect as the new user

```powershell
Disconnect-AzAccount
Clear-AzContext -Force
Connect-AzAccount -Tenant "<tenant-id>" -Subscription "<subscription-id>"
```

Selected `LabAdmin` → entered the code from Microsoft Authenticator → signed in successfully as a user with Owner access to the subscription.

### 6. Result

Running `createResourceGroup.ps1` created the resource group.

## Key takeaways

- **MFA is mandatory for creating, updating or deleting resources from PowerShell/CLI**, whether or not security defaults are on. Read-only commands work without it.
- **Don't use a personal Microsoft account (Gmail/Outlook) for labs.** Create a cloud-only user in your own directory and give it a role on the subscription.
- **I didn't actually need device code.** `az login` (browser sign-in) worked while security defaults were still on, so disabling them wasn't necessary for these labs.
- **Azure PowerShell and Azure CLI keep separate logins.** Being signed in with `az login` doesn't sign you in for `New-AzResourceGroup`. You also need `Connect-AzAccount`.
- **If `Get-AzSubscription` is empty after signing in**, the user has no role on the subscription. Add one under IAM and sign in again.