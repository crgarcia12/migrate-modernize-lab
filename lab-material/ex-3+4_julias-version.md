===

# Excercise 3 - .NET App modernization

Before we begin, make sure you are logged into GitHub: [https://github.com/enterprises/skillable-events](https://github.com/enterprises/skillable-events "https://github.com/enterprises/skillable-events")

> [!Knowledge]
> Use the Azure Portal credentials from the resources tab.
> 
> Make sure you don't close the GitHub site. Otherwise GitHub Copilot might not work due to the restrictions of the lab environment.

Let us get our hands dirty on some code.

We want to use GitHub Copilot to modernize our .NET application in Visual Studio.

In Visual Studio we have an extension called *GitHub Copilot app modernization*. This extension uses a dedicated agent inside GitHub Copilot to help you upgrade this project to a newer .NET version and will afterwards support you with the migration to Azure.

With this extension you can:

* Upgrade to a newer version of .NET
* Migrate technologies and deploy to Azure
* Modernize your .NET app, especially when upgrading from .NET Framework
* Assess your application's code, configuration, and dependencies
* Plan and set up the right Azure resource
* Fix issues and apply best practices for cloud migration
* Validate that your app builds and tests successfully

===

# 3.1 Clone the repository

The first application we will migrate is *Contoso University*.

Open the following [link to the repository](https://github.com/crgarcia12/migrate-modernize-lab "link to the repository").

In the repository view click on *<> Code* and in the tab *Local* choose *HTTPS* and *Copy URL to clipboard*.
> The URL should look like this: *https://github.com/crgarcia12/migrate-modernize-lab.git*

 !IMAGE[Screenshot 2025-11-14 at 10.42.04.png](instructions310257/Screenshot 2025-11-14 at 10.42.04.png)

1. Open Visual Studio  
2. Select *Clone a repository*  
3. Paste the repository link in the *Repository Location*  
4. Click *Clone* and wait a moment for the cloning to finish
5. Let us check out the Contoso University project. In the *View* menu select *Solution Explorer*. Then right click on the *ContosoUniversity* project and select *Rebuild*

It is not required for the lab, but if you want you can run the app in IIS Express (Microsoft Edge).

!IMAGE[0030.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0030.png)

Edge will open and you will see the application running at `https://localhost:44300`

===

# 3.2 Code assessment + app upgrade to .NET 9

The first step is to do a code assessment, followed by a complete upgrade. For that we will use the *GitHub Copilot app modernization* extension.

1. Right click in the project and select *Modernize*

!IMAGE[0040.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0040.png)

> [!Hint] If GitHub Copilot asks you to sign in, click on *Already have an account? Sign in* and follow the steps to sign in to GitHub.

2. The GitHub Copilot Chat window will open. Click on *Upgrade to a newer .NET version*. It will paste this exact message in the chat window. You can modify the prompt if you want to target a specific .NET version (8, 9 or 10).

**Before you send the message, be sure to select Claude Sonnet 4.5 as the model to use for this task.**

TODO: insert image

3. This task will take a while. In case it asks you to allow operations, allow them by answering in the chat window. If it gets stuck, encourage it with nice words to continue. If you have the feeling it gets stuck like it stops working completely, you can a) call your proctors and we help you decide what to do or b) close VS completely and re-open it, but then we need to continue prompting manually.

4. You know when it's done *dotnet-upgrade-report.md* will show up.

===

# 3.3 Deploy the modernized .NET app to Azure

Next we want to deploy our modernized application to Azure App Service.

1. Right click in the project, and select *Modernize* again

2. In the GitHub Copilot Chat window, click on *Migrate to Azure*. It will paste this exact message in the chat window. Make sure you send it that GitHub Copilot can start working on the task.

3. While GitHub Copilot is working, let's have a lookt at the assessment report it generated. On the upper right you can either import or export the report. But you can also kick of specific tasks to resolve **Cloud Readiness Issues** here. Exactly what we want to do, because we want to deploy to Azure.

!IMAGE[0080.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0080.png)

4. Begin with clicking on *Migrate from Windows AD to Microsoft Entra ID*. If GitHub Copilot does not pick up tasks automatically, you can always come back to the *dotnet-upgrade-report.md* file and click on the tasks you want to resolve.

5. This may take a while. Ensure all mandatory tasks get resolved.

5. Congratulations! You have successfully modernized the .NET application and deployed it to Azure with the help of GitHub Copilot. Click next to continue.

===

# Excercise 4 - Java App modernization 

Before we begin, make sure you are logged into GitHub: [https://github.com/enterprises/skillable-events](https://github.com/enterprises/skillable-events "https://github.com/enterprises/skillable-events")

> [!Knowledge]
> Use the Azure Portal credentials from the resources tab.
> 
> Make sure you don't close the GitHub site. Otherwise GitHub Copilot might not work due to the restrictions of the lab environment.

With all the knowledge we earned in the .NET app modernization process, we will now do it again - this time with a Java application.

This modernization process will only take place in Visual Studio Code.

1. In VS Code open the Extensions tab and ensure the following extenensions are installed:
   - GitHub Copilot
   - GitHub Copilot Chat
   - GitHub Copilot app modernization - upgrade for Java





