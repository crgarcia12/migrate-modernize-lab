@lab.Title

## Hello lab.User.FirstName! 
## Welcome to Your Lab Environment

To begin, log into the virtual machine using the following credentials: 
Username: +++@lab.VirtualMachine(Win11-Pro-Base).Username+++
Password: +++@lab.VirtualMachine(Win11-Pro-Base).Password+++

===
# Lab initial setup
This lab requires some initial setup to ensure that all necessary tools and configurations are in place. Follow the steps below to prepare your environment:

## Upload Azure Migrate Assessment
1. [ ] Open Edge, and head to the Azure Portal using the following link. This link enables some of the preview features we will need later on: +++http://aka.ms/migrate/disconnectedAppliance+++
1. [ ] Login using the credentials in the Resources tab.

    > [+Hint] Troubles finding the resource tab?
    >
    > Navigate to the top right corner of this screen, in there you can always find the credentials and important information
    > ![text to display](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0010.png)


TODO: Upload the Azure Migrate file!

## Login to GitHub Enterprise
Login to Github enterprise: +++https://github.com/enterprises/skillable-events+++

> [!Knowledge] ATENTION!
>
> Make sure you don't close the GitHub site. Otherwise Copilot might not work

===

# What are we going to do today?

This lab has two main parts:
Part 1: Prepare a migration:
1. An assessment of an on-premises datacenter hyper-v environment using Azure Migrate
1. Building a Business Case and decide on the next step for one application

Part 2: Migrate an application:
1. Modernize .NET application |using GitHub Copilot app modernization for .NET.
1. Build a pipeline to deploy the application to Azure

Each part is independent.

===

# Part 1: Prepare a migration
### Understand our lab environment

The lab simulates a datacenter, by having a VM hosting server, and several VMs inside simulating different applications

1. [ ] Open Edge, and head to the Azure Portal using the following link. This link enables some of the preview features we will need later on: +++http://aka.ms/migrate/disconnectedAppliance+++
1. [ ] Login using the credentials in the Resources tab.

> [+Hint] Troubles finding the resource tab?
>
> Navigate to the top right corner of this screen, in there you can always find the credentials and important information
> ![text to display](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0010.png)

1. [ ] Open the list of resource groups. You will find on called `on-prem`
2. [ ] Explore the resource group. Find a VM called `lab@lab.LabInstance.Id-vm`
3. [ ] Open the VM. Click in `Connect`. Wait until the page is fullo loaded
4. [ ] Click in `Download RDP file` wait until the download is complete and open it
5. [ ] Login to the VM using the credentials
    1. [ ] Username: `adminuser`
    2. [ ] Password: `demo!pass123`


You have now loged in into your on-premises server!
Let's explore whats inside in the next chapter

===
### Understand our lab environment: The VM

This Virtual machine represents an on-premises server.
It has nested virtualization. Inside you will find several VMs.

> ![Hyper-V architecture](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0020.png)

In the windows menu, open the `Hyper-V Manager` to discover the inner VMs.

We will now create another VM, and install the Azure Migrate Disconnected Appliance



===
# Excersise 2

GitHub Copilot app modernization is a GitHub Copilot agent that helps upgrade projects to newer versions of .NET and migrate .NET applications to Azure quickly and confidently by guiding you through assessment, solution recommendations, code fixes, and validation - all within Visual Studio.

With this assistant, you can:

- Upgrade to a newer version of .NET.
- Migrate technologies and deploy to Azure.
- Modernize your .NET app, especially when upgrading from .NET Framework.
- Assess your application's code, configuration, and dependencies.
- Plan and set up the right Azure resource.
- Fix issues and apply best practices for cloud migration.
- Validate that your app builds and tests successfully.

===

# Clone the application repo

We have found our first target application to be migrated: `Contoso University`

Since we are going to modernize it first, lets get in the shoes of the developers that will execute the migration

1. [ ] Open Visual Studio
2. [ ] Select Clone a repository
3. [ ] In the `Repository Location`, paste this repo +++https://github.com/crgarcia12/migrate-modernize-lab.git+++
4. [ ] Click Cone


6. [ ] 
===






> [!IMPORTANT]
> Starting with Visual Studio 2022 17.14.16, the GitHub Copilot app modernization agent is included with Visual Studio. If you're using an older version of Visual Studio 2022, upgrade to the latest release.
>
> If you installed any of the following extensions published by Microsoft, uninstall them before using the version now included in Visual Studio:
>
> - .NET Upgrade Assistant
> - GitHub Copilot App Modernization - Upgrade for .NET
> - Azure Migrate Application and Code Assessment for .NET

## Provide feedback

Feedback is important to Microsoft and the efficiency of this agent. Use the [Suggest a feature](/visualstudio/ide/suggest-a-feature) and [Report a problem](/visualstudio/ide/report-a-problem) features of Visual Studio to provide feedback.

## Prerequisites

The following items are required before you can use GitHub Copilot app modernization:

[!INCLUDE[github-copilot-app-mod-prereqs](../../includes/github-copilot-app-mod-prereqs.md)]

## How to start an upgrade or migration

To start an upgrade or migration, interact with GitHub Copilot, following these steps:

[!INCLUDE[github-copilot-how-to-initiate](./includes/github-copilot-how-to-initiate.md)]

## Upgrade .NET projects

The modernization agent supports upgrading projects coded in C#. The following types of projects are supported:

- ASP.NET Core (and related technologies such as MVC, Razor Pages, and Web API)
- Blazor
- Azure Functions
- Windows Presentation Foundation
- Windows Forms
- Class libraries
- Console apps

> [!IMPORTANT]
> .NET Framework upgrade scenarios are currently in preview, which includes technologies such as Windows Forms for .NET Framework and ASP.NET. Using the modernization agent to design an upgrade plan might work in limited scenarios. If upgrading an ASP.NET project (or related technologies such as MVC, Razor Pages, Web API) see [ASP.NET Migration](/aspnet/core/migration/fx-to-core) for recommendations.

To learn how to start an upgrade, see [How to upgrade a .NET app with GitHub Copilot app modernization](how-to-upgrade-with-github-copilot.md).

### Upgrade paths

The following upgrade paths are supported:

- Upgrade projects from older .NET versions to the latest.
- Modernize your code base with new features.
- Migrate components and services to Azure.

