@lab.Title

## Welcome @lab.User.FirstName! 

Let's familiarize yourself with the lab environment.
At the top you will have two tabs: **Instructions** and **Resources**

In Resources you will find useful information like credentials and links. You can switch between them at any time.


Now, let's begin. Log into the virtual machine using the following credentials: 
Username: +++@lab.VirtualMachine(Win11-Pro-Base).Username+++
Password: +++@lab.VirtualMachine(Win11-Pro-Base).Password+++

===

# Lab Overview: What are we going to do today?

The objective of this lab is to explore the different steps involved in a real-life migration

#### Exercise 1: Prepare a migration:
1. Learn how to install an appliance that collects data from an on-premises datacenter using Azure Migrate

#### Exercise 2: Analyze migration data and build a business case:
1. Learn how to build a Business Case and decide on the next step when planning a migration

#### Exercise 3: Migrate a .NET application:
1. Modernize a .NET application using GitHub Copilot and deploy it to Azure.

#### Exercise 4: Migrate a Java application:
1. Modernize a Java application using GitHub Copilot and deploy it to Azure.


Each exercise is independent. If you get stuck in any of them, you can proceed to the next one

===
# Exercise 1: Prepare a migration

Click Next to start the exercise

===
### Understand our lab environment

The lab simulates a datacenter by having a VM hosting server with several VMs inside simulating different applications

1. [ ] Open Edge and navigate to the Azure Portal using the following link. This link enables some preview features we will need later: ++https://aka.ms/migrate/disconnectedAppliance++
1. [ ] Login using the credentials in the Resources tab. Instead of using the Password, you may be requested to use the Temporary Access Password (TAP)

> [+Hint] Trouble finding the Resources tab?
>
> Navigate to the top right corner of this screen where you can always find the credentials and important information
> ![text to display](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0010.png)

1. [ ] Open the list of resource groups. You will find one called `on-prem`
2. [ ] Explore the resource group. Find a VM called `lab@lab.LabInstance.Id-vm`
3. [ ] Open the VM. Click **Connect**. Wait until the page is fully loaded
4. [ ] Click **Download RDP file**, wait until the download completes and open it
5. [ ] Login to the VM using the credentials
    1. [ ] Username: `adminuser`
    2. [ ] Password: `demo!pass123`


You have now logged into your on-premises server!
Let's explore what's inside in the next chapter

===
### Understand our lab environment: The VM

This virtual machine represents an on-premises server.
It has nested virtualization. Inside you will find several VMs.

> ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0020.png)

In the Windows menu, open the `Hyper-V Manager` to discover the inner VMs.

> [+Hint] How to open Hyper-V manager
>
> Open the **Server Manager** from the Windows menu. Select **Hyper-V**, right click in your server and click in **Hyper-V Manager**
>
> ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00915.png)

TODO: Open one of the VMs and see the application running

We will now create another VM and install the Azure Migrate Appliance

===
### Create Azure Migrate Project
Let's now create an Azure Migrate project

1. [ ] Go back to the Azure Portal and in the search bar look for +++Azure Migrate+++
2. [ ] Click **Create Project**
3. [ ] Use the existing Resource Group: +++on-prem+++
4. [ ] Enter a project name. For example +++migrate-prj+++
5. [ ] Select a region. For example +++@lab.CloudResourceGroup(on-prem).Location+++


===
### Download the Appliance

TODO: Explain what the appliance is and what we are doing


1. [ ] Once in the Azure Migrate Project portal
1. [ ] Select **Start discovery** -> **Using appliance** -> **For Azure**

    > [+Hint] Screenshot
    >
    > ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0090.png)

===
### Download the Appliance

In the Discover page

> [+Hint] Screenshot
>
> ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0091.png)

1. [ ] Select **Yes, with Hyper-V** in the dropdown
1. [ ] Enter a name for the appliance. For example +++lab-appliance+++ and click **Generate key**
1. [ ] Take note of the **Project key**. You cannot retrieve it again.
       You can store it here: @lab.TextBox(MigrateApplianceKey)

