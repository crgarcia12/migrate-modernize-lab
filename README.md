

# Azure Migration & Modernization MicroHack

This MicroHack scenario walks through a complete migration and modernization journey using Azure Migrate and GitHub Copilot. The experience covers discovery, assessment, business case development, and application modernization for both .NET and Java workloads.

## MicroHack Context

This MicroHack provides hands-on experience with the entire migration lifecycle - from initial discovery of on-premises infrastructure through to deploying modernized applications on Azure. You'll work with a simulated datacenter environment and use AI-powered tools to accelerate modernization.

**Key Technologies:**
- Azure Migrate for discovery and assessment
- GitHub Copilot for AI-powered code modernization
- Azure App Service for hosting modernized applications

## Environment creation

Make sure you have Azure PowerShell installed and authenticated to your Azure subscription.
```PowerShell
Install-Module Az
Connect-AzAccount
```

Please note:
- You need Administrator rights to install Azure PowerShell. If it's not an option for you, install it for the current user using `Install-Module Az -Scope CurrentUser`
- It takes some time (around 10 minutes) to install. Please, complete this task in advance.
- If you have multiple Azure subscriptions avaialble for your account, use `Connect-AzAccount -TenantId YOUR-SUBSCRIPTION-ID` to authenticate against specific one.

Once you are authenticated to Azure via PowerShell, run the following script to create the lab environment:

```Powershell
# Download and execute the environment creation script directly from GitHub
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-creation/New-MicroHackEnvironment.ps1" -OutFile "$env:TEMP\New-MicroHackEnvironment.ps1"
& "$env:TEMP\New-MicroHackEnvironment.ps1"
```

## Start your lab

**Business Scenario:**
You're working with an organization that has on-premises infrastructure running .NET and Java applications. Your goal is to assess the environment, build a business case for migration, and modernize applications using best practices and AI assistance.

## Objectives

After completing this MicroHack you will:

- Understand how to deploy and configure Azure Migrate for infrastructure discovery
- Know how to build compelling business cases using Azure Migrate data
- Analyze migration readiness across servers, databases, and applications
- Use GitHub Copilot to modernize .NET Framework applications to modern .NET
- Leverage AI to migrate Java applications from AWS dependencies to Azure services
- Deploy modernized applications to Azure App Service

## MicroHack Challenges

### General Prerequisites

This MicroHack has specific prerequisites to ensure optimal learning experience.

**Required Access:**
- Azure Subscription with Contributor permissions
- GitHub account with GitHub Copilot access

**Required Software:**
- Visual Studio 2022 (for .NET modernization)
- Visual Studio Code (for Java modernization)
- Docker Desktop
- Java Development Kit (JDK 8 and JDK 21)
- Maven

**Azure Resources:**
The lab environment provides:
- Resource Group: `on-prem`
- Hyper-V host VM with nested virtualization
- Pre-configured virtual machines simulating datacenter workloads
- Azure Migrate project with sample data

**Estimated Time:**
- Challenge 1: 45-60 minutes
- Challenge 2: 30-45 minutes
- Challenge 3: 45-60 minutes
- Challenge 4: 60-75 minutes
- **Total: 3-4 hours**

---

## Challenge 1 - Prepare a Migration Environment

### Goal

Set up Azure Migrate to discover and assess your on-premises infrastructure. You'll install and configure an appliance that collects data about your servers, applications, and dependencies.

### Actions

**Understand Your Environment:**
1. Access the Azure Portal using the provided credentials
2. Navigate to the `on-prem` resource group
3. Connect to the Hyper-V host VM (`lab@lab.LabInstance.Id-vm`)
4. Explore the nested VMs running inside the host

![Hyper-V Manager showing nested VMs](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00915.png)

