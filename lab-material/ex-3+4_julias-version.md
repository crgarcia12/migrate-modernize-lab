
===

# Excercise 3 - .NET App modernization

Before we begin, make sure you are logged into GitHub: [https://github.com/enterprises/skillable-events](https://github.com/enterprises/skillable-events "https://github.com/enterprises/skillable-events")

> [!Knowledge]
> Use the Azure Portal credentials from the resources tab.
> 
> Make sure you don't close the GitHub site. Otherwise GitHub Copilot might not work due to the restrictions of the lab environment.

Let us get our hands dirty on some code.

We want to use GitHub Copilot to modernize our .NET application. To achieve that we have two options.

## 1) Using Visual Studio

You can install an extension that is called *GitHub Copilot app modernization*. This extension uses a dedicated agent inside GitHub Copilot to help you upgrade this project to a newer .NET version and will afterwards support you with the migration to Azure.

With this extension you can:

* Upgrade to a newer version of .NET
* Migrate technologies and deploy to Azure
* Modernize your .NET app, especially when upgrading from .NET Framework
* Assess your application's code, configuration, and dependencies
* Plan and set up the right Azure resource
* Fix issues and apply best practices for cloud migration
* Validate that your app builds and tests successfully

## 2) Using Visual Studio Code

You can use GitHub Copilot agent mode to modernize your .NET application and deploy it to Azure.

Choose your path :)

===

# 3.1 Clone the repository

The first application we will migrate is *Contoso University*.

Open the following [link to the repository](https://github.com/crgarcia12/migrate-modernize-lab "link to the repository").

Fork your own copy of the repository. On the upper right click on the fork dropdown and then on *Create a new fork*.

!IMAGE[Screenshot 2025-11-14 at 10.16.45.png](instructions310257/Screenshot 2025-11-14 at 10.16.45.png)

Ensure you are the Owner and give your repository a new name or keep *migrate-modernize-lab* and click on *Create fork*. In a few seconds you should be able to see your forked repository in your GitHub account.

!IMAGE[Screenshot 2025-11-14 at 10.17.19.png](instructions310257/Screenshot 2025-11-14 at 10.17.19.png)

## 1) Visual Studio

1. Open Visual Studio  
2. Select Clone a repository  
3. Go back to GitHub to your forked repository. Click on *Code* and in the tab *Local* choose *HTTPS* and *Copy URL to clipboard*. Paste your repository link in the **Repository Location**  
   > The URL should look something like this: *https://github.com/your_handle/your_repo_name.git*

   !IMAGE[Screenshot 2025-11-14 at 10.42.04.png](instructions310257/Screenshot 2025-11-14 at 10.42.04.png)

4. Click Clone and wait a moment for the cloning to finish

5. Let us open the app  
   1. In the menu select File and then Open  
   2. Navigate to **migrate-modernize-lab**, **src**, **Contoso University**  
   3. Find the file **ContosoUniversity.sln**  
   4. In the View menu click *Solution Explorer*  
   5. Rebuild the app
   
   TODO: add more screenshots
  
> TODO The build fails? Make sure all Nuget.org packages are installed. (insert how to do this)

It is not required for the lab, but if you want you can run the app in IIS Express (Microsoft Edge).

!IMAGE[0030.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0030.png)

Edge will open and you will see the application running at `https://localhost:44300`

## 2) Visual Studio Code

1. Go back to GitHub to your forked repository. Click on *Code* and in the tab *Local* choose *HTTPS* and *Copy URL to clipboard*.  
2. Open Visual Studio Code  
3. In the navigation bar on the left select *Source Control* and *Clone Repository*  
4. Paste your repository link in the input field and select *Clone from URL*. Select your local repository destination, wait a moment for the cloning to finish, and when the dialog appears click on *Open*.  
   > The URL should look something like this: *https://github.com/your_handle/your_repo_name.git*

!IMAGE[Screenshot 2025-11-14 at 10.57.23.png](instructions310257/Screenshot 2025-11-14 at 10.57.23.png)
!IMAGE[Screenshot 2025-11-14 at 11.01.31.png](instructions310257/Screenshot 2025-11-14 at 11.01.31.png)

5. The just cloned project opens in VS Code

> The project as it is cannot be run out of VS Code in this state.

===

# 3.2 Code assessment

Before we can start with the modernization itself we need to run an assessment to understand the application's technical foundation, dependencies, and the implemented business logic.

## 1) Visual Studio

The first step is to do a code assessment. For that we will use the *GitHub Copilot app modernization* extension.

TODO: check if it is preinstalled or if we need another step to install it and if we are already logged in to GitHub

1. Right click in the project and select *Modernize*

!IMAGE[0040.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0040.png)

TODO: add descriptions of what happens next

## 2) Visual Studio Code

1. In the navigation bar on the left select *Extensions* and install *GitHub Copilot* and *GitHub Copilot Chat*.
2. Open the GitHub Copilot Chat. A popup will appear asking you to sign in to GitHub. Follow the steps to sign in.
TODO: add credentials! 
3. Select Agent mode and the model of your choice  
   > We recommend Claude Sonnet 4 or 4.5. They generally take longer to respond, but the results are usually good. But feel free to experiment with different models.

4. Use this initial prompt to start the assessment step:

   *I would like to modernize this .NET application to .NET 9. Assess this project and tell me about the technical foundation, dependencies that need to be updated, and give me a brief summary of the implemented business logic and everything else you think is relevant for a modernization. Save the assessment results in an assessment.md in the workspace's root folder. Include all the relevant information in the assesment.md, but stay as short and precise as possible. Ensure there is no redundant information. Do not make any code changes yet.*

5. Wait until GitHub Copilot is done and have a look at the *assessment.md*. Results may vary. If you are for any reason not happy with the results, you have multiple options:

   a) Open a new GitHub Copilot chat (you can click plus on top of the chat window) and run the initial prompt again, but change the file name to *assessment1.md* (or something similar). After the second assessment run is done, ask GitHub Copilot to compare both documents and fact check itself. An example prompt could be:

   *Check the assessment.md and assessment1.md files and compare them. If there are significant differences, check again with the code base and reevaluate the results. Merge all important information into one assessment.md, ensure there is no redundant information, stay precise and delete the other file.*