1. [ ] Select **VHD file**    
2. [ ] You need to download the appliance VHD **inside your on-premises server**. 

	Copy the download link by right-clicking the **Download** button and clicking **Copy Link**. 

===
### Extract the Appliance

1. [ ] Go back to the Hyper-V host VM. This is where you have the Hyper-V Manager with the list of all VMs.

3. [ ] Open the browser and paste the link. This will download the VHD. 
	
    ***Make sure you are doing this inside the Hyper-V VM!*** You can also use this link: +++https://go.microsoft.com/fwlink/?linkid=2191848+++

6. [ ] Copy the downloaded file to the F drive and extract its contents

> [+Hint] Screenshot
>
> ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00914.png)

===

### Install the Appliance
1. [ ] Open the Hyper-V manager
    > [+Hint] How to open Hyper-V manager
    >
    > Open the **Server Manager** from the Windows menu. Select **Hyper-V**, right click in your server and click in **Hyper-V Manager**
    >
    > ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00915.png)

1. [ ] Select **New** -> **Virtual Machine**
    > [+Hint] Create virtual machine
    >
	> ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0092.png)

1. [ ] Click **Next** and enter a name. For example, +++AZMAppliance+++
1. [ ] Click **Store the virtual machine in a different location** and specify +++F:\Hyper-V\Virtual Machines\appliance+++
1. [ ] Use **Generation 1** and click **Next**
1. [ ] Select +++16384+++ MB of RAM and click **Next**
1. [ ] In **Connection**, select ++NestedSwitch++ and click **Next**
1. [ ] Select **Use an existing virtual hard drive** 
1. [ ] Click **Browse** and look for the extracted zip file on the **F:\\** drive.

    > [+Hint] Create virtual machine
    >
	> ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00925.png)

1. [ ] Click **Finish** and start the new VM by right-clicking and selecting **Start** 
1. [ ] Double-click the VM to open a Remote Desktop connection to it. Initially, it will have a black screen for several minutes until it starts

You now have an appliance up and running on your server. This appliance will scan all the VMs and collect all needed information to plan a migration. Now, we need to configure the appliance so it can run a scan on the environment


===

### Connect to the appliance

We will now configure the appliance.

1. [ ] Start by accepting the license terms
1. [ ] Assign a password for the appliance. Use +++Demo!pass123+++
1. [ ] Send a **Ctrl+Alt+Del** command and log into the VM

	> [+Hint] Do you know how to send Ctrl+Alt+Del to a VM?
  	>
  	> ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0093.png)

===

### Connect the appliance to Azure Migrate

Once we log in, the machine will configure itself. Wait until the browser displays the Azure Migrate Appliance Configuration. This will take about 4 minutes

1. [ ] Agree to the terms of use and wait until it checks connectivity to Azure
	> [+Hint] Screenshot
  	>
  	> ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00932.png)

1. [ ] Paste the key we obtained while creating the appliance in the Azure Portal and click **Verify**. 

   During this process, the appliance software is updated. This will take several minutes and will require you to **refresh** the page.

    > [+Hint] Your key was: 
    > ++@lab.Variable(MigrateApplianceKey)++


	> [+Hint] If Copy & Paste does not work
  	>
  	> You can type the clipboard in the VM
    > ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0094.png)

1. [ ] Login to Azure. If the **Login** button is grayed out, you need to **Verify** the key from the previous step again

    > [+Hint] Hint
    >
	> Remember that the credentials are in the **Resources** tab.
    > ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00945.png)


You have now connected the appliance to your Azure Migrate project. In the next steps we will provide credentials for the appliance to scan your Hyper-V environment

===

### Configure the appliance

Once the appliance finishes registering, you will be able to see it in the Azure Portal, but it still cannot scan your servers because it doesn't have authentication credentials.
We will now provide Hyper-V host credentials. The appliance will use these credentials to scan Hyper-V and discover all servers

1. [ ] In step 2 **Manage credentials and discovery sources**, click **Add credentials**

    username: +++adminuser+++
    
    password: +++demo!pass123+++

    ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00946.png)


