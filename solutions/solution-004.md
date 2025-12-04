# Modernize a .NET Application

## Goal

Modernize the Contoso University .NET Framework application to .NET 9 and deploy it to Azure App Service using GitHub Copilot's AI-powered code transformation capabilities.

## Actions

**Setup and Preparation:**
1. Navigate to `https://github.com/crgarcia12/migrate-modernize-lab` and click the "Fork" button in the top-right corner

![Fork the repository](media/fork-button.png)

2. Select your account as the owner and click "Create fork"

![Create fork dialog](media/create-fork.png)

3. Once the fork is created, click the "Code" button and copy your forked repository URL

![Copy clone URL](media/clone-url.png)

4. Open Visual Studio 2022
5. Select "Clone a repository" and paste your forked repository URL
6. Navigate to Solution Explorer and locate the ContosoUniversity project
7. Rebuild the project to verify it compiles successfully

![Application running in IIS Express](media/0030.png)

**Assess and Upgrade to .NET 9:**

8. Right-click the ContosoUniversity project and select "Modernize"

![Right-click Modernize menu](media/0040.png)

9. Sign in to GitHub Copilot if prompted
10. Select Claude Sonnet 4.5 as the model
11. Click "Upgrade to a newer .NET version"
12. Allow GitHub Copilot to analyze the codebase
13. Review the upgrade plan when presented
14. Allow operations when prompted during the upgrade process
15. Wait for the upgrade to complete (marked by `dotnet-upgrade-report.md` appearing)

**Migrate to Azure:**

16. Right-click the project again and select "Modernize"
17. Click "Migrate to Azure" in the GitHub Copilot Chat window
18. Wait for GitHub Copilot to assess cloud readiness

**Resolve Cloud Readiness Issues:**
19. Open the `dotnet-upgrade-report.md` file

![Upgrade report with cloud readiness issues](media/0080.png)

20. Review the Cloud Readiness Issues section
21. Click "Migrate from Windows AD to Microsoft Entra ID"
22. Allow GitHub Copilot to implement the authentication changes
23. Ensure all mandatory tasks are resolved
24. Review the changes made to authentication configuration

**Deploy to Azure:**

25. Allow GitHub Copilot to complete the Azure App Service deployment
26. Verify the deployment succeeds
27. Test the deployed application in Azure

## Success Criteria

- ✅ ContosoUniversity solution cloned and builds successfully
- ✅ Application upgraded from .NET Framework to .NET 9
- ✅ Upgrade report generated showing all changes and issues
- ✅ Authentication migrated from Windows AD to Microsoft Entra ID
- ✅ All mandatory cloud readiness issues resolved
- ✅ Application successfully deployed to Azure App Service
- ✅ Deployed application is accessible and functional

## Learning Resources

- [GitHub Copilot for Visual Studio](https://learn.microsoft.com/visualstudio/ide/visual-studio-github-copilot-extension)
- [Modernize .NET Applications](https://learn.microsoft.com/dotnet/architecture/modernize-with-azure-containers/)
- [Migrate to .NET 9](https://learn.microsoft.com/dotnet/core/migration/)
- [Azure App Service for .NET](https://learn.microsoft.com/azure/app-service/quickstart-dotnetcore)
- [Microsoft Entra ID Authentication](https://learn.microsoft.com/azure/active-directory/develop/quickstart-v2-aspnet-core-webapp)
