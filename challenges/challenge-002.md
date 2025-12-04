# Prepare a Migration Environment

## Goal 

Set up Azure Migrate, including the discovery appliance, so you can inventory on-premises Hyper-V workloads and capture dependency data for later migration.

## Actions

* Review the provided Azure subscription, open the `on-prem` resource group, and connect to the Hyper-V host (`lab@lab.LabInstance.Id-vm`) to understand the nested VM estate and verify sample apps are reachable (for example, `http://172.100.2.110`).
* In Azure Portal, create an Azure Migrate project (for example, `migrate-prj`) in the target region and generate the appliance project key.
* Download the Azure Migrate appliance VHD, extract it on the Hyper-V host (recommended `F:` drive), and build a Generation 1 VM (`AZMAppliance`) with 16 GB RAM attached to `NestedSwitch` using the provided VHD.
* Power on the appliance VM, accept the EULA, set the admin password (`Demo!pass123`), and wait for the Configuration Manager web experience to load.
* Use the appliance UI to paste the project key, sign in to Azure, and register the appliance with your Migrate project.
* Add Hyper-V host access credentials (`adminuser` / `demo!pass123`), register the discovery source (`172.100.2.1`), provide workload credentials for Windows, Linux, SQL Server, and PostgreSQL machines, and start discovery.

## Success criteria

* You can RDP into the Hyper-V host, enumerate nested VMs, and confirm workloads are online.
* An Azure Migrate project exists in the selected region with an active appliance connection.
* The appliance VM is running, registered with Azure, and all health checks show green in the Azure Portal.
* Discovery is in progress and ingesting data from the Hyper-V environment.

## Learning resources
* [Azure Migrate overview](https://learn.microsoft.com/azure/migrate/migrate-services-overview)
* [Azure Migrate appliance architecture](https://learn.microsoft.com/azure/migrate/migrate-appliance-architecture)
* [Discover Hyper-V VMs with Azure Migrate](https://learn.microsoft.com/azure/migrate/tutorial-discover-hyper-v)
* [Discovery best practices](https://learn.microsoft.com/azure/migrate/best-practices-assessment)