1. [ ] Click **Add discovery source** and add the IP address of the Hyper-V host: +++172.100.2.1+++

    > [+Hint] Hint
    >
	>![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00947.png)
    >![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00948.png)

1. [ ] We're almost there! Now we need to add credentials to analyze the software inside the VMs and the databases associated with the applications. Add credentials for Windows (Non-domain), Linux (Non-domain), SQL Server and PostgreSQL Server

	username: +++adminuser+++

    password: +++demo!pass123+++

    > [+Hint] Hint
    >
	>![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00949.png)
    >![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/009491.png)


1. [ ] Click **Start discovery**
1. [ ] Close the VM, we are going back to the Azure portal

===

### Validate the appliance is running
The appliance will start collecting data and sending it to your Azure Migrate project.

1. [ ] Close the virtual machine and go back to the Azure Portal
2. [ ] Search for **Azure Migrate** -> **All projects** and open your project. If you followed the naming guide, it should be called **migrate-prj**
	> [+Hint] Screenshot
    >
	>![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0095.png)

4. [ ] In the left panel, find **Manage** -> **Appliance** and open the appliance you configured.

	> [+Hint] Screenshot
    >
    >![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00951.png)


4. [ ] Validate that all services are running.
	> [+Hint] Screenshot
    >
    >![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00952.png)

===

Performing an assessment takes time. To get data we need to run the appliance for hours.

In real-life scenarios, it's better to keep it running for several days. This way Azure Migrate will have a better understanding of application resource requirements and will be able to provide better sizing recommendations.

Since we don't have all this time now, we have prepared another Azure Migrate project with data already populated for you.

===

# Exercise 2: Analyze migration data and build a business case

Once we have the appliance running in all our Hyper-V, VMWare or phisical servers, all the data is collected and agregated continuously
Now is time to take a closer look and decide what is going to be our next step.

1. [ ] Go to the Azure Portal, and open the already prepared project: ++lab@lab.LabInstance.Id-azm++

![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0095.png)



===
# Prepare your data

To be able to take a good informed decision, we need clean accurate data.
The appliance will try to collect data from all servers, but there can be problems.
The first step is to look for problems and issues that require our attention.

1. [ ] Open the Azure Migrate project overview
1. [ ] Open the Action center blade from the pannel in the left.

You will find several issues, like VMs that are turned off or VMs that the appliance could not connect to due to worng credentials

In a real world scenario, we should try to fix all the issues at this stage to improve our data accuracy.
For the purpose of this excersise we will move on

===
# Create Applications

Once the workload data is clean, we will group the VMs into applications to be able to identify what should be moved together.
We will do this excersise for Contoso University applciation

1. [ ] Expand the Explore appliacions group in the left pannel
2. [ ] Open the Applications page
3. [ ] Click in Define application -> New application
4. [ ] In Name, enter +++ContosoUniversity+++
5. [ ] In Type, select **Custom**, meaning we have the source code
6. [ ] In Workloads, Find all the +++ContosoUniversity+++ workloads by using the filter nad select them all
    
    > [+Hint] Hint
    >
	>![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/01002.png)
7. [ ] In Properties, select any criticality and complexity, and createthe application


===
# Build a Business Case
We now have data of all VMs, and we have group them into Applications. Time to create a business case.

The Business case helps you understand where Azure can bring the most value to your organization by estimating total cost of ownership (TCO), potential savings, and sustainability impact for your applications and workloads.

1. [ ] In the** Decide and plan** tab, open **Business cases**
       You will notice that there are business cases already created, omit that for now
2. [ ] Click in **Build business case**

You can create two types of business case. You can either create a business case for all your workloads, or if you know what aplications you are interested now, you can scope them.
For this example, we will do the second and create a business case only for the Contoso University application we just created.


3. [ ] Type a name for the business case. For example +++Contoso University+++
4. [ ] Select **Selected Scope**
5. [ ] Click in **Add applications**
6. [ ] Select **ContosoUniversity** application, then click **Next**
7. [ ] Select **West US 2**
8. [ ] IF your company has an special discount on Azure, you can insert it in this screen as well. Let's add a 15% discount
9. [ ] Click **Build business case**

