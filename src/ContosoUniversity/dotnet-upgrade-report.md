# .NET Upgrade & Azure Migration Report

**Project:** ContosoUniversity  
**Date:** 2025  
**Source Framework:** .NET Framework 4.8 / ASP.NET MVC 5  
**Target Framework:** .NET 9.0 / ASP.NET Core  

---

## Upgrade Summary

The ContosoUniversity application has been successfully upgraded from .NET Framework 4.8 to .NET 9.0 and modernized for Azure deployment.

### Changes Applied

| Area | Change |
|---|---|
| Project format | Old-style `.csproj` → SDK-style `<Project Sdk="Microsoft.NET.Sdk.Web">` |
| Entry point | `Global.asax` + `App_Start/` → `Program.cs` with minimal hosting model |
| Configuration | `Web.config` → `appsettings.json` + environment variables |
| Dependency Injection | Manual instantiation → ASP.NET Core built-in DI container |
| ORM | Entity Framework 6 → Entity Framework Core 9.0 |
| Bundling | `BundleConfig` / `@Scripts.Render` → direct `<script>`/`<link>` tags |
| HTTP Abstractions | `System.Web` / `HttpPostedFileBase` → `Microsoft.AspNetCore.Http` / `IFormFile` |
| Controller base | `System.Web.Mvc.Controller` → `Microsoft.AspNetCore.Mvc.Controller` |

---

## Cloud Readiness Assessment

### ✅ Resolved Issues (Mandatory)

#### 1. Windows Active Directory Authentication → Microsoft Entra ID

**Severity:** Mandatory  
**Status:** ✅ Resolved  

**Description:**  
The original application relied on Windows Integrated Authentication (Windows AD), which is not supported in Azure App Service. The application has been migrated to use Microsoft Entra ID (formerly Azure Active Directory) via `Microsoft.Identity.Web`.

**Changes made:**
- Added `Microsoft.Identity.Web` and `Microsoft.Identity.Web.UI` NuGet packages
- Configured OpenID Connect authentication middleware in `Program.cs`
- Added `AzureAd` configuration section to `appsettings.json`
- Controllers now require authentication by default (global `[Authorize]` policy)
- `HomeController` marked `[AllowAnonymous]` for public pages (Index, About, Contact)
- Navigation bar updated with Sign In / Sign Out links via `_LoginPartial.cshtml`
- `BaseController` now reads the authenticated user's display name for audit notifications

#### 2. LocalDB Connection String → Azure SQL support

**Severity:** Mandatory  
**Status:** ✅ Resolved  

**Description:**  
The `appsettings.json` connection string used `(LocalDb)\MSSQLLocalDB` which only works on developer machines. The Azure deployment uses the `ConnectionStrings__DefaultConnection` environment variable (Azure App Service Application Settings), allowing the production connection string to be set without modifying code.

**Changes made:**
- `appsettings.Production.json` created with empty connection string (overridden by Azure App Settings)
- `Program.cs` reads connection string from `IConfiguration` as before (supports env var override)

---

### ⚠️ Informational Issues (Non-blocking)

#### 3. MSMQ Private Queues → In-Memory Queue

**Severity:** Informational  
**Status:** ✅ Already resolved during .NET upgrade  

**Description:**  
The original application used MSMQ (`System.Messaging`) for notifications. MSMQ is Windows-only and not available in Azure. During the .NET upgrade, the notification system was replaced with `InMemoryMessageQueue`.

**Note for production:** Consider migrating to **Azure Service Bus** for durable, scalable messaging in production.

#### 4. File Upload Storage → Azure Blob Storage

**Severity:** Informational  
**Status:** ⚠️ Pending  

**Description:**  
The `CoursesController` saves uploaded syllabi to the local file system (`wwwroot/Uploads`). Local file system storage is ephemeral in Azure App Service (lost on restarts/scaling). Consider migrating to **Azure Blob Storage**.

**Recommended action:** Add `Azure.Storage.Blobs` package and update `CoursesController.UploadSyllabus` to write to Blob Storage.

---

## Azure Deployment Configuration

### Target: Azure App Service

The application is configured for deployment to **Azure App Service** (Linux or Windows, .NET 9 runtime).

**Required Azure resources:**
| Resource | Purpose |
|---|---|
| Azure App Service | Host the ASP.NET Core application |
| Azure SQL Database | Production database (replace LocalDB) |
| Microsoft Entra ID App Registration | OAuth2/OIDC identity provider |

### Required Azure App Service Application Settings

Configure these in Azure Portal → App Service → Configuration → Application Settings:

| Setting Name | Value |
|---|---|
| `ConnectionStrings__DefaultConnection` | Azure SQL connection string |
| `AzureAd__TenantId` | Your Entra ID tenant ID |
| `AzureAd__ClientId` | Your app registration client ID |
| `ASPNETCORE_ENVIRONMENT` | `Production` |

### Microsoft Entra ID App Registration

1. Register a new application in [Azure Portal → Entra ID → App Registrations](https://portal.azure.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/RegisteredApps)
2. Set **Redirect URI**: `https://<your-app-name>.azurewebsites.net/signin-oidc`
3. Set **Logout URL**: `https://<your-app-name>.azurewebsites.net/signout-callback-oidc`
4. Copy **Application (client) ID** → `AzureAd__ClientId`
5. Copy **Directory (tenant) ID** → `AzureAd__TenantId`

---

## CI/CD Pipeline

A GitHub Actions workflow has been created at `.github/workflows/azure-app-service.yml` that:
1. Triggers on pushes to `upgrade/dotnet9` and `main` branches
2. Builds and publishes the application with `dotnet publish --configuration Release`
3. Deploys to Azure App Service using `AZURE_WEBAPP_PUBLISH_PROFILE` secret

**Setup steps:**
1. In Azure Portal, download the **publish profile** for your App Service
2. In GitHub → Settings → Secrets, add secret `AZURE_WEBAPP_PUBLISH_PROFILE` with the publish profile content
3. Update `AZURE_WEBAPP_NAME` in the workflow file with your actual App Service name

---

## Build Status

```
Build succeeded.
    0 Warning(s)
    0 Error(s)
```

All mandatory cloud readiness issues have been resolved. The application is ready for deployment to Azure App Service.
