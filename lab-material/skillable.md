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

**Goals:**
- Understand how Azure Migrate works in a simulated datacenter environment
- Learn to create and configure an Azure Migrate project
- Install and configure an Azure Migrate appliance for data collection
- Connect the appliance to your on-premises environment for discovery
- Validate that the appliance is successfully collecting data from your infrastructure

## Overview
Migration preparation is the foundation of any successful cloud migration. This exercise teaches you how to set up Azure Migrate to discover and assess your on-premises environment. You'll work with a simulated datacenter containing multiple VMs running different applications.

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

**Goals:**
- Understand how to review and clean migration data for accuracy
- Learn to group VMs into applications for better migration planning
- Create and analyze a business case to justify migration investments
- Evaluate technical readiness and migration strategies using assessments

## Overview
After the Azure Migrate appliance has been running and collecting data from your on-premises environment, you need to analyze this data to make informed migration decisions. This exercise teaches you how to prepare clean data, build business cases, and perform technical assessments.

1. [ ] Go to the Azure Portal and open the already prepared project: ++lab@lab.LabInstance.Id-azm++

![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0095.png)

===
# Prepare your data

To make informed decisions, you need good quality data. The appliance collects data continuously, but issues can occur that require your attention.

Let's check if there are any issues with the collected data:

1. [ ] Open the Azure Migrate project overview
2. [ ] Open the **Action center** blade from the panel on the left

You will find several issues, such as:
- VMs that are powered off
- VMs that the appliance could not connect to due to incorrect credentials
- Missing performance data

In a real-world scenario, you should resolve all issues to improve data quality. For this exercise, we will proceed with the available data.

> [+Hint] Screenshot
>
>![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/01005.png)

===
# Create Applications

Once your workload data is clean, group VMs into applications to identify what should be migrated together. This helps ensure application dependencies are maintained during migration.

Let's create an application definition for Contoso University:

1. [ ] Expand the **Explore applications** group in the left panel
2. [ ] Open the **Applications** page
3. [ ] Click **Define application** → **New application**
4. [ ] In **Name**, enter +++ContosoUniversity+++
5. [ ] In **Type**, select **Custom** (meaning we have access to the source code)
6. [ ] In **Workloads**, find all the +++ContosoUniversity+++ workloads using the filter and select them all
    
    > [+Hint] Screenshot
    >
	>![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/01002.png)
7. [ ] In **Properties**, select any criticality and complexity, then create the application


===
# Build a Business Case

A business case helps you understand where Azure brings the most value by estimating Total Cost of Ownership (TCO), potential savings, and sustainability impact for your applications and workloads. 

1. [ ] In the **Decide and plan** tab, open **Business cases**
   You will notice there are business cases already created - we'll ignore those for now
2. [ ] Click **Build business case**

You can create business cases for all workloads or scope them to specific applications. For this example, we'll create a scoped business case for the Contoso University application.

3. [ ] Type a name for the business case: +++contosouniversity+++
4. [ ] Select **Selected Scope**
5. [ ] Click **Add applications**
6. [ ] Select the **ContosoUniversity** application, then click **Next**
7. [ ] Select **West US 2** as the target region
8. [ ] Add a 15% Azure discount (simulate enterprise agreements)
9. [ ] Click **Build business case**

Building the business case takes several minutes. While we wait, let's examine a pre-built business case.

===

# Analyze an Existing Business Case

You can create several business cases for different scenarios, like rehosting vs refactoring, or considering different applications.

Building the business case takes several minutes. While we wait, let's examine a pre-built business case focused on modernization for the entire datacenter to understand how to interpret business case results and identify savings opportunities

1. [ ] Expand **Decide and Plan** and open **Business cases** in the left panel
2. [ ] Open the **businesscase-for-paas** business case

===

## Key Metrics Analysis

The overview shows several important metrics:

**Cost Comparison:**
- The first tile displays estimated on-premises vs Azure costs and potential savings
- Hover over the information icon to learn how on-premises costs are calculated

**Infrastructure Summary:**
- This business case analyzes 40 VMs (13 Linux, 27 Windows)
- Identifies 22 unique web applications and 6 databases
- Shows potential savings of $212.3K USD annually

**Understanding the Savings:**
Let's explore where these savings come from:

1. [ ] Expand **Business Case Reports** and open **Current on-premises vs future**
2. [ ] Scroll to the table below and review the different lines, like **Compute and licensing** cost savings
3. [ ] Continue scrolling to see the estimated Carbon Dioxide emissions reduction

===

## Migration Strategies

1. [ ] Navigate to the **Migration Strategies** page

This report maps your workloads to Gartner's 6R migration strategies:
- **Rehost:** Lift and shift to Azure VMs
- **Replatform:** Move to managed services (e.g., Azure SQL Managed Instance)
- **Refactor:** Modernize to PaaS services (e.g., Azure App Service)

In this case, the report propose to us that after the migration some workloads will be rehosted and some will be replatformed.

Can you find
1. [ ] total cost of running all applications on Azure?
2. [ ] Total cost of applications that will be hosted on VMs?
3. [ ] Total cost of SQL databases running on VMs?