Building the business case takes some minutes. We will not wait, we can go and grab a Business Case that is already created

===
Lets open an existent business case to analyze the results
In this case, we will take a business case with focus in Modernization where the scope is the entire datacenter instead of only one application
1. [ ] Expand **Decide and Plan** and open **Business cases** in the left panel
2. [ ] Enter in there **businesscase-for-paas**

The first tile will display the estimated on-premises vs cloud cost, and a pottential cost saving.
Do you know how are on-prem costs calculated?
1. [ ] Hoover over the i icon and learn more about this
2. [ ] One tile bellow we can see that this business is based on 40 VMs, of which 13 are Linux
3. [ ] We can also note that there are 22 unique webapps and 6 databases across all those servers.

The Saving in case we move to Azure, would be of 212.3K USD. 

Where is that saving coming from? Let's dig into that

===

1. [ ] Expand **Business Case Reports** and open the **Current on-premises vs future** page
2. [ ] Scroll to the table bellow and check the **Compute and licensing** cost savings.
3. [ ] Keep scrolling until the end of the page. In there you can also find the estimated Carbon Dioxide savings

In the next page, **Migration Strategies** you can find more information on the licensing costs, the Hybrid benefits.
Feel free to explore the business case further

The last page of the Business Case is **Azure cost**. This is where you can edit all the parameters acording to your case, to get more acurate values

You can also check the status of the business case you created for ContosoUniversity in case it finished calculating. If not, we can come back afterwards

===

# Assessment

Once we understand the financial implications of moving to the cloud, we can take a look at it form a technical point of view.

An Azure Migrate assessment evaluates your workloads hosted on your on-premises datacenter or other public clouds for migration to Azure. Each Azure Migrate assessment analyzes your source workloads for:

**Migration strategy:** It is a strategy to migrate all the workloads that constitute an application. The strategy is aimed at efficiently migrating all the constituent workloads, which can be a combination of application servers, web apps, databases etc. to Azure.

**Readiness:** Suitability of source workloads for all valid target Azure services.

**Right-sized targets:** The recommended targets are right-sized based on compute and storage performance requirements to optimize for resiliency and cost.

**Azure resource cost:** It is the total resource cost for hosting all the targets on Azure.
Migration tool: It is the recommended tool for migrating the source to the recommended target.

===

# Assessment

1. [ ] Expand **Decide and plan** and open the Assessment page
2. [ ] Open the assessment called **businesscase-businesscase-for-paas**.<br />
       This assessment is created automatically when you create a business case.
3. [ ] Look at the **Recommended path**: PaaS preferred.
4. [ ] 

===
How many Linux VMs are power off? Answer 3 + 01001.png
How many Windows 2016 servers have we discovered? Answer 5 + 01004.png



Todo:

Look at All Inventory
Create Applications
Business case
Assessments
Software
Insights
Wave planning


The first step in a migration, is to make sure we have clean data.

In a real 
Go to the already created lab
Explore assessment
Look at 6R
- Software
	Tagging example
	Vulnerabilities


Explore business case

===

### 
1. [ ] Go to the Azure Portal, and open the already prepared project: ++lab@lab.LabInstance.Id-azm++

![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0095.png)


===

question in progress

@lab.Activity(Question1)
===

question in progress

@lab.Activity(Question2)

===

question in progress

@lab.Activity(Question3)

> [+Hint] Need some help?
> 
> Navigate the the business case `buizzcaseevd`
> Open the Overview page
> Look at the Potential cost savings card and find the savings
===

question in progress

@lab.Activity(Question4)

> [+Hint] Need some help?
> 
> Navigate the the business case `buizzcaseevd`
>
> On the menu in the left, open `Business Case Reports` and navigate to `Current on-premises vs future`
>
> Look for Security row, and pay attention at the last column

===

question in progress

@lab.Activity(Question5)

> [+Hint] Need some help?
> 
> Todo: Some help here
>
> 

===

# Exercise 3 - .NET App modernization

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
# Exercise 4 - Java App modernization (julia)