> [!IMPORTANT]
> Upgrading projects from .NET Framework to the latest version of .NET is still in preview.

## Migrate .NET projects to Azure

The modernization agent combines automated analysis, AI-driven code remediation, build and vulnerability checks, and deployment automation to simplify migrations to Azure. The following capabilities describe how the agent assesses readiness, applies fixes, and streamlines the migration process:

- Analysis & Intelligent Recommendations.

  Assess your application's readiness for Azure migration and receive tailored guidance based on its dependencies and identified issues.

- AI-Powered Code Remediation.

  Apply predefined best-practice code patterns to accelerate modernization with minimal manual effort.

- Automatic Build and CVE Resolution.

  Automatically builds your app and resolves compilation errors and vulnerabilities, streamlining development.

- Seamless Deployment.

  Deploy to Azure effortlessly, taking your code from development to cloud faster than ever.

### Predefined tasks for migration

Predefined tasks capture industry best practices for using Azure services. Currently, GitHub Copilot app modernization for .NET offers predefined tasks that cover common migration scenarios.

- **Migrate to Managed Identity based Database on Azure, including Azure SQL DB, Azure SQL MI, and Azure PostgreSQL**

  Modernize your data layer by migrating from on-premises or legacy databases (such as DB2, Oracle DB, or SQL Server) to Azure SQL DB, Azure SQL Managed Instance, or Azure PostgreSQL, using secure managed identity authentication.

- **Migrate to Azure File Storage**

  Move file I/O operations from the local file system to Azure File Storage for scalable, cloud-based file management.

- **Migrate to Azure Blob Storage**

  Replace on-premises or cross-cloud object storage, or local file system file I/O, with Azure Blob Storage for unstructured data.

- **Migrate to Microsoft Entra ID**

  Transition authentication and authorization from Windows Active Directory to Microsoft Entra ID (formerly Azure AD) for modern identity management.

- **Migrate to secured credentials with Managed Identity and Azure Key Vault**

  Replace plaintext credentials in configuration or code with secure, managed identities and Azure Key Vault for secrets management.

- **Migrate to Azure Service Bus**

  Move from legacy or third-party message queues (such as MSMQ or RabbitMQ) or Amazon SQS (AWS Simple Queue Service) to Azure Service Bus for reliable, cloud-based messaging.

- **Migrate to Azure Communication Service email**

  Replace direct SMTP email sending with Azure Communication Service for scalable, secure email delivery.

- **Migrate to Confluent Cloud/Azure Event Hub for Apache Kafka**

  Transition from local or on-premises Kafka to managed event streaming with Confluent Cloud or Azure Event Hubs.

- **Migrate to OpenTelemetry on Azure**

  Transition from local logging frameworks like log4net, serilog, and Windows event log to OpenTelemetry on Azure.

- **Migrate to Azure Cache for Redis with Managed Identity**
  Replace in-memory or local Redis cache implementations with Azure Cache for Redis for high availability, scalability, and enterprise-grade security.

## How does it work

Once you request the modernization agent to upgrade or migrate your app, Copilot analyzes your projects and their dependencies, and then asks you a series of questions about the upgrade or migration. After you answer these questions, a plan is written in the form of a Markdown file. If you tell Copilot to proceed with the upgrade or migration, it follows the steps described in the plan.

You can adjust the plan by editing the Markdown file to change the upgrade steps or add more context.

### Perform the upgrade or migration

Once a plan is ready, tell Copilot to start using it. Once the process starts, Copilot lets you know what it's doing in the chat window and it opens the **Upgrade Progress Details** document, which lists the status of every step.

If it runs into a problem, Copilot tries to identify the cause of a problem and apply a fix. If Copilot can't seem to correct the problem, it asks for your help. When you intervene, Copilot learns from the changes you make and tries to automatically apply them for you, if the problem is encountered again.

Each major step in the plan is committed to the local Git repository.

### Upgrade and migration results

When the process completes, a report is generated that describes every step taken by Copilot. The tool creates a Git commit for every portion of the process, so you can easily roll back the changes or get detailed information about what changed. The report contains the Git commit hashes.

The report also provides a _Next steps_ section that describes the steps you should take after the upgrade finishes.

===