**OR**

   b) Open a new GitHub Copilot chat (you can click plus on top of the chat window). Delete the *assessment.md* and iterate on the initial prompt yourself so that GitHub Copilot understands better what you want to learn about this problem, then run the assessment again.

If you are happy with the assessment results, continue with the next step of the lab.

===

# 3.3 Upgrade the app to .NET 9

The next step is to upgrade the application to .NET 9 and update the outdated dependencies and packages as they are known to have security vulnerabilities.

## 1) Visual Studio
1. Right click in the project and select *Modernize*
2. Click *Accept upgrade settings and continue*

!IMAGE[0050.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0050.png)

Let s review copilot proposal

TODO: Point to some details

3. Review the proposed plan.
4. Ask what is the most risky part of the upgrade
5. Ask if there are security vulnerabilities in the current solution
6. Ask copilot to perform the upgrade
7. Try to clean and build the solution
8. If there are erros, tell copilot to fix the errors using the chat
9. Run the application again, this time as a standalone DotNet application

!IMAGE[0060.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0060.png)

> [!Hint] If you see an error at runtime. Try asking copilot to fix it for you.
>
> For example, you can paste the error message and let Copilot fix it. For example: `SystemInvalidOperation The ConnectionString has not been initialized.` 

TODO: See the lists of commit, if we managed to fork the repo

## 2) Visual Studio Code

1. Open a fresh new window of GitHub Copilot Chat
2. Use the following prompt to plan the upgrade:

*I would like to upgrade this .NET application to .NET 9. Consider all the information we already collected in the assessment.md. Create a step-by-step plan. Make sure to include updating outdated dependencies and packages that are known to have security vulnerabilities. Do not make any code changes for now, just create the plan. Add the step-by-step plan to the assessment.md. If there is already a migration plan in the assessment.md, edit and extend it.*

3. After the plan is created, use the following prompt to perform the upgrade:

*Now upgrade the application to .NET 9 following the step-by-step plan we created before in the assessment.md. Make sure to update all outdated dependencies and packages that are known to have security vulnerabilities. After you finish, ensure the application builds without errors. If there are any errors, fix them.*

