

# Azure Migration & Modernization MicroHack

This MicroHack scenario walks through a complete migration and modernization journey using Azure Migrate and GitHub Copilot. The experience covers discovery, assessment, business case development, and application modernization for both .NET and Java workloads.

## MicroHack Context

This MicroHack provides hands-on experience with the entire migration lifecycle - from initial discovery of on-premises infrastructure through to deploying modernized applications on Azure. You'll work with a simulated datacenter environment and use AI-powered tools to accelerate modernization.

**Key Technologies:**
- Azure Migrate for discovery and assessment
- GitHub Copilot for AI-powered code modernization
- Azure App Service for hosting modernized applications

**Jump to individual challenges:**
- [Challenge 1 - Infrastructure: Prepare a migration environment](#challenge-1---prepare-a-migration-environment)
- [Challenge 2 - Infrastructure: Analyze data & build a business case](#challenge-2---analyze-migration-data-and-build-a-business-case)
- [Challenge 3 - .NET app modernization](#challenge-3---modernize-a-net-application)
- [Challenge 4 - Java app modernization](#challenge-4---modernize-the-asset-manager-java-application)

## Environment creation

Install Azure PowerShell and authenticated to your Azure subscription:
```PowerShell
Install-Module Az
Connect-AzAccount
```

Please note:
- You need Administrator rights to install Azure PowerShell. If it's not an option for you, install it for the current user using `Install-Module Az -Scope CurrentUser`
- It takes some time (around 10 minutes) to install. Please, complete this task in advance.
- If you have multiple Azure subscriptions avaialble for your account, use `Connect-AzAccount -TenantId YOUR-TENANT-ID` to authenticate against specific one.

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

Modernize the Contoso University .NET Framework application to .NET 9 and deploy it to Azure App Service using GitHub Copilot's AI-powered code transformation capabilities.

**This challenge can be completed using full Visual Studio (as written below) or VS Code if you don't have full Visual Studio.**  If using VS Code, skip the part about building/compiling the solution file.

### Actions

**Setup and Preparation:**
1. Navigate to `https://github.com/crgarcia12/migrate-modernize-lab` and click the "Fork" button in the top-right corner

![Fork the repository](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/fork-button.png)

2. Select your account as the owner and click "Create fork"

![Create fork dialog](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/create-fork.png)

3. Once the fork is created, click the "Code" button and copy your forked repository URL

![Copy clone URL](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/clone-url.png)

4. Open Visual Studio 202x or VS Code.
5. Select "Clone a repository" and paste your forked repository URL
6. Navigate to Solution Explorer and locate the ContosoUniversity project
7. If using VS 202x, Rebuild the project to verify it compiles successfully

![Application running in IIS Express](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0030.png)

**Assess and Upgrade to .NET 9:**

8. Right-click the ContosoUniversity project and select "Modernize"

![Right-click Modernize menu](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0040.png)

9. Sign in to GitHub Copilot if prompted
10. Select Claude Sonnet 4.5 as the model
11. Click or instruct Copilot to "Upgrade to a newer .NET version"
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

![Upgrade report with cloud readiness issues](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0080.png)

20. Review the Cloud Readiness Issues section
21. Click "Migrate from Windows AD to Microsoft Entra ID"
22. Allow GitHub Copilot to implement the authentication changes
23. Ensure all mandatory tasks are resolved
24. Review the changes made to authentication configuration

**Deploy to Azure:**

25. Allow GitHub Copilot to complete the Azure App Service deployment
26. Verify the deployment succeeds
27. Test the deployed application in Azure

### Success Criteria

- ✅ ContosoUniversity solution cloned and builds successfully
- ✅ Application upgraded from .NET Framework to .NET 9
- ✅ Upgrade report generated showing all changes and issues
- ✅ Authentication migrated from Windows AD to Microsoft Entra ID
- ✅ All mandatory cloud readiness issues resolved
- ✅ Application successfully deployed to Azure App Service
- ✅ Deployed application is accessible and functional

### Learning Resources

- [GitHub Copilot for Visual Studio](https://learn.microsoft.com/visualstudio/ide/visual-studio-github-copilot-extension)
- [Modernize .NET Applications](https://learn.microsoft.com/dotnet/architecture/modernize-with-azure-containers/)
- [Migrate to .NET 9](https://learn.microsoft.com/dotnet/core/migration/)
- [Azure App Service for .NET](https://learn.microsoft.com/azure/app-service/quickstart-dotnetcore)
- [Microsoft Entra ID Authentication](https://learn.microsoft.com/azure/active-directory/develop/quickstart-v2-aspnet-core-webapp)

---

## Challenge 4 - Modernize the Asset Manager Java Application

## Goal

Modernize the Asset Manager Spring Boot application for Azure by upgrading and replacing AWS S3 dependencies with Azure services through the GitHub Copilot App Modernization workflow.

## Actions

* Fork [https://github.com/sitoader/ghcp-java-app-moderization-sample/](https://github.com/sitoader/ghcp-java-app-moderization-sample/), clone your fork in your IDE, and confirm the project builds on the `main` branch with JDK 8.
* Use the **GitHub Copilot App Modernization** extension to run the guided assessment, upgrade, test generation, CVE scan, cloud migration, and containerization stages.
* Follow the guide below or use the more detailed guide in the repository `README.md` file to perform all the necessary code steps to complete this challenge.

## Success criteria

* Docker containers start successfully and the legacy app runs locally before changes.
* AppCAT completes with nine cloud readiness issues and four Java upgrade opportunities identified.
* CVE scan runs clean — no critical or high-severity vulnerabilities remain.
* The AWS S3 to Azure Blob Storage migration task executes with updated dependencies and configuration.
* All automated validation stages pass without unresolved issues.
* The modernized application starts locally using Azure Blob Storage with no storage errors.
* Migration activities are traceable through dedicated plan and progress artifacts for rollback readiness.
  
## Pre-requirements

* **IDE**: Visual Studio Code or other IDE with the following extensions:
  - [GitHub Copilot App Modernization](https://marketplace.visualstudio.com/items?itemName=vscjava.migrate-java-to-azure)
  - [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
  - [GitHub Copilot Chat](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot-chat)
* **GitHub Copilot subscription** (Individual, Business, or Enterprise)
* **GitHub account** with access to public repositories
* **JDK 8** (for building the legacy app on `main`) and **JDK 21** (for the modernized app) — or use the included dev container
* **Maven 3.x** (included via Maven Wrapper `./mvnw`)
* **Docker Desktop** installed and running (for containerization and local testing)
* **Azure subscription** with Contributor access to a resource group
* **Azure CLI** installed ([Install guide](https://learn.microsoft.com/cli/azure/install-azure-cli))
* **Azure Developer CLI (azd)** installed ([Install guide](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd))
* **Git** configured with your GitHub credentials
* Basic familiarity with Java / Spring Boot web applications and Maven

### Dev Container (Recommended)

The easiest way to get started is with the included dev container, which provides JDK 8, JDK 21, Maven, PostgreSQL, RabbitMQ, and Docker — all pre-configured. See [DEV-SETUP.md](DEV-SETUP.md) for instructions.

## Step by step guide

### Stage 1: Assessment & Planning

1. **Open the Project**: Open the cloned repository in VS Code on the `main` branch
2. **Open App Modernization**: Open the GitHub Copilot App Modernization panel
3. **Start Assessment**: Select **"Start Assessment"** to begin the assessment workflow
4. **Review the Report**: A comprehensive assessment report is generated covering:
   - Current state analysis (Java version, Spring Boot version, dependencies)
   - Recommended target versions
   - Potential breaking changes and blockers
5. **Understand the Scope**: Review the detailed findings, including framework-specific recommendations and the full list of modernization tasks

### Stage 2: Java & Spring Boot Upgrade

1. **Initiate the Upgrade**: In App Modernization, click **Upgrade Java Runtime & Frameworks**
2. **Review the Plan**: The agent generates a step-by-step upgrade plan saved to `.github/java-upgrade/plan.md` — review the incremental migration path (Java 8 → 17 → 21, Spring Boot 2.7 → 3.2 → 3.3)
3. **Approve and Execute**: Approve the plan and let the agent execute each step automatically — updating POM files, migrating `javax.*` → `jakarta.*` imports, recompiling, and committing at each milestone
4. **Review the Summary**: Check `.github/java-upgrade/summary.md` for upgrade results, technology stack diff, and any challenges encountered
5. **Verify Build**: Run `./mvnw clean compile` to confirm the project compiles with Java 21 and Spring Boot 3.3

### Stage 3: Unit Testing

1. **Generate Tests**: After the upgrade completes, GitHub Copilot suggests a **Proceed** option — click **Generate unit tests**
2. **Review Coverage Analysis**: The agent identifies classes with no or insufficient test coverage across `web` and `worker` modules
3. **Review Generated Tests**: JUnit 5 + Mockito tests are generated targeting controllers, services, and message processors
4. **Run Tests**: Execute `./mvnw clean test` and confirm all tests pass
5. **Target**: Aim for meaningful coverage on critical business logic (controllers, services, processors)

### Stage 4: CVE Check & Security

1. **Trigger CVE Scan**: In App Modernization, click **Scan and Resolve CVEs**
2. **Review the Report**: Check the vulnerability report for critical/high severity issues in dependencies (Tomcat, Jackson, Spring Boot, PostgreSQL driver, etc.)
3. **Apply Fixes**: Let Copilot upgrade dependency versions in the parent `pom.xml` (Spring Boot BOM bump, version overrides)
4. **Confirm Resolution**: Re-scan to confirm **0 known vulnerabilities remaining** — ask Copilot to generate a vulnerability assessment report
5. **Verify**: Run `./mvnw clean verify` to confirm everything compiles and passes

### Stage 5: AWS to Azure Migration

1. **Review Cloud Readiness Tasks**: In the assessment, check for AWS-specific dependencies (S3 SDK, configuration classes, storage services)
2. **Execute Migration**: Run the migration task — the agent replaces AWS SDK with Azure SDK (`azure-storage-blob`, `azure-identity`), migrates configuration and service classes, and updates templates
3. **Review Changes**: Confirm all AWS references are removed and Azure Blob Storage with `DefaultAzureCredential` is in place
4. **Test Locally**: Run with the dev profile (no Azure account needed):
   ```bash
   SPRING_PROFILES_ACTIVE=dev ./mvnw -pl web spring-boot:run
   ```
5. **Test with Azure** (optional): Create an Azure Storage account and blob container, then configure `azure.storage.account-name` and `azure.storage.blob.container` in `application.properties` or as environment variables. Ensure you have `az login` active and **Storage Blob Data Contributor** role assigned.

### Stage 6: Containerization & Azure Deployment

1. **Start Containerization**: In the assessment, execute the **containerization task**
2. **Review the Plan**: The agent generates a plan covering Dockerfiles, Docker Compose, Bicep templates, and `azure.yaml`
3. **Execute the Plan**: Approve and let the agent create all artifacts (multi-stage Dockerfiles, `docker-compose.yml`, `infra/main.bicep`, `azure.yaml`)
4. **Test Locally with Docker Compose**:
   ```bash
   docker build -t assets-manager-web:latest -f web/Dockerfile .
   docker build -t assets-manager-worker:latest -f worker/Dockerfile .
   docker-compose up -d
   ```
   Verify at `http://localhost:8080` (Web UI), `http://localhost:15672` (RabbitMQ)
5. **Deploy to Azure**:
   ```bash
   azd auth login
   azd up
   ```
6. **Verify**: Confirm the application is running on Azure Container Apps

## Learning resources

* [GitHub Copilot for VS Code](https://code.visualstudio.com/docs/copilot/overview)
* [Azure SDK for Java](https://learn.microsoft.com/azure/developer/java/sdk/)
* [Migrate from AWS to Azure](https://learn.microsoft.com/azure/architecture/aws-professional/)
* [Azure Blob Storage for Java](https://learn.microsoft.com/azure/storage/blobs/storage-quickstart-blobs-java)
* [Spring Cloud Azure](https://learn.microsoft.com/azure/developer/java/spring-framework/)
* [AppCAT Assessment Tool](https://learn.microsoft.com/azure/developer/java/migration/migration-toolkit-intro)

### Quick Troubleshooting Tips

- **Build errors after upgrade**: Copy the full Maven error output to Copilot chat and ask for diagnosis — common issues include missing `jakarta` imports or incompatible dependency versions
- **Test failures**: Determine if it's a test setup issue (mocking) or an actual app bug — ask Copilot to analyze the failure stack trace
- **AWS references remaining**: Search the codebase for `aws`, `s3`, `AmazonS3` — ask Copilot to complete the migration for any remaining references
- **Docker build failures**: Check that the Dockerfile base image matches your Java version (Eclipse Temurin 21) and that the Maven build stage copies the correct JAR
- **`azd up` failures**: Verify `az login` is active, your subscription has Contributor access, and `azure.yaml` references the correct services
- **Runtime issues**: Share stack traces with Copilot for resolution strategies — check `docker-compose logs -f` for local issues



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
- Used GitHub Copilot App Modernization extension in Visual Studio / VS Code
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
- 
