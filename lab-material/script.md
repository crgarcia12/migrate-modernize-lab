@lab.Title

## Welcome @lab.User.FirstName! 

Let's familiarize with the lab environment.
In the top you will have two tabs **Instructions** and **Resources**

In Resource you will find useful information like credentials and links. You can always go back and forth between them


Now, let's begin. Log into the virtual machine using the following credentials: 
Username: +++@lab.VirtualMachine(Win11-Pro-Base).Username+++
Password: +++@lab.VirtualMachine(Win11-Pro-Base).Password+++

===

# TODO: Lab start: What are we going to do today?

The objective of the lab is to explore the different steps involved in a real life migration

#### Excercise 1: Prepare a migration:
1. We will learn how to install an appliance that will collect data from an on-prem datacenter using Azure Migrate

#### Excercise 2: Migrate an application:
1. We will learn how to build a Business Case and decide on the next step when planning a migration

#### Excercise 3: Migrate an .NET application:
1. Modernize a .NET application using GitHub Copilot and deploy it to Azure.

#### Exercise 4: Migrate a Java application:
1. Modernize a Java application using GitHub Copilot and deploy it to Azure.


Each excersise is independent. If you get stucked in any of them, you can procede to the next one

===
# Excersie 1: Prepare a migration

Click Next to start the excersise

===
### Understand our lab environment

The lab simulates a datacenter, by having a VM hosting server, and several VMs inside simulating different applications

1. [ ] Open Edge, and head to the Azure Portal using the following link. This link enables some of the preview features we will need later on: ++https://aka.ms/migrate/disconnectedAppliance++ TODO: this link does not work
1. [ ] Login using the credentials in the Resources tab. Notice that instead of using the Password, you are probably going to be requested to use the Temporary Access Password (TAP)

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

> ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0020.png)

In the windows menu, open the `Hyper-V Manager` to discover the inner VMs.

TODO: Open one of the vms and see the application running

We will now create another VM, and install the Azure Migrate Appliance

===
### Create Azure Migrate Project
Let's now create an Azure Migrate project

1. [ ] Head back to the Azure Portal, and in the serch bar look for +++Azure Migrate+++
2. [ ] Click in ++Create Project++
3. [ ] Use the existent Resource Group, +++on-prem+++
4. [ ] Enter a project name. For example +++migrate-prj+++
5. [ ] Select a region. For example +++@lab.CloudResourceGroup(on-prem).Location+++


===
### Download the Appliance

Todo: Explain what is the appliance, and what we are doing


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
1. [ ] Take note of the **Project key**. You cannot retrieve it agian.
       You can store it in here: @lab.TextBox(MigrateApplianceKey)

1. [ ] Select **VHD file**    
2. [ ] You need to download the appliance VHD, but **inside your on-prem server**. 

	Copy the Download link by doing right click into the **Download** button and click in Copy Linik. 

===
### Extract the Appliance

1. [ ] Go back to the Hyper-V host VM. This is where you have the Hyper-V Manager with the list of all VMs.

	

3. [ ] Open the browser and paste the link. This will download the VHD . 
	
    ***Make sure you are doing this inside the Hyper-V VM!***. You can also use this link: +++https://go.microsoft.com/fwlink/?linkid=2191848+++

6. [ ] Copy and downloaded file to the F drive, and then extract its content

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

1. [ ] Click **Next** and insert a Name. For example, +++AZMAppliance+++
1. [ ] Click **Store the virtual machine in a different location**, and specify +++F:\Hyper-V\Virtual Machines\appliance+++
1. [ ] Use **Generation 1** and click **Next**
1. [ ] Select +++16384+++ MB of RAM and click Next
1. [ ] In **Connection**, select ++NestedSwitch++ and click Next
1. [ ] Select **Use an existing virtual hard drive** 
1. [ ] click in **Browse** and look for the extracted zip file in the **F:\\** drive.

    > [+Hint] Create virtual machine
    >
	> ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00925.png)

1. [ ] Click Finish, and start the new VM by doing right click **Start** 
1. [ ] Double click in the VM to open a Remote Desktop to it. Initially, it will have a back scree for several minutes until it starts