GitHub Copilot app modernization is an interactive GitHub Copilot agent that adds powerful capabilities to Visual Studio. This article answers frequently asked questions. For more information about the modernization agent, see [What is GitHub Copilot app modernization](github-copilot-app-modernization-overview.md).

  The tool requires one of the following GitHub Copilot subscriptions:

  - Copilot Pro
  - Copilot Pro+
  - Copilot Business
  - Copilot Enterprise

  GitHub Copilot app modernization is included in [Visual Studio 2022 version 17.14.16 or newer](https://visualstudio.microsoft.com/downloads/).

sections:
  - name: Modernization agent
    questions:
      - question: What can the agent do?
        answer: |
          Currently, GitHub Copilot app modernization helps you upgrade your .NET (.NET, .NET Core, and .NET Framework) projects to newer versions of .NET. It also helps migrate services to Azure. It also upgrades dependencies and fixes errors in the code post-migration. The agent performs the following steps in a GitHub Copilot chat session:

          - Analyzes your projects and proposes an modernization plan.
          - According to the plan, runs a series of tasks to modernize your projects.
          - Operates in a working branch under a local Git repository.
          - Automatically fixes issues during the code transformation.
          - Reports progress and allow access to code changes & logs.
          - Learns from the interactive experience with you (within the context of the session) to improve subsequent transformations.

      - question: What limitations are there?
        answer: |
          - Only Git repositories are supported.
          - There's no guarantee that the upgrade or migration suggestions are considered best practices.
          - The LLM doesn't persist learning from the upgrade. Meaning, code fixes and corrections you provide during the upgrade process don't persist and can't be remembered for future upgrades.
          - It only runs on Windows.

      - question: Which model should I use?
        answer: |
          You should use a good coding model, such as Claude Sonnet 4.0 or Claude Sonnet 3.7.

      - question: Can I train the model based on my code base?
        answer: |
          No. Unlike traditional AI tools where you might enter freeform prompts, the agent operates in a more structured way. The AI is embedded within the build-and-fix process, meaning the prompts it uses are predefined and tied to the upgrade plan. So it's not something you can train on your codebase, and it's not something you can manually steer with custom instructions, beyond the changes you can make to the plan Markdown file.

          However, the agent does have some adaptability within a session. If you manually adjust a fix, it learns from that interaction in the short term and applies similar corrections if it encounters the same issue again. Think of it as refining its approach within the scope of that upgrade.

      - question: Does the agent store my source code?
        answer: |
          The agent never stores a user's codebase and never uses your code for training the model. Once an upgrade or migration is complete, session data is deleted.

      - question: Can I provide feedback?
        answer: |
          Yes! Use the [Suggest a feature](/visualstudio/ide/suggest-a-feature) and [Report a Problem](/visualstudio/ide/report-a-problem) features of in Visual Studio to provide feedback.

      - question: What data is collected?
        answer: |
          The agent only collects telemetry information about project types, intent to upgrade, and upgrade duration. The data is aggregated through Visual Studio itself and doesn't contain any user-identifiable information. For more information about Microsoft's privacy policy, see [Visual Studio Customer Experience Improvement Program](/visualstudio/ide/visual-studio-experience-improvement-program?view=vs-2022).

      - question: Can I disable telemetry?
        answer: |
          Yes, you can disable telemetry. In Visual Studio, select **Help** > **Privacy** > **Privacy Settings** > **"No, I would not like to participate."**

  - name: Upgrade .NET apps
    questions:
      - question: What can the agent upgrade?
        answer: |
          GitHub Copilot app modernization helps you upgrade your .NET projects or migrate them to Azure. Besides upgrading the target framework, the agent can work with the following types of projects:

          - Azure Functions.
          - Console apps and class libraries.
          - Web technologies such as:
            - MVC
            - Blazor
            - Razor Pages
            - Web API
          - Desktop technologies such as Windows Forms and Windows Presentation Foundation.
          - Test projects such as MSTest and NUnit.
          - .NET Framework projects.

  - name: Migrate to Azure
    questions:
      - question: What can the agent migrate?
        answer: |
          The agent can assist in migrating and deploying your .NET applications to Azure, including:

          - Web apps
          - API apps
          - Azure Functions
          - Containerized applications

          The migration scenarios include:

          - Modernizing databases
          - Storage
          - Identity
          - Messaging
          - Event streaming
          - Email
          - Logging
          - Security

          For more information about these scenarios, see [Predefined tasks for migration](github-copilot-app-modernization-overview.md#predefined-tasks-for-migration).

      - question: Can I monitor assessment progress?
        answer: |
          Yes, you can monitor the progress of the assessment through the Visual Studio interface. The agent provides real-time feedback and updates on the status of the migration process.

          While the assessment is running, you can monitor its progress by viewing the command-line output:

          1. In Visual Studio, go to **View** > **Output** to open the Output window.
          2. In the Output window, find the **Show output from:** dropdown.
          3. Select **AppModernizationExtension** from the dropdown list.
          4. The command-line output from the assessment tool appears here, showing real-time progress.

          You can also access the **Output** window using the keyboard shortcut <kbd>Ctrl+Alt+O</kbd>.

===

# Predefined tasks for GitHub Copilot app modernization for .NET (Preview)

This article describes the predefined tasks available for GitHub Copilot app modernization for .NET (Preview).

Predefined tasks capture industry best practices for using Azure services. Currently, App Modernization for .NET (Preview) offers predefined tasks that cover common migration scenarios. These tasks address the following subjects, and more:

- Database migration
- Storage migration
- Secret management
- Message queue integration
- Caching migration
- Identity management
- Log management

## Predefined task list

App Modernization for .NET currently supports the following predefined tasks:

- **Migrate to Managed Identity based Database on Azure, including Azure SQL DB, Azure SQL MI and Azure PostgreSQL**
  
  Modernize your data layer by migrating from on-premises or legacy databases (such as DB2, Oracle DB, or SQL Server) to Azure SQL DB, Azure SQL Managed Instance or Azure PostgreSQL, using secure managed identity authentication.

- **Migrate to Azure File Storage**
  
  Move file I/O operations from the local file system to Azure File Storage for scalable, cloud-based file management.

- **Migrate to Azure Blob Storage**
  
  Replace on-premises or cross-cloud object storage, or local file system file I/O, with Azure Blob Storage for unstructured data.

- **Migrate to Microsoft Entra ID**
  
  Transition authentication and authorization from Windows Active Directory to Microsoft Entra ID (formerly Azure AD) for modern identity management.

- **Migrate to secured credentials with Managed Identity and Azure Key Vault**
  
  Replace plaintext credentials in configuration or code with secure, managed identities and Azure Key Vault for secrets management.

- **Migrate to Azure Service Bus**
  
  Move from legacy or third-party message queues (such as MSMQ or RabbitMQ) or Amazon SQS (AWS Simple Queue Service) to Azure Service Bus for reliable, cloud-based messaging.

- **Migrate to Azure Communication Service email**
  
  Replace direct SMTP email sending with Azure Communication Service for scalable, secure email delivery.

- **Migrate to Confluent Cloud/Azure Event Hub for Apache Kafka**
  
  Transition from local or on-premises Kafka to managed event streaming with Confluent Cloud or Azure Event Hubs.

- **Migrate to OpenTelemetry on Azure**

  Transition from local logging frameworks like log4net, serilog, windows event log to OpenTelemetry on Azure.

- **Migrate to Azure Cache for Redis**

  Replace in-memory or local Redis cache implementations with Azure Cache for Redis for high availability, scalability, and enterprise-grade security.

===

# Quickstart: Assess and migrate a .NET project with GitHub Copilot app modernization for .NET

In this quickstart, you assess and migrate a .NET project by using GitHub Copilot app modernization for .NET. You complete the following tasks:

- Assess a sample project (Contoso University)
- Start the migration process

## Prerequisites

[!INCLUDE[github-copilot-app-mod-prereqs](../../../includes/github-copilot-app-mod-prereqs.md)]

## Assess app readiness

GitHub Copilot app modernization for .NET assessment helps you find app readiness challenges, learn their impact, and see recommended migration tasks. Each migration task includes references to set up Azure resources, add configurations, and make code changes. Follow these steps to start your migration:

1. Clone the [.NET migration copilot samples](https://github.com/Azure-Samples/dotnet-migration-copilot-samples) repository to your computer.

1. In Visual Studio, open the **Contoso University** solution from the samples repository.

1. In Solution Explorer, right-click the solution node and select **Modernize**.

    :::image type="content" source="media/modernize-solution.png" alt-text="Screenshot that shows the modernize option in the context menu.":::

1. The GitHub Copilot Chat window opens with a welcome message and predefined options. Select **Migrate to Azure** from the available choices and send it to Copilot.

    :::image type="content" source="media/modernization-welcome.png" alt-text="Screenshot that shows the welcome message with migration options.":::

    > [!TIP]
    > Instead of steps 3 and 4, you can open **GitHub Copilot Chat** directly and send `@Modernize Migrate to Azure` to start the assessment and migration flow.

1. A new Copilot chat session opens and shows the welcome message. The assessment starts automatically and analyzes your project for migration readiness.

    :::image type="content" source="media/assessment-in-process.png" alt-text="Screenshot that shows assessment in progress with status indicators.":::

1. When the assessment finishes, you see a comprehensive assessment report UI page and a list of migration tasks in the chat window.

    :::image type="content" source="media/assessment-report.png" alt-text="Screenshot that shows the generated assessment report with detailed findings.":::

## App migrations

GitHub Copilot app modernization for .NET includes [predefined tasks](predefined-tasks.md) for common migration scenarios and follows Microsoft's best practices.

### Start a migration task

Start a migration task in one of the following ways:

**Option 1. Run from the Assessment Report**

Select the **Run Task** button in the Assessment Report from the previous step to start a migration task.

**Option 2. Send in Copilot Chat**

Send the migration task number (for example, 1.1) or its name in the chat.

:::image type="content" source="media/quickstart-chat-experience.png" alt-text="Screenshot of sending a message in Copilot Chat to start a migration task.":::

### Plan and progress tracker generation

- When you start the migration, GitHub Copilot starts a session named "App modernization: migrate from `<source technology>` to `<target technology>`" in agent mode with predefined prompts.
- The tool creates two files in the `.appmod/.migration` folder:
  - `plan.md` - the overall migration plan
  - `progress.md` - a progress tracker; GitHub Copilot marks items as it completes tasks
- Edit these files to customize your migration before you continue.

### Start code remediation

- If you're satisfied with the plan and progress tracker, enter a prompt to start the migration, such as:

    ```console
    The plan and progress tracker look good to me. Go ahead with the migration.
    ```

- GitHub Copilot starts the migration process and might ask for your approval to use knowledge base tools in the Model Context Protocol (MCP) server. Grant permission when prompted.
- Copilot follows the plan and progress tracker to:
  - Manage dependencies
  - Apply configuration changes
  - Make code changes
  - Build the solution, fix all compilation and configuration errors, and ensure a successful build
  - Fix security vulnerabilities

## Default chat messages

GitHub Copilot app modernization for .NET gives you default chat message options to streamline your workflow.

:::image type="content" source="media/quickstart-followup.png" alt-text="Screenshot that shows default chat message options in the Copilot Chat.":::

You can choose one of the predefined options and send it in the chat:

- **Run modernization assessment**: Starts a new assessment of your application to identify migration readiness issues and Azure compatibility challenges.
- **View assessment report**: Opens the previous assessment report and shows a summary of migration tasks based on the results. If no previous assessment exists, it runs a new assessment first.
- **Browse top migration tasks**: Shows recommended migration tasks and common modernization scenarios, regardless of any specific assessment results.

> [!TIP]
> These default messages help you quickly navigate common workflows without typing custom prompts. You can also enter your own messages to interact with Copilot for specific questions or needs.

===

# Quickstart: Containerize your project using GitHub Copilot app modernization for .NET

In this quickstart, you learn how to containerize your project using GitHub Copilot app modernization for .NET. The app modernization tooling uses GitHub Copilot's AI capabilities to:

- Analyze your project structure and dependencies
- Generate Dockerfile configurations
- Create build-ready Docker images
- Guide you through the containerization process

## Prerequisites

Before you begin, make sure you have:

[!INCLUDE[github-copilot-app-mod-prereqs](../../../includes/github-copilot-app-mod-prereqs.md)]

## Containerize your project

The GitHub Copilot app modernization for .NET containerization feature helps you containerize your project. To start the containerization process, complete the following steps:

1. Open your project in Visual Studio.

1. Enable **appModernizationDeploy** in the GitHub Copilot toolbox.

    :::image type="content" source="../../media/appmod-dotnet-containerization-tool-selection.png" alt-text="Screenshot that shows containerization tool selection.":::

1. Start containerization by using one of these approaches:

    - **Containerize from Assessment Report**: In the assessment report, select **Run Task** for the Docker Containerization issue.

        :::image type="content" source="media/containerize-assessment-report.png" alt-text="Screenshot that shows containerization task in assessment report.":::

    - **Use a containerization prompt**: You can input the following prompt in Copilot chat to containerize your project:

        *Scan my project and help me plan how to containerize my application using the #appmod-get-containerization-plan tool. Execute the plan. The end goal is to have Dockerfiles that are able to be built.*

        :::image type="content" source="media/containerization-prompt.png" alt-text="Screenshot that shows how to start the containerization process in GitHub Copilot using a prompt.":::

1. After you start the process, GitHub Copilot can ask for your approval to use tools or run commands. Grant permission when prompted.

1. GitHub Copilot analyzes your project and generates a plan. The plan includes a breakdown of your project and steps for containerizing your project.

1. GitHub Copilot follows the steps to generate a Dockerfile and validate that your Docker image builds successfully.

1. When GitHub Copilot finishes containerizing your project, it provides a summary of what it did.

## Notes

- Use Claude Sonnet 4 or later models for the best results.
- Copilot might take a few iterations to fix containerization errors.

===

# Quickstart: Use GitHub Copilot app modernization for .NET to deploy your project to Azure

In this quickstart, you learn how to deploy your project to Azure with GitHub Copilot app modernization for .NET. This tool lets you deploy migrated projects to Azure and automatically fixes deployment errors during the process.

## Prerequisites

[!INCLUDE[github-copilot-app-mod-prereqs](../../../includes/github-copilot-app-mod-prereqs.md)]

## Deploy your project

The App Modernization for .NET deployment feature helps you deploy your migrated app to Azure. Follow these steps to start the deployment process:

1. In Visual Studio, open your migrated project.

1. Start the deployment with one of the following approaches:

    - **Deploy after migration**: Deploy your project after completing your migration task. GitHub Copilot asks if you'd like to deploy your project to Azure upon completing a migration task. Instructing Copilot to continue starts the deployment process.

        :::image type="content" source="media/start-deploy.png" alt-text="Screenshot that shows how to start the deployment process in GitHub Copilot.":::

    - **Use a deployment prompt**: You can enter the following prompt in Copilot chat to deploy your project to Azure:

        *Scan my project to identify all Azure-relevant resources, programming languages, frameworks, dependencies, and configuration files needed for deployment, and develop an architecture diagram for me using #appmod-generate-architecture-diagram. Based on that diagram, help me develop and execute a plan using #appmod-get-plan to deploy my project to Azure. deployTool: azcli, hosting service: non-aks.*

        :::image type="content" source="media/start-deploy-prompt.png" alt-text="Screenshot that shows how to start the deployment process in GitHub Copilot by using a prompt.":::

1. After you start the deployment, GitHub Copilot might ask for your approval to use tools or run commands. Grant permission when prompted.

1. GitHub Copilot creates a plan. The plan explains the deployment strategy, including deployment goals, project information, Azure resource architecture, Azure resources, and execution steps.

1. You can edit the plan directly or ask GitHub Copilot to edit it to customize your deployment before you proceed.

1. When you're satisfied with the plan, instruct GitHub Copilot to continue.

1. GitHub Copilot follows the plan and runs the deployment process.

1. When deployment finishes, GitHub Copilot provides a summary of the deployment process.

## Notes

- Use Claude Sonnet 4 or later models for the best results.
- Copilot can need a few iterations to fix deployment errors.

===






===

===


GitHub Copilot app modernization is a GitHub Copilot agent that helps upgrade projects to newer versions of .NET and migrate .NET applications to Azure quickly and confidently by guiding you through assessment, solution recommendations, code fixes, and validation - all within Visual Studio.

This process streamlines modernization and boosts developer productivity and confidence. GitHub Copilot app modernization is an all-in-one upgrade and migration assistant that uses AI to improve developer velocity, quality, and results.

With this assistant, you can:

- Upgrade to a newer version of .NET.
- Migrate technologies and deploy to Azure.
- Modernize your .NET app, especially when upgrading from .NET Framework.
- Assess your application's code, configuration, and dependencies.
- Plan and set up the right Azure resource.
- Fix issues and apply best practices for cloud migration.
- Validate that your app builds and tests successfully.

> [!IMPORTANT]
> Starting with Visual Studio 2022 17.14.16, the GitHub Copilot app modernization agent is included with Visual Studio. If you're using an older version of Visual Studio 2022, upgrade to the latest release.
>
> If you installed any of the following extensions published by Microsoft, uninstall them before using the version now included in Visual Studio:
>
> - .NET Upgrade Assistant
> - GitHub Copilot App Modernization - Upgrade for .NET
> - Azure Migrate Application and Code Assessment for .NET

## Provide feedback

Feedback is important to Microsoft and the efficiency of this agent. Use the [Suggest a feature](/visualstudio/ide/suggest-a-feature) and [Report a problem](/visualstudio/ide/report-a-problem) features of Visual Studio to provide feedback.

## Prerequisites

The following items are required before you can use GitHub Copilot app modernization:

[!INCLUDE[github-copilot-app-mod-prereqs](../../includes/github-copilot-app-mod-prereqs.md)]

## How to start an upgrade or migration

To start an upgrade or migration, interact with GitHub Copilot, following these steps:

[!INCLUDE[github-copilot-how-to-initiate](./includes/github-copilot-how-to-initiate.md)]

## Upgrade .NET projects

The modernization agent supports upgrading projects coded in C#. The following types of projects are supported:

- ASP.NET Core (and related technologies such as MVC, Razor Pages, and Web API)
- Blazor
- Azure Functions
- Windows Presentation Foundation
- Windows Forms
- Class libraries
- Console apps

> [!IMPORTANT]
> .NET Framework upgrade scenarios are currently in preview, which includes technologies such as Windows Forms for .NET Framework and ASP.NET. Using the modernization agent to design an upgrade plan might work in limited scenarios. If upgrading an ASP.NET project (or related technologies such as MVC, Razor Pages, Web API) see [ASP.NET Migration](/aspnet/core/migration/fx-to-core) for recommendations.

To learn how to start an upgrade, see [How to upgrade a .NET app with GitHub Copilot app modernization](how-to-upgrade-with-github-copilot.md).

### Upgrade paths

The following upgrade paths are supported:

- Upgrade projects from older .NET versions to the latest.
- Modernize your code base with new features.
- Migrate components and services to Azure.

> [!IMPORTANT]
> Upgrading projects from .NET Framework to the latest version of .NET is still in preview.

## Migrate .NET projects to Azure

The modernization agent combines automated analysis, AI-driven code remediation, build and vulnerability checks, and deployment automation to simplify migrations to Azure. The following capabilities describe how the agent assesses readiness, applies fixes, and streamlines the migration process:

- Analysis & Intelligent Recommendations.

  Assess your application's readiness for Azure migration and receive tailored guidance based on its dependencies and identified issues.

- AI-Powered Code Remediation.

  Apply predefined best-practice code patterns to accelerate modernization with minimal manual effort.

- Automatic Build and CVE Resolution.

  Automatically builds your app and resolves compilation errors and vulnerabilities, streamlining development.

- Seamless Deployment.

  Deploy to Azure effortlessly, taking your code from development to cloud faster than ever.

### Predefined tasks for migration

Predefined tasks capture industry best practices for using Azure services. Currently, GitHub Copilot app modernization for .NET offers predefined tasks that cover common migration scenarios.

- **Migrate to Managed Identity based Database on Azure, including Azure SQL DB, Azure SQL MI, and Azure PostgreSQL**

  Modernize your data layer by migrating from on-premises or legacy databases (such as DB2, Oracle DB, or SQL Server) to Azure SQL DB, Azure SQL Managed Instance, or Azure PostgreSQL, using secure managed identity authentication.

- **Migrate to Azure File Storage**

  Move file I/O operations from the local file system to Azure File Storage for scalable, cloud-based file management.

- **Migrate to Azure Blob Storage**

  Replace on-premises or cross-cloud object storage, or local file system file I/O, with Azure Blob Storage for unstructured data.

- **Migrate to Microsoft Entra ID**

  Transition authentication and authorization from Windows Active Directory to Microsoft Entra ID (formerly Azure AD) for modern identity management.

- **Migrate to secured credentials with Managed Identity and Azure Key Vault**

  Replace plaintext credentials in configuration or code with secure, managed identities and Azure Key Vault for secrets management.

- **Migrate to Azure Service Bus**

  Move from legacy or third-party message queues (such as MSMQ or RabbitMQ) or Amazon SQS (AWS Simple Queue Service) to Azure Service Bus for reliable, cloud-based messaging.

- **Migrate to Azure Communication Service email**

  Replace direct SMTP email sending with Azure Communication Service for scalable, secure email delivery.

- **Migrate to Confluent Cloud/Azure Event Hub for Apache Kafka**

  Transition from local or on-premises Kafka to managed event streaming with Confluent Cloud or Azure Event Hubs.

- **Migrate to OpenTelemetry on Azure**

  Transition from local logging frameworks like log4net, serilog, and Windows event log to OpenTelemetry on Azure.

- **Migrate to Azure Cache for Redis with Managed Identity**
  Replace in-memory or local Redis cache implementations with Azure Cache for Redis for high availability, scalability, and enterprise-grade security.

## How does it work

Once you request the modernization agent to upgrade or migrate your app, Copilot analyzes your projects and their dependencies, and then asks you a series of questions about the upgrade or migration. After you answer these questions, a plan is written in the form of a Markdown file. If you tell Copilot to proceed with the upgrade or migration, it follows the steps described in the plan.

You can adjust the plan by editing the Markdown file to change the upgrade steps or add more context.

### Perform the upgrade or migration

Once a plan is ready, tell Copilot to start using it. Once the process starts, Copilot lets you know what it's doing in the chat window and it opens the **Upgrade Progress Details** document, which lists the status of every step.

If it runs into a problem, Copilot tries to identify the cause of a problem and apply a fix. If Copilot can't seem to correct the problem, it asks for your help. When you intervene, Copilot learns from the changes you make and tries to automatically apply them for you, if the problem is encountered again.

Each major step in the plan is committed to the local Git repository.

### Upgrade and migration results

When the process completes, a report is generated that describes every step taken by Copilot. The tool creates a Git commit for every portion of the process, so you can easily roll back the changes or get detailed information about what changed. The report contains the Git commit hashes.

The report also provides a _Next steps_ section that describes the steps you should take after the upgrade finishes.

===

GitHub Copilot app modernization is an interactive GitHub Copilot agent that adds powerful capabilities to Visual Studio. This article answers frequently asked questions. For more information about the modernization agent, see [What is GitHub Copilot app modernization](github-copilot-app-modernization-overview.md).

  The tool requires one of the following GitHub Copilot subscriptions:

  - Copilot Pro
  - Copilot Pro+
  - Copilot Business
  - Copilot Enterprise

  GitHub Copilot app modernization is included in [Visual Studio 2022 version 17.14.16 or newer](https://visualstudio.microsoft.com/downloads/).

sections:
  - name: Modernization agent
    questions:
      - question: What can the agent do?
        answer: |
          Currently, GitHub Copilot app modernization helps you upgrade your .NET (.NET, .NET Core, and .NET Framework) projects to newer versions of .NET. It also helps migrate services to Azure. It also upgrades dependencies and fixes errors in the code post-migration. The agent performs the following steps in a GitHub Copilot chat session:

          - Analyzes your projects and proposes an modernization plan.
          - According to the plan, runs a series of tasks to modernize your projects.
          - Operates in a working branch under a local Git repository.
          - Automatically fixes issues during the code transformation.
          - Reports progress and allow access to code changes & logs.
          - Learns from the interactive experience with you (within the context of the session) to improve subsequent transformations.

      - question: What limitations are there?
        answer: |
          - Only Git repositories are supported.
          - There's no guarantee that the upgrade or migration suggestions are considered best practices.
          - The LLM doesn't persist learning from the upgrade. Meaning, code fixes and corrections you provide during the upgrade process don't persist and can't be remembered for future upgrades.
          - It only runs on Windows.

      - question: Which model should I use?
        answer: |
          You should use a good coding model, such as Claude Sonnet 4.0 or Claude Sonnet 3.7.

      - question: Can I train the model based on my code base?
        answer: |
          No. Unlike traditional AI tools where you might enter freeform prompts, the agent operates in a more structured way. The AI is embedded within the build-and-fix process, meaning the prompts it uses are predefined and tied to the upgrade plan. So it's not something you can train on your codebase, and it's not something you can manually steer with custom instructions, beyond the changes you can make to the plan Markdown file.

          However, the agent does have some adaptability within a session. If you manually adjust a fix, it learns from that interaction in the short term and applies similar corrections if it encounters the same issue again. Think of it as refining its approach within the scope of that upgrade.

      - question: Does the agent store my source code?
        answer: |
          The agent never stores a user's codebase and never uses your code for training the model. Once an upgrade or migration is complete, session data is deleted.

      - question: Can I provide feedback?
        answer: |
          Yes! Use the [Suggest a feature](/visualstudio/ide/suggest-a-feature) and [Report a Problem](/visualstudio/ide/report-a-problem) features of in Visual Studio to provide feedback.

      - question: What data is collected?
        answer: |
          The agent only collects telemetry information about project types, intent to upgrade, and upgrade duration. The data is aggregated through Visual Studio itself and doesn't contain any user-identifiable information. For more information about Microsoft's privacy policy, see [Visual Studio Customer Experience Improvement Program](/visualstudio/ide/visual-studio-experience-improvement-program?view=vs-2022).

      - question: Can I disable telemetry?
        answer: |
          Yes, you can disable telemetry. In Visual Studio, select **Help** > **Privacy** > **Privacy Settings** > **"No, I would not like to participate."**

  - name: Upgrade .NET apps
    questions:
      - question: What can the agent upgrade?
        answer: |
          GitHub Copilot app modernization helps you upgrade your .NET projects or migrate them to Azure. Besides upgrading the target framework, the agent can work with the following types of projects:

          - Azure Functions.
          - Console apps and class libraries.
          - Web technologies such as:
            - MVC
            - Blazor
            - Razor Pages
            - Web API
          - Desktop technologies such as Windows Forms and Windows Presentation Foundation.
          - Test projects such as MSTest and NUnit.
          - .NET Framework projects.

  - name: Migrate to Azure
    questions:
      - question: What can the agent migrate?
        answer: |
          The agent can assist in migrating and deploying your .NET applications to Azure, including:

          - Web apps
          - API apps
          - Azure Functions
          - Containerized applications

          The migration scenarios include:

          - Modernizing databases
          - Storage
          - Identity
          - Messaging
          - Event streaming
          - Email
          - Logging
          - Security

          For more information about these scenarios, see [Predefined tasks for migration](github-copilot-app-modernization-overview.md#predefined-tasks-for-migration).

      - question: Can I monitor assessment progress?
        answer: |
          Yes, you can monitor the progress of the assessment through the Visual Studio interface. The agent provides real-time feedback and updates on the status of the migration process.

          While the assessment is running, you can monitor its progress by viewing the command-line output:

          1. In Visual Studio, go to **View** > **Output** to open the Output window.
          2. In the Output window, find the **Show output from:** dropdown.
          3. Select **AppModernizationExtension** from the dropdown list.
          4. The command-line output from the assessment tool appears here, showing real-time progress.

          You can also access the **Output** window using the keyboard shortcut <kbd>Ctrl+Alt+O</kbd>.

===

# Predefined tasks for GitHub Copilot app modernization for .NET (Preview)

This article describes the predefined tasks available for GitHub Copilot app modernization for .NET (Preview).

Predefined tasks capture industry best practices for using Azure services. Currently, App Modernization for .NET (Preview) offers predefined tasks that cover common migration scenarios. These tasks address the following subjects, and more:

- Database migration
- Storage migration
- Secret management
- Message queue integration
- Caching migration
- Identity management
- Log management

## Predefined task list

App Modernization for .NET currently supports the following predefined tasks:

- **Migrate to Managed Identity based Database on Azure, including Azure SQL DB, Azure SQL MI and Azure PostgreSQL**
  
  Modernize your data layer by migrating from on-premises or legacy databases (such as DB2, Oracle DB, or SQL Server) to Azure SQL DB, Azure SQL Managed Instance or Azure PostgreSQL, using secure managed identity authentication.

- **Migrate to Azure File Storage**
  
  Move file I/O operations from the local file system to Azure File Storage for scalable, cloud-based file management.

- **Migrate to Azure Blob Storage**
  
  Replace on-premises or cross-cloud object storage, or local file system file I/O, with Azure Blob Storage for unstructured data.

- **Migrate to Microsoft Entra ID**
  
  Transition authentication and authorization from Windows Active Directory to Microsoft Entra ID (formerly Azure AD) for modern identity management.

- **Migrate to secured credentials with Managed Identity and Azure Key Vault**
  
  Replace plaintext credentials in configuration or code with secure, managed identities and Azure Key Vault for secrets management.

- **Migrate to Azure Service Bus**
  
  Move from legacy or third-party message queues (such as MSMQ or RabbitMQ) or Amazon SQS (AWS Simple Queue Service) to Azure Service Bus for reliable, cloud-based messaging.

- **Migrate to Azure Communication Service email**
  
  Replace direct SMTP email sending with Azure Communication Service for scalable, secure email delivery.

- **Migrate to Confluent Cloud/Azure Event Hub for Apache Kafka**
  
  Transition from local or on-premises Kafka to managed event streaming with Confluent Cloud or Azure Event Hubs.

- **Migrate to OpenTelemetry on Azure**

  Transition from local logging frameworks like log4net, serilog, windows event log to OpenTelemetry on Azure.

- **Migrate to Azure Cache for Redis**

  Replace in-memory or local Redis cache implementations with Azure Cache for Redis for high availability, scalability, and enterprise-grade security.

===

# Quickstart: Assess and migrate a .NET project with GitHub Copilot app modernization for .NET

In this quickstart, you assess and migrate a .NET project by using GitHub Copilot app modernization for .NET. You complete the following tasks:

- Assess a sample project (Contoso University)
- Start the migration process

## Prerequisites

[!INCLUDE[github-copilot-app-mod-prereqs](../../../includes/github-copilot-app-mod-prereqs.md)]

## Assess app readiness

GitHub Copilot app modernization for .NET assessment helps you find app readiness challenges, learn their impact, and see recommended migration tasks. Each migration task includes references to set up Azure resources, add configurations, and make code changes. Follow these steps to start your migration:

1. Clone the [.NET migration copilot samples](https://github.com/Azure-Samples/dotnet-migration-copilot-samples) repository to your computer.

1. In Visual Studio, open the **Contoso University** solution from the samples repository.

1. In Solution Explorer, right-click the solution node and select **Modernize**.

    :::image type="content" source="media/modernize-solution.png" alt-text="Screenshot that shows the modernize option in the context menu.":::

1. The GitHub Copilot Chat window opens with a welcome message and predefined options. Select **Migrate to Azure** from the available choices and send it to Copilot.

    :::image type="content" source="media/modernization-welcome.png" alt-text="Screenshot that shows the welcome message with migration options.":::

    > [!TIP]
    > Instead of steps 3 and 4, you can open **GitHub Copilot Chat** directly and send `@Modernize Migrate to Azure` to start the assessment and migration flow.

1. A new Copilot chat session opens and shows the welcome message. The assessment starts automatically and analyzes your project for migration readiness.

    :::image type="content" source="media/assessment-in-process.png" alt-text="Screenshot that shows assessment in progress with status indicators.":::

1. When the assessment finishes, you see a comprehensive assessment report UI page and a list of migration tasks in the chat window.

    :::image type="content" source="media/assessment-report.png" alt-text="Screenshot that shows the generated assessment report with detailed findings.":::

## App migrations

GitHub Copilot app modernization for .NET includes [predefined tasks](predefined-tasks.md) for common migration scenarios and follows Microsoft's best practices.

### Start a migration task

Start a migration task in one of the following ways:

**Option 1. Run from the Assessment Report**

Select the **Run Task** button in the Assessment Report from the previous step to start a migration task.

**Option 2. Send in Copilot Chat**

Send the migration task number (for example, 1.1) or its name in the chat.

:::image type="content" source="media/quickstart-chat-experience.png" alt-text="Screenshot of sending a message in Copilot Chat to start a migration task.":::

### Plan and progress tracker generation

- When you start the migration, GitHub Copilot starts a session named "App modernization: migrate from `<source technology>` to `<target technology>`" in agent mode with predefined prompts.
- The tool creates two files in the `.appmod/.migration` folder:
  - `plan.md` - the overall migration plan
  - `progress.md` - a progress tracker; GitHub Copilot marks items as it completes tasks
- Edit these files to customize your migration before you continue.

### Start code remediation

- If you're satisfied with the plan and progress tracker, enter a prompt to start the migration, such as:

    ```console
    The plan and progress tracker look good to me. Go ahead with the migration.
    ```

- GitHub Copilot starts the migration process and might ask for your approval to use knowledge base tools in the Model Context Protocol (MCP) server. Grant permission when prompted.
- Copilot follows the plan and progress tracker to:
  - Manage dependencies
  - Apply configuration changes
  - Make code changes
  - Build the solution, fix all compilation and configuration errors, and ensure a successful build
  - Fix security vulnerabilities

## Default chat messages

GitHub Copilot app modernization for .NET gives you default chat message options to streamline your workflow.

:::image type="content" source="media/quickstart-followup.png" alt-text="Screenshot that shows default chat message options in the Copilot Chat.":::

You can choose one of the predefined options and send it in the chat:

- **Run modernization assessment**: Starts a new assessment of your application to identify migration readiness issues and Azure compatibility challenges.
- **View assessment report**: Opens the previous assessment report and shows a summary of migration tasks based on the results. If no previous assessment exists, it runs a new assessment first.
- **Browse top migration tasks**: Shows recommended migration tasks and common modernization scenarios, regardless of any specific assessment results.

> [!TIP]
> These default messages help you quickly navigate common workflows without typing custom prompts. You can also enter your own messages to interact with Copilot for specific questions or needs.

===

# Quickstart: Containerize your project using GitHub Copilot app modernization for .NET

In this quickstart, you learn how to containerize your project using GitHub Copilot app modernization for .NET. The app modernization tooling uses GitHub Copilot's AI capabilities to:

- Analyze your project structure and dependencies
- Generate Dockerfile configurations
- Create build-ready Docker images
- Guide you through the containerization process

## Prerequisites

Before you begin, make sure you have:

[!INCLUDE[github-copilot-app-mod-prereqs](../../../includes/github-copilot-app-mod-prereqs.md)]

## Containerize your project

The GitHub Copilot app modernization for .NET containerization feature helps you containerize your project. To start the containerization process, complete the following steps:

1. Open your project in Visual Studio.

1. Enable **appModernizationDeploy** in the GitHub Copilot toolbox.

    :::image type="content" source="../../media/appmod-dotnet-containerization-tool-selection.png" alt-text="Screenshot that shows containerization tool selection.":::

1. Start containerization by using one of these approaches:

    - **Containerize from Assessment Report**: In the assessment report, select **Run Task** for the Docker Containerization issue.

        :::image type="content" source="media/containerize-assessment-report.png" alt-text="Screenshot that shows containerization task in assessment report.":::

    - **Use a containerization prompt**: You can input the following prompt in Copilot chat to containerize your project:

        *Scan my project and help me plan how to containerize my application using the #appmod-get-containerization-plan tool. Execute the plan. The end goal is to have Dockerfiles that are able to be built.*

        :::image type="content" source="media/containerization-prompt.png" alt-text="Screenshot that shows how to start the containerization process in GitHub Copilot using a prompt.":::

1. After you start the process, GitHub Copilot can ask for your approval to use tools or run commands. Grant permission when prompted.

1. GitHub Copilot analyzes your project and generates a plan. The plan includes a breakdown of your project and steps for containerizing your project.

1. GitHub Copilot follows the steps to generate a Dockerfile and validate that your Docker image builds successfully.

1. When GitHub Copilot finishes containerizing your project, it provides a summary of what it did.

## Notes

- Use Claude Sonnet 4 or later models for the best results.
- Copilot might take a few iterations to fix containerization errors.

===

# Quickstart: Use GitHub Copilot app modernization for .NET to deploy your project to Azure

In this quickstart, you learn how to deploy your project to Azure with GitHub Copilot app modernization for .NET. This tool lets you deploy migrated projects to Azure and automatically fixes deployment errors during the process.

## Prerequisites

[!INCLUDE[github-copilot-app-mod-prereqs](../../../includes/github-copilot-app-mod-prereqs.md)]

## Deploy your project

The App Modernization for .NET deployment feature helps you deploy your migrated app to Azure. Follow these steps to start the deployment process:

1. In Visual Studio, open your migrated project.

1. Start the deployment with one of the following approaches:

    - **Deploy after migration**: Deploy your project after completing your migration task. GitHub Copilot asks if you'd like to deploy your project to Azure upon completing a migration task. Instructing Copilot to continue starts the deployment process.

        :::image type="content" source="media/start-deploy.png" alt-text="Screenshot that shows how to start the deployment process in GitHub Copilot.":::

    - **Use a deployment prompt**: You can enter the following prompt in Copilot chat to deploy your project to Azure:

        *Scan my project to identify all Azure-relevant resources, programming languages, frameworks, dependencies, and configuration files needed for deployment, and develop an architecture diagram for me using #appmod-generate-architecture-diagram. Based on that diagram, help me develop and execute a plan using #appmod-get-plan to deploy my project to Azure. deployTool: azcli, hosting service: non-aks.*

        :::image type="content" source="media/start-deploy-prompt.png" alt-text="Screenshot that shows how to start the deployment process in GitHub Copilot by using a prompt.":::

1. After you start the deployment, GitHub Copilot might ask for your approval to use tools or run commands. Grant permission when prompted.

1. GitHub Copilot creates a plan. The plan explains the deployment strategy, including deployment goals, project information, Azure resource architecture, Azure resources, and execution steps.

1. You can edit the plan directly or ask GitHub Copilot to edit it to customize your deployment before you proceed.

1. When you're satisfied with the plan, instruct GitHub Copilot to continue.

1. GitHub Copilot follows the plan and runs the deployment process.

1. When deployment finishes, GitHub Copilot provides a summary of the deployment process.

## Notes

- Use Claude Sonnet 4 or later models for the best results.
- Copilot can need a few iterations to fix deployment errors.

===