5. Verify that applications are running (e.g., http://172.100.2.110)

![Application running in nested VM](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0013.png)

**Create Azure Migrate Project:**  

6. Create a new Azure Migrate project in the Azure Portal
7. Name your project (e.g., `migrate-prj`)
8. Select an appropriate region (e.g., Canada)

![Azure Migrate Discovery page](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0090.png)

**Deploy the Azure Migrate Appliance:**

9. Generate a project key for the appliance
10. Download the Azure Migrate appliance VHD file

![Download appliance VHD](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0091.png)

11. Extract the VHD inside your Hyper-V host (F: drive recommended)

![Extract VHD to F drive](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00914.png)

12. Create a new Hyper-V VM using the extracted VHD:
    - Name: `AZMAppliance`
    - Generation: 1
    - RAM: 16384 MB
    - Network: NestedSwitch

![Create new VM in Hyper-V](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0092.png)

![Select VHD file](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00925.png)

13. Start the appliance VM

**Configure the Appliance:**

14. Accept license terms and set appliance password: `Demo!pass123`

![Send Ctrl+Alt+Del to appliance](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0093.png)

15. Wait for Azure Migrate Appliance Configuration to load in browser

![Appliance Configuration Manager](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00932.png)

16. Paste and verify your project key
17. Login to Azure through the appliance interface

![Login to Azure](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00945.png)

18. Add Hyper-V host credentials (username: `adminuser`, password: `demo!pass123`)

![Add credentials](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00946.png)

19. Add discovery source with Hyper-V host IP: `172.100.2.1`

![Add discovery source](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00948.png)

20. Add credentials for Windows, Linux, SQL Server, and PostgreSQL workloads

![Add workload credentials](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/009491.png)

21. Start the discovery process

### Success Criteria

- ✅ You have successfully connected to the Hyper-V host VM
- ✅ You can access nested VMs and verify applications are running
- ✅ Azure Migrate project has been created
- ✅ Appliance is deployed and connected to Azure Migrate

![Appliance in Azure Portal](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00951.png)

- ✅ All appliance services show as running in Azure Portal

![Appliance services running](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00952.png)

- ✅ Discovery process has started collecting data from your environment

### Learning Resources

- [Azure Migrate Overview](https://learn.microsoft.com/azure/migrate/migrate-services-overview)
- [Azure Migrate Appliance Architecture](https://learn.microsoft.com/azure/migrate/migrate-appliance-architecture)
- [Hyper-V Discovery with Azure Migrate](https://learn.microsoft.com/azure/migrate/tutorial-discover-hyper-v)
- [Azure Migrate Discovery Best Practices](https://learn.microsoft.com/azure/migrate/best-practices-assessment)

---

## Challenge 2 - Analyze Migration Data and Build a Business Case

### Goal

Transform raw discovery data into actionable insights by cleaning data, grouping workloads, creating business cases, and performing technical assessments to guide migration decisions.

### Actions

**Review Data Quality:**
1. Navigate to your Azure Migrate project overview

![Azure Migrate project overview](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0095.png)

2. Open the Action Center to identify data quality issues

![Action Center with data issues](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/01005.png)

3. Review common issues (powered-off VMs, connection failures, missing performance data)
4. Understand the impact of data quality on assessment accuracy

**Group Workloads into Applications:**

5. Navigate to Applications page under "Explore applications"
6. Create a new application definition for "ContosoUniversity"
7. Set application type as "Custom" (source code available)
8. Link relevant workloads to the application
9. Filter and select all ContosoUniversity-related workloads

![Link workloads to application](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/01002.png)

10. Set criticality and complexity ratings

**Build a Business Case:**

11. Navigate to Business Cases section
12. Create a new business case named "contosouniversity"
13. Select "Selected Scope" and add ContosoUniversity application
14. Choose target region: West US 2
15. Configure Azure discount: 15%
16. Build the business case and wait for calculations

**Analyze an Existing Business Case:**

17. Open the pre-built "businesscase-for-paas" business case
18. Review annual cost savings and infrastructure scope
19. Examine current on-premises vs future Azure costs
20. Analyze CO₂ emissions reduction estimates
21. Review migration strategy recommendations (Rehost, Replatform, Refactor)
22. Examine Azure cost assumptions and settings

**Perform Technical Assessments:**

23. Navigate to Assessments section

![Assessments overview](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/01007.png)

24. Open the "businesscase-businesscase-for-paas" assessment

![Assessment details](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/01008.png)

25. Review recommended migration paths (PaaS preferred)
26. Analyze monthly costs by migration approach
27. Review Web Apps to App Service assessment details
28. Identify "Ready with conditions" applications
29. Review ContosoUniversity application details
30. Check server operating system support status
31. Identify out-of-support and extended support components
32. Review PostgreSQL database version information
33. Examine software inventory on each server

![Software inventory details](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/01010.png)

**Complete Knowledge Checks:**

34. Find the count of powered-off Linux VMs

![Filter powered-off Linux VMs](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/01001.png)

35. Count Windows Server 2016 instances

![Windows Server 2016 count](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/01004.png)

36. Calculate VM costs for the ContosoUniversity application

![Application costs](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/01011.png)

37. Identify annual cost savings from the business case
38. Determine security cost savings

### Success Criteria

- ✅ You understand data quality issues and their impact on assessments
- ✅ Applications are properly grouped with related workloads
- ✅ Business case successfully created showing cost analysis and ROI
- ✅ You can navigate between business cases and technical assessments
- ✅ Migration strategies (Rehost, Replatform, Refactor) are clearly understood
- ✅ Application readiness status is evaluated for cloud migration
- ✅ Out-of-support components are identified for remediation
- ✅ You can answer specific questions about your environment using Azure Migrate data

### Learning Resources

- [Azure Migrate Business Case Overview](https://learn.microsoft.com/azure/migrate/concepts-business-case-calculation)
- [Azure Assessment Best Practices](https://learn.microsoft.com/azure/migrate/best-practices-assessment)
- [Application Discovery and Grouping](https://learn.microsoft.com/azure/migrate/how-to-create-group-machine-dependencies)
- [Migration Strategies: 6 Rs Explained](https://learn.microsoft.com/azure/cloud-adoption-framework/migrate/azure-best-practices/contoso-migration-refactor-web-app-sql)

---

## Challenge 3 - Modernize a .NET Application

### Goal

Modernize the Contoso University .NET Framework application to .NET 9 and deploy it to Azure App Service using GitHub Copilot's AI-assisted tooling. This challenge demonstrates end-to-end .NET application modernization, transforming a legacy Windows-dependent application into a modern, containerized, cloud-native solution.

### About Contoso University

**Contoso University** is a university management application that showcases common patterns found in enterprise .NET applications. It's an ideal candidate for modernization as it contains traditional ASP.NET MVC architecture, Windows-specific dependencies (MSMQ, local file system), and .NET Framework 4.8 codebase.

### Actions

1. Fork `https://github.com/marconsilva/ghcp-app-mod-dotnet-samples/`, clone your fork in Visual Studio 2022
2. Confirm the ContosoUniversity project builds successfully
3. Use the Visual Studio "Modernize" flow to sign in to GitHub Copilot and select Claude Sonnet 4.5
4. Run the guided upgrade workflow through all stages until deployment is complete
5. Follow the detailed step-by-step guide below

> **💡 Tip**: The repository includes multiple branches representing different stages of modernization. Use them to compare your progress or troubleshoot issues.

### Success Criteria

- ✅ ContosoUniversity solution is forked, cloned, and builds locally
- ✅ Complete assessment report generated with upgrade plan
- ✅ Application upgraded from .NET Framework to .NET 9 
- ✅ All mandatory cloud readiness issues resolved (authentication, MSMQ, file storage)
- ✅ Security vulnerabilities identified and patched (CVE check completed)
- ✅ Unit tests implemented with 70%+ code coverage
- ✅ Application containerized with optimized Dockerfile
- ✅ Azure App Service deployment completes successfully 
- ✅ Modernized application runs in Azure with all functionality working

### Pre-requirements

* **Visual Studio 2022** (17.8 or later) with the following workloads:
  - ASP.NET and web development
  - .NET desktop development
* **GitHub Copilot subscription** (Individual, Business, or Enterprise)
* **GitHub account** with access to public repositories
* **.NET 9 SDK** installed ([Download here](https://dotnet.microsoft.com/download/dotnet/9.0))
* **Docker Desktop** installed and running (for containerization stage)
* **Azure subscription** with Contributor access to a resource group
* **Azure Developer CLI (azd)** installed ([Installation guide](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd))
* **Git** configured with your GitHub credentials
* Basic familiarity with .NET web applications and Visual Studio

### Understanding the Repository Structure

The sample repository uses a **branch-per-stage** approach to demonstrate the modernization journey:

| Branch | Stage | Description |
|--------|-------|-------------|
| `main` | **Legacy Application** | Original .NET Framework 4.8 codebase - starting point |
| `upgrade-to-NET9-assess` | **Assessment** | Analysis results, compatibility reports, and modernization recommendations |
| `upgrade-to-NET9-upgrade` | **Framework Upgrade** | Upgrade to .NET 9, project file modernization (SDK-style) |
| `upgrade-to-NET9-cve-check` | **Security Scan** | Vulnerability assessment and package updates |
| `upgrade-to-NET9-unit-test` | **Testing** | Unit test implementation and test coverage |
| `upgrade-to-NET9-containerize` | **Containerization** | Dockerfile, container optimization, multi-stage builds |

You can compare your work with these branches using:
```bash
git diff main upgrade-to-NET9-assess    # See assessment changes
git diff upgrade-to-NET9-assess upgrade-to-NET9-upgrade    # See upgrade changes
```

### Detailed Step-by-Step Guide

Work through these stages sequentially. Each stage builds upon the previous one, gradually transforming the legacy application into a modern, cloud-native solution.


This comprehensive guide walks you through each stage of modernizing the Contoso University application using the **GitHub Copilot App Modernization Plugin**. Each stage builds upon the previous one, gradually transforming the legacy .NET Framework application into a modern, cloud-native solution.

> **💡 Important**: Work through these stages sequentially. Each stage has dependencies on the previous stages' outputs and configurations.

---

### 🔍 Stage 1: Assessment & Planning

**Objective**: Analyze the current application architecture, identify modernization opportunities, and create a comprehensive upgrade plan.

**Why This Matters**: A thorough assessment prevents costly mistakes by identifying potential blockers, compatibility issues, and required code changes before you begin the actual migration work.

#### Step-by-Step Instructions

**1.1 Open Your Solution**
   - Launch **Visual Studio 2022**
   - Open `ContosoUniversity.sln` from the repository
   - Ensure you're on the `main` branch (check the Git branch indicator in the status bar)

**1.2 Initiate the Modernization Workflow**
   - In **Solution Explorer**, right-click on the solution name (not a project)
   - Select **"Modernize"** from the context menu to open the GitHub Copilot modernization chat window
   
   ![Opening the modernization chat](/img/mod_chat_rightclick.png)

**1.3 Start the Assessment**
   - In the modernization chat window, select **"Upgrade to a newer version of .NET"**
   - This initiates an AI-powered analysis of your entire solution
   
   ![Starting the modernization process](/img/mod_chat_start.png)

**1.4 Review the Generated Upgrade Plan**
   - Navigate to `.github/upgrades/` folder in Solution Explorer
   - Open the generated `dotnet-upgrade-plan.md` file
   - This document contains:
     - 📊 Current state analysis
     - 🎯 Recommended target framework (.NET 8 or .NET 9)
     - ⚠️ Potential breaking changes
     - 📦 Package compatibility report
     - 🔄 Migration strategy with phases
     - ⏱️ Estimated effort and complexity

**1.5 Customize the Plan (Optional but Recommended)**
   - Review Copilot's recommendations carefully
   - If you want to modify the target framework version, ask in the chat:
     ```
     I want to target .NET 9 instead of .NET 8. Please update the upgrade plan accordingly.
     ```
   - You can also request specific changes:
     ```
     Include a plan for migrating from MSMQ to Azure Service Bus
     Add assessment for file system to Azure Blob Storage migration
     ```

**1.6 Save Your Assessment**
   - Consider creating a new branch for your modernization work:
     ```bash
     git checkout -b upgrade-to-NET9-assess
     git add .github/upgrades/
     git commit -m "Add .NET 9 upgrade assessment and plan"
     ```

> **⚠️ Critical**: Read both the chat window output AND the generated markdown file thoroughly. The chat provides contextual explanations, while the markdown file serves as your roadmap for all subsequent stages. Understanding the "why" behind each recommendation is crucial for making informed decisions during the upgrade.

> **💡 Pro Tip**: If this is your first .NET modernization, read the entire plan before proceeding. Highlight sections that might affect your application's critical functionality.

**Expected Outcomes**:
- ✅ Complete assessment report
- ✅ Documented upgrade strategy
- ✅ List of dependencies requiring updates
- ✅ Risk mitigation strategies identified
- ✅ Understanding of the work ahead

---

### ⬆️ Stage 2: Framework Upgrade

**Objective**: Migrate the project from .NET Framework 4.8 to .NET 9, converting to SDK-style project format and resolving initial compatibility issues.

**Why This Matters**: The framework upgrade is the foundation of modernization. It unlocks performance improvements, modern language features, cross-platform capabilities, and prepares your application for containerization and cloud deployment.

#### Step-by-Step Instructions

**2.1 Ensure Assessment is Complete**
   - Verify you have reviewed the upgrade plan from Stage 1
   - Make sure you understand which packages need updating
   - Have the `dotnet-upgrade-plan.md` file accessible for reference

**2.2 Initiate the Upgrade Process**
   - In the GitHub Copilot chat window, type:
     ```
     Continue with upgrade to .NET 9
     ```
   - Copilot will begin implementing the changes outlined in your plan
   - A progress tracking window will appear showing each stage of the upgrade

**2.3 Monitor Progress**
   - Watch the progress window in the Visual Studio main editor area
   - The window displays:
     - ✅ Completed steps (in green)
     - 🔄 Current step being processed
     - ⏳ Pending steps
     - ⚠️ Issues requiring investigation
   
   ![Tracking upgrade progress](/img/mod_chat_upgrade_iterate.png)

**2.4 Handle Command Execution Prompts**
   - Copilot will request permission to execute various commands (dotnet CLI commands, file operations, etc.)
   - **Options for approving commands**:
     - **"Allow Once"**: Approve individual commands (safest, but more clicks)
     - **"Allow in this Session"**: Auto-approve for the current VS session
     - **"Allow Always"**: Auto-approve for future sessions (use with caution)
   
   ![Allowing command execution](/img/mod_chat_upgrade_iterate_allowAlways.png)

   > **⚠️ Security Note**: Always read the command before approving. Look for operations that modify critical files, install packages, or make system changes. Use "Allow Always" only if you trust the source and understand the implications.

**2.5 Respond to Copilot's Questions**
   - During the upgrade, Copilot may pause to ask for your input on:
     - Package version conflicts
     - Breaking API changes requiring decisions
     - Alternative approaches for deprecated features
     - Configuration preferences
   - Provide clear, specific answers in the chat window
   - If unsure, ask Copilot for recommendations:
     ```
     What would you recommend for [specific issue]?
     What are the pros and cons of each approach?
     ```

**2.6 Iteratively Resolve Issues**
   - The progress window will highlight issues marked for "Investigation"
   - For each issue:
     1. Review the error message or warning
     2. Ask Copilot for resolution strategies
     3. Approve the suggested fix
     4. Wait for Copilot to implement and test
     5. Move to the next issue
   
   ![Completed upgrade progress](/img/mod_chat_upgrade_iterate_Progress_done.png)

   - Continue this cycle until all issues are resolved
   - This may require several rounds of iteration—be patient!

**2.7 Verify the Upgrade**
   - Once Copilot reports completion, perform these verification steps:
   
   **Build Verification**:
   ```bash
   # Clean and rebuild the solution
   dotnet clean
   dotnet build
   ```
   
   **Configuration Check**:
   - Open the `.csproj` file and verify:
     ```xml
     <Project Sdk="Microsoft.NET.Sdk.Web">
       <PropertyGroup>
         <TargetFramework>net9.0</TargetFramework>
       </PropertyGroup>
     </Project>
     ```

**2.8 Run the Application**
   - Press **F5** to start debugging
   - Test core functionality:
     - ✅ Application launches without errors
     - ✅ Home page loads
     - ✅ Database connection works
     - ✅ Student, Course, Instructor, and Department pages function correctly
     - ✅ Navigation works as expected

**2.9 Troubleshoot Runtime Issues**
   - If you encounter errors during runtime:
     1. **Copy the complete error message** (including stack trace)
     2. **Return to Copilot chat** and paste the error:
        ```
        I'm getting this runtime error after the upgrade:
        [paste full error message and stack trace]
        
        Please help me diagnose and fix this issue.
        ```
     3. Follow Copilot's debugging recommendations
     4. Test the fix and iterate if needed

**2.10 Save Your Progress**
   ```bash
   # Create a branch for this stage
   git checkout -b upgrade-to-NET9-upgrade
   git add .
   git commit -m "Complete framework upgrade to .NET 9"
   git push origin upgrade-to-NET9-upgrade
   ```

> **💡 Pro Tip**: Take screenshots of any unique issues you encounter and their resolutions. This creates valuable documentation for your team and future projects.

> **📝 Expected Migration Changes**: Copilot will typically convert your project file to SDK-style format, update package references to .NET 9 compatible versions, replace `Web.config` with `appsettings.json`, create `Program.cs` with minimal hosting model, and refactor startup configuration logic.

**Expected Outcomes**:
- ✅ Project converted to SDK-style format
- ✅ Target framework set to .NET 9
- ✅ All packages updated to compatible versions
- ✅ Application compiles without errors
- ✅ Application runs and core features work

---

### 🔒 Stage 3: CVE Check & Security Vulnerability Assessment

**Objective**: Identify and remediate security vulnerabilities in your dependencies, ensuring your modernized application meets current security standards.

**Why This Matters**: Legacy applications often include outdated packages with known security vulnerabilities (CVEs). Modernization is the perfect opportunity to eliminate these risks before deploying to production or the cloud.

#### Step-by-Step Instructions

**3.1 Initiate Security Scan**
   - With your upgraded .NET 9 solution open, return to the GitHub Copilot chat window
   - Request a comprehensive security assessment:
     ```
     Perform a CVE check on my project and run a comprehensive vulnerability assessment
     ```
   - Copilot will scan all NuGet packages and dependencies for known vulnerabilities

**3.2 Understand the Scan Results**
   - Navigate to the generated `vulnerability-assessment.md` file (typically in `.github/security/` or `.github/upgrades/`)
   - The report includes:
     - 🔴 **Critical vulnerabilities**: Immediate action required
     - 🟠 **High severity**: Address before production
     - 🟡 **Medium severity**: Plan remediation
     - 🟢 **Low severity**: Address as time permits
     - 📊 Overall security score

**3.3 Review Vulnerable Packages**
   - The report will list each vulnerable package with:
     - Package name and current version
     - CVE identifiers (e.g., CVE-2024-12345)
     - Severity level and CVSS score
     - Description of the vulnerability
     - Recommended version to upgrade to
     - Whether the vulnerability affects your code

   **Example Entry**:
   ```markdown
   ### System.Text.Json (Current: 7.0.0)
   - CVE: CVE-2024-30105
   - Severity: HIGH
   - CVSS Score: 7.5
   - Issue: Denial of service via malformed JSON
   - Recommendation: Upgrade to 8.0.1 or later
   - Status: Direct dependency - REQUIRES ACTION
   ```

**3.4 Apply Package Updates**
   - Copilot will typically provide update commands or make the changes automatically, but if he needs your command to perform the changes tell him to procceed with the updates as you have already reviewed the vulnerabilities and their impact now.

**3.5 Verify Updates Don't Break Functionality**
   - After applying updates:
     ```bash
     dotnet restore
     dotnet build
     ```
   - Run the application (F5) and test critical paths
   - Pay special attention to features using updated packages


**3.6 Implement Security Best Practices**
   - Copilot may recommend additional security enhancements:
     - Enable HTTPS redirection
     - Configure security headers
     - Implement CORS policies
     - Add authentication/authorization middleware
     - Enable request validation
   
   - Ask for specific guidance:
     ```
     What security best practices should I implement for a production-ready .NET 9 web application?
     ```

**3.7 Document Security Posture**
   - Save the final vulnerability assessment report
   - Document any accepted risks (if unable to update certain packages)
   - Create a tracking issue for any medium/low severity items to address later

**3.8 Commit Security Improvements**
   ```bash
   git checkout -b upgrade-to-NET9-cve-check
   git add .
   git commit -m "Resolve security vulnerabilities and update packages"
   git push origin upgrade-to-NET9-cve-check
   ```

> **⚠️ Important**: Some package updates may introduce breaking API changes. Always test thoroughly after applying security updates, especially for major version bumps.

> **💡 Pro Tip**: Set up automated dependency scanning in your CI/CD pipeline (GitHub Dependabot, Azure Pipelines security scanning) to catch vulnerabilities early in future development.

> **🔍 Alternative Tools**: While Copilot provides excellent guidance, you can also use `dotnet list package --vulnerable` command for a quick CLI-based scan, or integrate tools like OWASP Dependency-Check into your build process.

**Expected Outcomes**:
- ✅ Complete vulnerability assessment report
- ✅ All critical and high-severity CVEs resolved
- ✅ Documentation of security posture
- ✅ Application still functions correctly after updates
- ✅ Security best practices implemented

---

### 🧪 Stage 4: Unit Testing & Quality Assurance

**Objective**: Establish comprehensive test coverage to validate functionality, prevent regressions, and ensure the modernized application behaves identically to the legacy version.

**Why This Matters**: Modernization introduces risk. Unit tests act as a safety net, catching breaking changes before they reach production. They also serve as living documentation of expected behavior and enable confident refactoring.

#### Step-by-Step Instructions

**4.1 Plan Your Testing Strategy**
   - With your solution open, ask Copilot to develop a comprehensive test plan:
     ```
     Create a comprehensive plan to build unit tests that cover all critical aspects of the application, particularly areas affected by the modernization. Include tests for controllers, services, data access, and business logic. Create these tests under a new 'tests' folder with proper structure.
     ```

**4.2 Review the Test Implementation Plan**
   - Copilot will generate a test strategy document (`test-implementation-plan.md` or similar)
   - The plan typically includes:
     - 📋 Test project structure
     - 🎯 Coverage goals (e.g., 80% code coverage)
     - 🧩 Test categories (unit, integration, etc.)
     - 📦 Required testing frameworks and libraries
     - 🔍 Priority areas for testing
     - ⚙️ Mock strategy for external dependencies

**4.3 Create Test Projects**
   - Copilot will typically create test projects such as:
     - `ContosoUniversity.Tests` - Unit tests
     - `ContosoUniversity.IntegrationTests` - Integration tests (optional)

**4.4 Install Testing Dependencies**
   - Copilot will handle this for you automatically

**4.5 Generate Test Classes**
   - Copilot will generate tests for:
     - **Controllers**: HTTP request/response handling, routing, model validation
     - **Services**: Business logic, data transformations
     - **Data Access**: Database operations, queries, migrations
     - **Models**: Validation rules, computed properties
   
**4.6 Review Generated Tests**
   - Examine test structure and coverage, look for classes such as this example for `StudentsController`:
     ```csharp
     public class StudentsControllerTests
     {
         [Fact]
         public async Task Index_ReturnsViewWithStudentList()
         {
             // Arrange
             var mockRepo = new Mock<IStudentRepository>();
             mockRepo.Setup(r => r.GetAllAsync()).ReturnsAsync(GetTestStudents());
             var controller = new StudentsController(mockRepo.Object);
             
             // Act
             var result = await controller.Index();
             
             // Assert
             var viewResult = Assert.IsType<ViewResult>(result);
             var model = Assert.IsAssignableFrom<IEnumerable<Student>>(viewResult.Model);
             Assert.Equal(3, model.Count());
         }
         
         // Additional test methods...
     }
     ```

**4.7 Run Initial Test Suite**
   - Execute tests from Visual Studio Test Explorer (Test → Test Explorer)
   - Or via command line:
     ```bash
     dotnet test --logger "console;verbosity=detailed"
     ```
   
   - Review the output:
     - ✅ Passed tests (green)
     - ❌ Failed tests (red)
     - ⚠️ Skipped tests (yellow)

**4.8 Analyze Test Results**
   - Copilot will generate a `test-implementation-summary.md` with:
     - Total tests created
     - Pass/fail statistics
     - Code coverage percentage by project
     - Areas needing additional coverage
     - Known issues or test failures
   
   - Review code coverage:
     ```bash
     dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=lcov
     ```

**4.9 Address Test Failures**
   - **For each failing test**:
     1. Read the error message carefully
     2. Determine if it's a test issue or application bug
     3. Copy the test failure details to Copilot:
        ```
        This test is failing:
        [paste test name and full error message]
        
        Please help me diagnose whether this is a test implementation issue or an actual bug in the application code.
        ```
     4. Apply the recommended fix
     5. Re-run the test

   - **Common failure categories**:
     - Mock configuration issues
     - Async/await misuse
     - Database context disposal
     - Null reference errors
     - Dependency injection setup

**4.10 Handle Acceptable Failures (Technical Debt)**
   - Some tests may fail due to:
     - Complex external dependencies (third-party APIs)
     - Windows-specific features (MSMQ) not yet migrated
     - Integration points not ready for testing
   
   - Document these with `[Fact(Skip = "reason")]`:
     ```csharp
     [Fact(Skip = "MSMQ functionality will be replaced with Azure Service Bus in Stage 5")]
     public void NotificationService_SendMessage_UsesMessageQueue()
     {
         // Test implementation...
     }
     ```

**4.11 Improve Coverage in Critical Areas**
   - Identify untested or under-tested areas:
     ```
     My coverage report shows only 45% coverage in the Services folder. Generate additional tests to improve coverage of critical business logic.
     ```
   - Focus on:
     - Complex business rules
     - Error handling paths
     - Edge cases and boundary conditions
     - Security-sensitive operations

**4.12 Establish Testing Standards**
   - Document your team's testing guidelines:
     - Naming conventions (e.g., `MethodName_Scenario_ExpectedBehavior`)
     - Arrange-Act-Assert pattern
     - Mock vs. integration testing decisions
     - Code coverage targets
   
   - Add these to a `TESTING.md` file in your repository

**4.13 Commit Your Test Suite**
   ```bash
   git checkout -b upgrade-to-NET9-unit-test
   git add .
   git commit -m "Add comprehensive unit test suite with 75% coverage"
   git push origin upgrade-to-NET9-unit-test
   ```

> **💡 Pro Tip**: Don't aim for 100% coverage. Focus on testing critical business logic and complex algorithms. Simple property getters/setters often don't provide enough value to justify the test maintenance burden.

> **🎯 Coverage Targets**: Industry standards suggest 70-80% code coverage for business applications. Higher coverage is better, but diminishing returns set in above 85%. Focus on meaningful tests over arbitrary metrics.

> **⚠️ Note**: It's acceptable to defer fixing some tests if they depend on infrastructure not yet migrated (like MSMQ → Service Bus). Document these as known items and address them in later stages.

**Expected Outcomes**:
- ✅ Comprehensive test project structure created
- ✅ 70-80% code coverage achieved (or defined target)
- ✅ Critical business logic fully tested
- ✅ All or most tests passing
- ✅ Test failures documented with remediation plans
- ✅ Testing framework integrated into CI/CD
- ✅ Baseline established for future development

---

### 🐳 Stage 5: Containerization

**Objective**: Package the application into an optimized Docker container, enabling consistent deployment across environments and preparing for cloud-native hosting.

**Why This Matters**: Containerization eliminates "works on my machine" problems, simplifies deployment, enables horizontal scaling, and is a prerequisite for modern cloud platforms like Azure Container Apps, Kubernetes, and AWS ECS.

#### Step-by-Step Instructions

**5.1 Verify Prerequisites**
   - Ensure Docker Desktop is installed and running on your machine
   - Verify Docker is accessible:
     ```bash
     docker --version
     docker ps
     ```
   - Confirm your application runs correctly on .NET 9 before containerizing

**5.2 Request Dockerfile Generation**
   - In the GitHub Copilot chat window, provide a detailed request:
     ```
     Help me containerize this .NET 9 application to prepare it for deployment in a cloud-native environment. Please:
     
     1. Create an optimized multi-stage Dockerfile following best practices
     2. Target deployment to Azure Container Apps using AZD (Azure Developer CLI)
     3. Optimize the image size using appropriate base images
     4. Include health checks for container orchestration
     5. Configure for both development and production environments
     6. Ensure all dependencies (database, configuration) are properly handled
     ```

**5.3 Review the Generated Dockerfile**
   - Copilot will create a `Dockerfile` in your solution root
   - **Understand the multi-stage build**:
   
   ```dockerfile
   # Stage 1: Build
   FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
   WORKDIR /src
   
   # Copy and restore dependencies (layer caching optimization)
   COPY ["ContosoUniversity/ContosoUniversity.csproj", "ContosoUniversity/"]
   RUN dotnet restore "ContosoUniversity/ContosoUniversity.csproj"
   
   # Copy source and build
   COPY . .
   WORKDIR "/src/ContosoUniversity"
   RUN dotnet build "ContosoUniversity.csproj" -c Release -o /app/build
   
   # Stage 2: Publish
   FROM build AS publish
   RUN dotnet publish "ContosoUniversity.csproj" -c Release -o /app/publish /p:UseAppHost=false
   
   # Stage 3: Runtime
   FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
   WORKDIR /app
   EXPOSE 8080
   EXPOSE 8081
   
   COPY --from=publish /app/publish .
   ENTRYPOINT ["dotnet", "ContosoUniversity.dll"]
   ```
   
   - **Key benefits of multi-stage build**:
     - ✅ Final image only contains runtime dependencies (smaller size)
     - ✅ SDK tools not included in production image (more secure)
     - ✅ Layer caching speeds up subsequent builds

**5.4 Create .dockerignore File**
   - Copilot should also generate a `.dockerignore` file:
   
   ```
   **/.vs
   **/.vscode
   **/bin
   **/obj
   **/.git
   **/node_modules
   **/*.user
   **/TestResults
   **/.vs/
   **/packages/
   ```
   
   - This prevents unnecessary files from being copied into the container, reducing build time and image size

**5.5 Build the Docker Image**
   - Build your container locally:
     ```bash
     # Navigate to solution root
     cd c:\code\gbb\app-mod-dotnet
     
     # Build with a versioned tag
     docker build -t contoso-university:latest -t contoso-university:1.0.0 .
     ```
   
   - Monitor the build output for:
     - ✅ All stages complete successfully
     - ✅ No warnings about missing files
     - ✅ Final image size reported
   
   - Expected build time: 2-5 minutes on first build (faster on subsequent builds due to layer caching)

**5.6 Verify Image Size**
   - Check the image size:
     ```bash
     docker images contoso-university
     ```
   
   - **Good targets**:
     - **Excellent**: < 250 MB (minimal dependencies)
     - **Good**: 250-500 MB (typical .NET web app)
     - **Acceptable**: 500 MB - 1 GB (complex dependencies)
     - **Needs optimization**: > 1 GB
   
   - If too large, ask Copilot:
     ```
     My Docker image is [size]MB. Please suggest optimizations to reduce the image size.
     ```

**5.7 Create Local Testing Configuration**
   - Copilot may generate a `docker-compose.yml` for local development:
   
   ```yaml
   version: '3.8'
   
   services:
     web:
       build:
         context: .
         dockerfile: Dockerfile
       ports:
         - "8080:8080"
       environment:
         - ASPNETCORE_ENVIRONMENT=Development
         - ConnectionStrings__DefaultConnection=Server=sql;Database=ContosoUniversity;User=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=true
       depends_on:
         - sql
       networks:
         - contoso-network
     
     sql:
       image: mcr.microsoft.com/mssql/server:2022-latest
       environment:
         - ACCEPT_EULA=Y
         - SA_PASSWORD=YourStrong@Passw0rd
       ports:
         - "1433:1433"
       volumes:
         - sql-data:/var/opt/mssql
       networks:
         - contoso-network
   
   volumes:
     sql-data:
   
   networks:
     contoso-network:
       driver: bridge
   ```
   
   - This allows you to test the application with a containerized database

**5.8 Run the Container Locally**
   - **Option A: Run standalone container**:
     ```bash
     docker run -d -p 8080:8080 --name contoso-app contoso-university:latest
     ```
   
   - **Option B: Run with docker-compose** (recommended for testing):
     ```bash
     docker-compose up -d
     ```
   
   - **Verify container is running**:
     ```bash
     docker ps
     ```

**5.9 Test the Containerized Application**
   - Open your browser to `http://localhost:8080`
   - Verify all functionality works:
     - ✅ Home page loads
     - ✅ Database connection succeeds
     - ✅ Student management works
     - ✅ Course and instructor pages function
     - ✅ Static assets (CSS, JS) load correctly
   
   - **Check container logs if issues occur**:
     ```bash
     docker logs contoso-app
     # Or with docker-compose:
     docker-compose logs web
     ```

**5.10 Troubleshoot Common Issues**
   - **Connection string issues**: Ensure database host matches service name in docker-compose
   - **Port conflicts**: Change host port if 8080 is occupied: `-p 8081:8080`
   - **Static files not serving**: Verify `UseStaticFiles()` is in Program.cs
   - **Database not seeding**: Check connection string and database initialization logic
   
   - For any issues, ask Copilot:
     ```
     My containerized application shows this error:
     [paste error from logs]
     
     Please help me diagnose and fix this containerization issue.
     ```

**5.11 Prepare for Azure Deployment**
   - Copilot should generate Azure-specific configuration files:
     - `azure.yaml` - Azure Developer CLI configuration
     - `.azure/` folder - Azure resource definitions
     - Bicep files or ARM templates for infrastructure
   
   - Review these files to understand what resources will be provisioned

**5.12 Tag and Document Your Image**
   - Tag the working image:
     ```bash
     docker tag contoso-university:latest contoso-university:stable
     docker tag contoso-university:latest contoso-university:v1.0.0
     ```
   
   - Document the container in README:
     - Port mappings
     - Required environment variables
     - Volume mounts (if any)
     - Dependencies

**5.13 Clean Up Test Containers**
   ```bash
   # Stop and remove containers
   docker-compose down
   # Or for standalone:
   docker stop contoso-app
   docker rm contoso-app
   ```

**5.14 Commit Containerization Files**
   ```bash
   git checkout -b upgrade-to-NET9-containerize
   git add Dockerfile .dockerignore docker-compose.yml azure.yaml .azure/
   git commit -m "Add Docker containerization with Azure deployment config"
   git push origin upgrade-to-NET9-containerize
   ```

> **💡 Pro Tip**: Use `docker build --progress=plain .` to see detailed output during builds. This is invaluable for troubleshooting build failures.

> **🎯 Health Checks**: Consider adding health check endpoints to your application (`/health`, `/ready`) that container orchestrators can use to determine if your container is healthy and ready to receive traffic.

> **⚠️ Security**: Never hardcode secrets (connection strings, API keys, passwords) in your Dockerfile. Use environment variables or Azure Key Vault for production deployments.

> **📊 Image Optimization Tips**:
> - Use `dotnet publish -c Release` (done in multi-stage builds)
> - Trim unused assemblies with `<PublishTrimmed>true</PublishTrimmed>`
> - Use `alpine` variants of base images when possible
> - Remove development tools and symbols from final image
> - Minimize layers by combining RUN commands where appropriate

**Expected Outcomes**:
- ✅ Optimized multi-stage Dockerfile created
- ✅ .dockerignore file prevents bloat
- ✅ Docker image builds successfully
- ✅ Image size is reasonable (< 500 MB preferred)
- ✅ Application runs correctly in container
- ✅ docker-compose.yml enables local testing
- ✅ Azure deployment configuration generated
- ✅ Container health and logging verified
- ✅ Ready for cloud deployment

---

## 🎯 Next Steps After Modernization

Once you've completed all stages, your application is ready for modern cloud deployment! Consider these follow-up activities:

### Deployment Options
- **Azure Container Apps**: Fully managed container hosting with auto-scaling
- **Azure Kubernetes Service (AKS)**: Full Kubernetes orchestration for complex scenarios
- **Azure App Service**: Traditional web hosting with container support
- **Azure Container Instances**: Simple, on-demand container execution

### Continuous Improvement
- Set up **CI/CD pipelines** (GitHub Actions, Azure DevOps)
- Implement **monitoring and observability** (Application Insights, Azure Monitor)
- Configure **auto-scaling** policies
- Add **feature flags** for gradual rollouts
- Implement **blue-green or canary deployments**

### Cloud-Native Enhancements
- Migrate remaining Windows dependencies to Azure services
- Implement **Azure Service Bus** (replacing MSMQ)
- Use **Azure Blob Storage** (replacing file system)
- Add **Azure Key Vault** for secrets management
- Configure **Azure SQL Database** with geo-replication

### Share Your Success
- Document lessons learned
- Create training materials for your team
- Share your modernization story with the community
- Contribute improvements back to this sample repository

---

<div align="center">

# 🎉 CONGRATULATIONS! 🎉

</div>

---

<div align="center">

### 🏆 **You've Successfully Completed the .NET Modernization Journey!** 🏆

</div>

**You have achieved:**

<table>
<tr>
<td align="center" width="25%">
<img src="https://img.shields.io/badge/Framework-✅_Upgraded-success?style=for-the-badge" alt="Framework Upgraded"/>
<br><b>Framework Upgrade</b><br>
.NET Framework 4.8 → .NET 9
</td>
<td align="center" width="25%">
<img src="https://img.shields.io/badge/Security-✅_Hardened-success?style=for-the-badge" alt="Security Hardened"/>
<br><b>Security Enhanced</b><br>
All CVEs resolved & best practices implemented
</td>
<td align="center" width="25%">
<img src="https://img.shields.io/badge/Testing-✅_Covered-success?style=for-the-badge" alt="Testing Covered"/>
<br><b>Quality Assured</b><br>
Comprehensive test suite & coverage
</td>
<td align="center" width="25%">
<img src="https://img.shields.io/badge/Container-✅_Ready-success?style=for-the-badge" alt="Container Ready"/>
<br><b>Cloud Ready</b><br>
Containerized & deployment-ready
</td>
</tr>
</table>

<br>

<div align="center">

### 🌟 **This is a Significant Achievement!** 🌟

You've transformed legacy code into a **modern, secure, tested, and cloud-native application**.<br>
You're now positioned for success in the **modern cloud-native world**!

</div>

<div align="center">

**🚀 Your application is ready for:**
- ☁️ Cloud deployment (Azure, AWS, GCP)
- 📈 Horizontal scaling and high availability
- 🔄 CI/CD automation
- 🛡️ Enterprise security standards
- 🌍 Cross-platform operation

</div>

<br>

> **💪 What's Next?** Deploy with confidence, implement monitoring, and continue to iterate and improve. The hard work of modernization is behind you—now reap the benefits of modern .NET!

### Learning resources

* https://learn.microsoft.com/visualstudio/ide/visual-studio-github-copilot-extension
* https://learn.microsoft.com/dotnet/architecture/modernize-with-azure-containers/
* https://learn.microsoft.com/dotnet/core/migration/
* https://learn.microsoft.com/azure/app-service/quickstart-dotnetcore
* https://learn.microsoft.com/azure/active-directory/develop/quickstart-v2-aspnet-core-webapp


---

## Challenge 4 - Modernize a Java Application

### Goal

Modernize the Asset Manager Java Spring Boot application for Azure deployment, migrating from AWS dependencies to Azure services using GitHub Copilot App Modernization in VS Code.

### Actions

**Environment Setup:**
1. Navigate to https://github.com/enterprises/skillable-events and authenticate
2. Open Docker Desktop and ensure it's running
3. Open Terminal and run the setup commands:
   ```bash
   mkdir C:\gitrepos\lab
   cd C:\gitrepos\lab
   git clone https://github.com/crgarcia12/migrate-modernize-lab.git
   cd .\migrate-modernize-lab\src\AssetManager\
   code .
   ```
4. Login to GitHub Enterprise from VS Code
5. Install GitHub Copilot App Modernization extension if not present

**Validate Application Locally:**

6. Open Terminal in VS Code (View → Terminal)
7. Run `scripts\startapp.cmd`
8. Wait for Docker containers (RabbitMQ, Postgres) to start
9. Allow network permissions when prompted
10. Verify application is accessible at http://localhost:8080
11. Stop the application by closing console windows

**Perform AppCAT Assessment:**

12. Open GitHub Copilot App Modernization extension in the Activity bar
13. Ensure Claude Sonnet 4.5 is selected as the model
14. Click "Migrate to Azure" to begin assessment
15. Wait for AppCAT CLI installation to complete
16. Review assessment progress in the VS Code terminal
17. Wait for assessment results (9 cloud readiness issues, 4 Java upgrade opportunities)

**Analyze Assessment Results:**

18. Review the assessment summary in GitHub Copilot chat
19. Examine issue prioritization:
    - Mandatory (Purple) - Critical blocking issues
    - Potential (Blue) - Performance optimizations
    - Optional (Gray) - Future improvements
20. Click on individual issues to see detailed recommendations
21. Focus on the AWS S3 to Azure Blob Storage migration finding

**Execute Guided Migration:**

22. Expand the "Migrate from AWS S3 to Azure Blob Storage" task
23. Read the explanation of why this migration is important
24. Click the "Run Task" button to start the migration
25. Review the generated migration plan in the chat window and `plan.md` file
26. Type "Continue" in the chat to begin code refactoring

**Monitor Migration Progress:**

27. Watch the GitHub Copilot chat for real-time status updates
28. Check the `progress.md` file for detailed change logs
29. Review file modifications as they occur:
    - `pom.xml` and `build.gradle` updates for Azure SDK dependencies
    - `application.properties` configuration changes
    - Spring Cloud Azure version properties
30. Allow any prompted operations during the migration

**Validate Migration:**

31. Wait for automated validation to complete:
    - CVE scanning for security vulnerabilities
    - Build validation
    - Consistency checks
    - Test execution
32. Review validation results in the chat window
33. Allow automated fixes if validation issues are detected
34. Confirm all validation stages pass successfully

**Test Modernized Application:**

35. Open Terminal in VS Code
36. Run `scripts\startapp.cmd` again
37. Verify the application starts with Azure Blob Storage integration
38. Test application functionality at http://localhost:8080
39. Confirm no errors related to storage operations

**Optional: Continue Modernization:**

40. Review other migration tasks in the assessment report
41. Execute additional migrations as time permits
42. Track progress through the `plan.md` and `progress.md` files

### Success Criteria

- ✅ Docker Desktop is running and containers are functional
- ✅ Asset Manager application cloned and runs locally
- ✅ AppCAT assessment completed successfully
- ✅ Assessment identifies 9 cloud readiness issues and 4 Java upgrade opportunities
- ✅ AWS S3 to Azure Blob Storage migration executed via guided task
- ✅ Maven/Gradle dependencies updated with Azure SDK
- ✅ Application configuration migrated to Azure Blob Storage
- ✅ All validation stages pass (CVE, build, consistency, tests)
- ✅ Modernized application runs successfully locally
- ✅ Migration changes tracked in dedicated branch for rollback capability

### Learning Resources

- [GitHub Copilot for VS Code](https://code.visualstudio.com/docs/copilot/overview)
- [Azure SDK for Java](https://learn.microsoft.com/azure/developer/java/sdk/)
- [Migrate from AWS to Azure](https://learn.microsoft.com/azure/architecture/aws-professional/)
- [Azure Blob Storage for Java](https://learn.microsoft.com/azure/storage/blobs/storage-quickstart-blobs-java)
- [Spring Cloud Azure](https://learn.microsoft.com/azure/developer/java/spring-framework/)
- [AppCAT Assessment Tool](https://learn.microsoft.com/azure/developer/java/migration/migration-toolkit-intro)

---

## Finish

Congratulations! You've completed the Azure Migration & Modernization MicroHack. 

**What You've Accomplished:**

Throughout this MicroHack, you've gained hands-on experience with the complete migration lifecycle:

### Challenge 1: Migration Preparation

- Explored a simulated datacenter environment with nested Hyper-V VMs
- Created and configured an Azure Migrate project for discovery
- Downloaded, installed, and configured the Azure Migrate appliance
- Connected the appliance to on-premises infrastructure with proper credentials
- Initiated continuous discovery for performance and dependency data collection

### Challenge 2: Migration Analysis & Business Case

- Reviewed and cleaned migration data using Azure Migrate's Action Center
- Grouped related VMs into logical applications (ContosoUniversity)
- Built business cases showing financial justification with cost savings and ROI analysis
- Analyzed technical assessments for cloud readiness and migration strategies
- Evaluated workload readiness across VMs, databases, and web applications
- Navigated migration data to identify issues, costs, and modernization opportunities

### Challenge 3: .NET Application Modernization

- Cloned and configured the Contoso University .NET application repository
- Used GitHub Copilot App Modernization extension in Visual Studio
- Performed comprehensive code assessment for cloud readiness
- Upgraded application from legacy .NET Framework to .NET 9
- Migrated from Windows AD to Microsoft Entra ID authentication
- Resolved cloud readiness issues identified in the upgrade report
- Deployed the modernized application to Azure App Service

### Challenge 4: Java Application Modernization

- Set up local Java development environment with Docker and Maven
- Ran the Asset Manager application locally to validate functionality
- Used GitHub Copilot App Modernization extension in VS Code
- Performed AppCAT assessment for Azure migration readiness (9 cloud readiness issues, 4 Java upgrade opportunities)
- Executed guided migration tasks to modernize the application
- Migrated from AWS S3 to Azure Blob Storage with automated code refactoring
- Validated migration success through automated CVE, build, consistency, and test validation
- Tested the modernized application locally

---

**Skills Acquired:**

- Azure Migrate configuration and management
- Business case development and financial analysis
- AI-powered code modernization with GitHub Copilot
- Migration strategy selection (Rehost, Replatform, Refactor)
- Cloud readiness assessment and remediation
- Azure App Service deployment
- AppCAT assessment for Java applications
- Automated validation and testing workflows

**Key Takeaways:**

This workshop demonstrated the complete migration lifecycle from discovery to deployment:
- **Assessment First**: Azure Migrate provides comprehensive discovery and financial justification before migration
- **AI-Powered Modernization**: GitHub Copilot dramatically accelerates code modernization while maintaining quality
- **Platform Migration**: Successfully migrated dependencies (S3 to Blob Storage, Windows AD to Entra ID) alongside application code
- **Validation at Every Step**: Automated testing ensures functionality is preserved throughout modernization
- **Multiple Technology Stacks**: Experience with both .NET and Java modernization approaches

---

### Next Steps & Learning Paths

**Continue Your Azure Journey:**

- [Azure Migrate Documentation](https://learn.microsoft.com/azure/migrate/) - Deep dive into migration tools and strategies
- [Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/) - Learn enterprise architecture best practices
- [GitHub Copilot for Azure](https://learn.microsoft.com/azure/developer/github-copilot/) - Explore AI-powered development tools

**Hands-On Labs:**

- [Azure Migration Center](https://azure.microsoft.com/migration/) - Additional migration resources and tools
- [Azure Architecture Center](https://learn.microsoft.com/azure/architecture/) - Reference architectures and patterns
- [Microsoft Learn - Azure Migration Path](https://learn.microsoft.com/training/paths/migrate-modernize-innovate-azure/) - Structured learning modules

**Continue Modernization:**

- Explore additional migration scenarios in your own environments
- Practice with other workload types (containers, databases, etc.)
- Experiment with GitHub Copilot for other modernization tasks
- Continue with other migration tasks identified in the assessment reports
- Explore containerization options for deploying to AKS or Azure Container Apps
- Implement additional Azure services like Azure Service Bus (replacing RabbitMQ)
- Apply Java runtime upgrades using the identified opportunities
- Configure managed identities for passwordless authentication

If you want to give feedback, please don't hesitate to open an issue on the repository or get in touch with one of us directly.

Thank you for investing the time and see you next time!

---

## Additional Resources

- [Azure Migrate Documentation](https://learn.microsoft.com/azure/migrate/)
- [Azure Migration Center](https://azure.microsoft.com/migration/)
- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/)
- [Cloud Adoption Framework](https://learn.microsoft.com/azure/cloud-adoption-framework/)
- [Microsoft Learn - Azure Migration Path](https://learn.microsoft.com/training/paths/migrate-modernize-innovate-azure/)


parking lot
![Architecture Overview](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0010.png)