You have now an appliance up and running in your server. This appliance will scan all the VMs and collect all neded information to be able to plan a migration. Now, we need to configure the appliance in order it is able to run a scan on the environment


===

### Connect to the appliance

We will now configure the appliance.

1. [ ] Start by accepting the License terms
1. [ ] Assign a password for the appliance. Use +++Demo!pass123+++
1. [ ] Send a **Ctrl+Alt+Del** command and log in into the VM

	> [+Hint] Do you know how to send Ctrl+Alt+Del to a VM?
  	>
  	> ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0093.png)

===

### Connect the appliance to Azure Migrate

Once we login, the machine will configure itself. Wait until the browser displays the Azure Migrate Appliance Configuration. This will take about 4 minutes

1. [ ] Agree to the Term of use and wait until it checks the connectivity to Azure
	> [+Hint] Screenshot
  	>
  	> ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00932.png)

1. [ ] Paste the Key we got while creating the Appliance into the Azure Portal, and click **Verify**. 

   During this process, the appliance software is updated. This will take several minutes and will require to **refresh** the page.

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


You have now connected the Appliance to your Azure Migrate project. In the next steps we will provide credentials for the appliance to be able to scan your Hyper-V environment

===

### Configure the appliance

Once the appliance finishes Registering, you will be able to see it in the Azure Portal, but still it cannot scan your servers because it does not have a way to authenticate.
We will now provide Hyper-V host credentials. The appliance will use these credentials to scan Hyper-V and discover all servers

1. [ ] In step 2 **Manage credentials and discovery sources**, click in **Add credentials**

    username: +++adminuser+++
    
    password: +++demo!pass123+++

    ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00946.png)


1. [ ] click in **Add discovery source** and add the IP address of the Hyper-V host: +++172.100.2.1+++

    > [+Hint] Hint
    >
	>![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00947.png)
    >![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00948.png)

1. [ ] We are almost there! Now we need to add credentials to analyze the software inside the VMs, and the databases asociated to the applications. Add credentials for Windows (Non-domain), Linux (Non-domain), SQL Server and PostreSQL Server

	username: +++adminuser+++

    password: +++demo!pass123+++

    > [+Hint] Hint
    >
	>![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00949.png)
    >![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/009491.png)


1. [ ] Click in **Start discovery**
1. [ ] Close the VM, we are going back to the Azure portal

===

### Validate the Appliance is running
The appliance will start collecting data, and sending it to your Azure Migrate project.

1. [ ] Close the virtual machine, and go back to the Azure Portal
2. [ ] Search for **Azure Migrate** -> **All projects** and open your project. If you followed the naming of this guide, it should be called **migrate-prj**
	> [+Hint] Screenshot
    >
	>![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0095.png)

4. [ ] In the left panel, find **Manage** -> **Appliance** and open the appliance you have configured.

	> [+Hint] Screenshot
    >
    >![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00951.png)


4. [ ] Validate that all services are running.
	> [+Hint] Screenshot
    >
    >![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00952.png)

===

Doing an assessment takes time. In order to get data we need to run the appliance for hours.

In real life scenarios, it is better to keep it running for several days. This way Azure Migrate will have a better understanding on the application resources requirements, and will be able to provide better recommendations in term of sizings.

Since we don't have all this time now. We have prepared another Azure Migrate project with data already populated for you.

===

# Excersise 2: Analize the data and prepare a business case

Todo: In this excersise we will review the process of analyzing the collected data and make some conclusions

===

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

# Excercise 3 - .NET App modernization (julia)

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


===

# Modernization part 2: Prepare for cloud

We have upgraded an eight years old application, to the latest version of DorNet.
Lets now find out if we can host it in a modern PaaS service

1. [ ] Right click in the project, and select `Modernize`
2. [ ] This time, we will select Migrate to Azure. Don't forget to send the message!
> !IMAGE[0070.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0070.png)

3. [ ] Copilot made a detailed report for us. Let's take a look at it
       Notice that the report can be exported and shared with other developers in the top right corner
4. Now, let's run the Mandatory Issue: Windows Authenticatio. Click in `Run Task`
> !IMAGE[0080.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0080.png)


===

# Excercise 4 - Java App modernization (julia)