> [!Hint] If you you are an opinionated dev you can give GitHub Copilot more specific instructions e.g. about the folder structure, naming conventions, etc.

4. Observe the changes GitHub Copilot is doing. Inbetween you have to allow certain changes like the editing of sensitive files or the execution of terminal commands. It also may ask you that it has now worked for a while and if it should continue. Allow it to continue. If you observe that it is stuck or working in the wrong direction you can always stop it by clicking the stop button on the lower right and adjust your prompt or start over completely by undoing the changes and opening a new chat.

!IMAGE[Screenshot 2025-11-15 at 17.13.37.png](instructions310257/Screenshot 2025-11-15 at 17.13.37.png)

5. After GitHub Copilot has finished the upgrade it will try to build the application (we prompted it to do so). If not, you can prompt it to do it:

*Test and run the application.* or *Build and run the application with **dotnet run**.*

If the build fails, it will try to fix the errors itself. It will have applied a lot of changes. Take your time to review them and click on *Keep* once you are done.

!IMAGE[Screenshot 2025-11-15 at 17.37.14.png](instructions310257/Screenshot 2025-11-15 at 17.37.14.png)

> [!Hint] If you have the feeling that GitHub Copilot or VS Code itself is buggy, you can reload the window. This helps in 98% of the cases, for the other 2% just restart VS Code.
> !IMAGE[Screenshot 2025-11-15 at 17.41.41.png](instructions310257/Screenshot 2025-11-15 at 17.41.41.png)

6. If the application is up and running, well done! You have successfully upgraded the application to .NET 9. Click next to continue.

===

# 3.4 Deploy .NET app to Azure

Next we want to deploy our modernized application to Azure App Service.

## 1) Visual Studio

1. Right click in the project, and select `Modernize`
2. This time, we will select Migrate to Azure. Don't forget to send the message!
> !IMAGE[0070.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0070.png)

3. Copilot made a detailed report for us. Let's take a look at it
       Notice that the report can be exported and shared with other developers in the top right corner
4. Now, let's run the Mandatory Issue: Windows Authenticatio. Click in `Run Task`
> !IMAGE[0080.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0080.png)

## 2) Visual Studio Code

1. Open the Extensions tab again and install the extension *Bicep* (Microsoft's IaC language) and the *Azure MCP Server*
2. Open a fresh new window of GitHub Copilot Chat and click on *Tools*. Checkmark the *Bicep* and *Azure MCP Server* tools and save the changes by clicking on *OK*. This ensures GitHub Copilot has all the tools it needs to deploy to Azure.

!IMAGE[Screenshot 2025-11-15 at 18.06.19.png](instructions310257/Screenshot 2025-11-15 at 18.06.19.png)

> [!Hint] The more tools you enable, the longer GitHub Copilot needs to respond. Be mindful of your tool selection.

3. Use the following prompt to deploy the application to Azure:

*I would like to deploy the modernized .NET application to Azure App Service. Please have a look at the existing infra folder and check if it needs to be updated. If so, apply the necessary changes. Then create the infrastructure and deploy the application with the Azure Developer CLI.*

Again you may be asked to allow certain executions of commands and changes. Allow them. When the deployment starts you will output in the terminal window that asks for your input. If GitHub Copilot has not already created an environment, create a new one. Select your Azure subscription, create a new resource group. If the deployment fails, GitHub Copilot will again try to fix the errors itself. 

> [!Hint] If the deployment fails, no worries. The Azure Developer CLI remembers your previous inputs. Just let GitHub Copilot re-try it.

> [!Hint] The actual deployment will start with the execution of the command *azd up*, this may take a while. You may see problems, that there is maybe no quota available in a specific region. Just let GitHub Copilot change the region and re-try it. Just stop it, and bring it back on track if it tries to change from Azure App Service to another PaaS service.

4. When the deployment is successful, you will see the URL of your deployed application in the terminal window. Open it in your browser to verify that everything is working as expected.

!IMAGE[Screenshot 2025-11-15 at 18.32.33.png](instructions310257/Screenshot 2025-11-15 at 18.32.33.png)

5. Congratulations! You have successfully modernized and deployed your .NET application with the help of GitHub Copilot. Click next to continue.


===
# Excercise 4 - Java App modernization (julia)