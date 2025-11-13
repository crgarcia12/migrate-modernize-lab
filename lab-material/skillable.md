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

The objective of the lab is to TODO

#### Part 1: Prepare a migration:
1. An assessment of an on-premises datacenter hyper-v environment using Azure Migrate
2. Building a Business Case and decide on the next step for one application
3. Discover what are the benefits of migrating to the cloud, and how to do it

#### Part 2: Migrate an application:
1. Modernize .NET application |using GitHub Copilot app modernization for .NET.


Each part is independent.

===
# Excersie 1: Prepare a migration

Click Next to start the excersise

===
### Understand our lab environment

The lab simulates a datacenter, by having a VM hosting server, and several VMs inside simulating different applications

1. [ ] Open Edge, and head to the Azure Portal using the following link. This link enables some of the preview features we will need later on: ++https://aka.ms/migrate/disconnectedAppliance++
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

1. [ ] Go back to the Hyper-V host VM, open the browser and paste the link. This will download the VHD . 
	
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

   During this process, the appliance software is updated. This will take several minutes and will require to refresh the page.

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

    ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00947.png)
    ![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/00948.png)


===

Doing an assessment can take time. That is why we have run an assessment in other servers for you.
1. [ ] Go to the Azure Portal, and open the already prepared project: ++lab@lab.LabInstance.Id-azm++

![Screenshot](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0095.png)

===


Doing an assessment can take time. That is why we have run an assessment in other servers for you.
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

# Excersise 2: Analysis


Press Next to continue.
===
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
TODO
Quiz

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

TODO: It would be better to fork the repo, and be able to commit

1. [] Since we are going to modernize it first, lets get in the shoes of the developers that will execute the migration

  1. [ ] Open Visual Studio
  2. [ ] Select Clone a repository
  3. [ ] In the `Repository Location`, paste this repo ++https://github.com/crgarcia12/migrate-modernize-lab.git++
  4. [ ] Click Clone

1.[] Let's open the solution now. In Visual Studio
  1. [ ] File -> Open
  2. [ ] Navigate to `migrate-modernize-lab`, `src`, `Contoso University`
  3. [ ] Find the file `ContosoUniversity.sln`
  4. [ ] In the `View` menu, click `Solution Explorer`
  5. [ ] Rebuild the solution

      > [!Hint] TODO: Troubles building? Make sure you have Nuget.org package sources


It is not required for the lab, but if you want, you can run the solution in IIS Express (Microsoft Edge)
 
!IMAGE[0030.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0030.png)

Edge will open, and you will see the application running in `https://localhost:44300`


===

# Running a code assessment

We will modernize this application.
The first step is to do a code assessment. For that we will use GitHub Copilot for App Modernization

1. [ ] Right click in the project, and select `Modernize`

!IMAGE[0040.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0040.png)
===


# Upgrade to a newer version

We will do the migration in two steps. First we will upgrade the application to the latest DotNet, since many packages are outdated with known security vulnerabilities,

1. [ ] Right click in the project, and select `Modernize`
2. [ ] Click in `Accept upgrade settings and continue`. Make sure you send the message

!IMAGE[0050.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0050.png)

Let s review copilot proposal

TODO: Point to some details

3. [ ] Review the proposed plan.
4. [ ] Ask what is the most risky part of the upgrade
5. [ ] Ask if there are security vulnerabilities in the current solution
6. [ ] Ask copilot to perform the upgrade
7. [ ] Try to clean and build the solution
8. [ ] If there are erros, tell copilot to fix the errors using the chat
9. [ ] Run the application again, this time as a standalone DotNet application

!IMAGE[0060.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0060.png)

> [!Hint] If you see an error at runtime. Try asking copilot to fix it for you.
>
> For example, you can paste the error message and let Copilot fix it. For example: `SystemInvalidOperation The ConnectionString has not been initialized.` 

TODO: See the lists of commit, if we managed to fork the repo

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