===

## Azure Cost Assumptions

1. [ ] Expand **Settings** and navigate to the **Azure cost** page

Here you can adjust parameters to get more accurate estimates:
- Target regions
- Discount percentages  
- Migration timeline
- Performance comfort factors

Feel free to explore the business case further.

You can find more information [in the official documentation](https://learn.microsoft.com/en-us/azure/migrate/concepts-business-case-calculation?view=migrate)

===
# Technical Assessment
**Goals:** Evaluate technical readiness and migration complexity for your workloads

While business cases focus on financial aspects, **Assessments** help you choose the right migration approach and Azure services. <br>
They evaluate technical readiness for migration. <br>
Assessment focus on analyze workloads for migration strategy, Azure readiness and right-sized targets.

When you create a business plan, an Assessment is created automatically for you.

1. [ ] Expand **Decide and plan** and Open **Assessments** page


> [+Hint] Screenshot
>
> ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/01007.png)

===

## Assessment Components

Azure Migrate assessments evaluate your workloads for:

- **Migration strategy:** The best approach to migrate application components (rehost, replatform, refactor)
- **Readiness:** Suitability of source workloads for specific Azure services
- **Right-sized targets:** Optimal Azure services based on performance requirements and cost
- **Azure resource cost:** Total cost for hosting workloads on Azure
- **Migration tools:** Recommended tools for each migration type

===

## Review an Existing Assessment

1. [ ] Expand **Decide and plan** and open the **Assessments** page
2. [ ] Open the assessment called **businesscase-businesscase-for-paas**
   (This assessment is automatically created when you build a business case)
3. [ ] Review the **Recommended path**: Notice it shows "PaaS preferred"
4. [ ] Explore the different tabs to see:
5. [ ] Check the monthly cost for this path
6. [ ] Check how many workloads (VMs) are going to be Replatformed and how many Rehosted
7. [ ] Chek the split cost on Storage, Security and Copute

===

## Review an Existing Assessment

Now we understand what we should do. Let's dig into individual applications to understand what is the reommended actions

1. [] Click in **View Details** or select the **PaaS preferred** tab
	
    > [+Hint] Screenshot
	>
	> ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/01008.png)

There are three targets. 
1. Web apps to App Service
1. SQL Instances to Azure VMs
1. Serviers to azure VM

Open the first one, **Web apps to App service code**

===

## WebApps to App Service

There are 22 applications, of which 12 are ready to be migrated. Ten Appliations require some work.
Let's dig into these tasks

Can you spot
1. [] Total Number of applications?
2. [ ] Applications that are Ready with conditions?
3. [ ] Recommended App Service Plan?
4. [ ] Top migration issues we will face?

> **Note:** You can create specific assessments for individual applications or server groups to get focus detailed technical recommendations. 

===

## Contoso University

From the list of applications, select now ContosoUniversity

If the appliance run long enough. You will find in here information regarding the application

Can you spot
1. [] Appliation URL
1. [] Migration warnings (Readiness tab)

This application, even when it seems that it require some work. Its a nice candidate to start our migration
Let's look for some more details before we start the migration

===

## Contoso University

1. [ ] Expand the **Explore applications** tab
2. [ ] Open Contoso University application we created some minutes ago

Can you spot:
1. [ ] How many servers and databases copose the application?
2. [ ] The operative systems state?

Click in the Workloads to take a look at the involved servers

Can you spot:
1. [ ] What servers are out of support?
2. [ ] What are in extended support?

Open the database that is out of support

Can you spot:
1. [] What is the current running version?

===

## Contoso University

The last thing we should do before migrating, is verify what other sofware is running on the VM

Go back to the application, and open the win-ContosoUniversity-backedn

![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/01010.png)

Can you spot:
1. [] Sofware count on the VM?
1. [] Number of Web Hosting software

===

# Exercise 2 Summary

**What you accomplished:**

1. ✅ **Data Quality:** Learned to identify and address data collection issues that could impact migration planning
2. ✅ **Application Grouping:** Created logical application definitions to ensure coordinated migration of related components  
3. ✅ **Business Case:** Built financial justification showing potential cost savings, TCO, and ROI for migration
4. ✅ **Technical Assessment:** Evaluated workload readiness and identified optimal Azure services and migration strategies

**Key Takeaways:**
- Clean, accurate data is essential for reliable migration planning
- Business cases provide the financial justification needed to secure migration funding
- Technical assessments ensure your applications are ready for Azure and help choose the right services
- Combining financial and technical analysis gives you a complete migration strategy

**Next Steps:**
You now have the foundation for informed migration decisions. In the following exercises, you'll put this knowledge into practice by modernizing Contoso University using GitHub Copilot.

===

===

TODO questions
How many Linux VMs are power off? Answer 3 + 01001.png
How many Windows 2016 servers have we discovered? Answer 5 + 01004.png
-
How much are we going to expend in Azure VMs for hosting applications? 57.2K
How much are we going to expend in PaaS services to host applications? 41.7K
What will be the total cost for the applications that have been rehosted? 70.9K
-


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
