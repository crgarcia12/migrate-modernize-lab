# VM Creation Infrastructure
This folder contains the information to create the base VM with nested virtualization that simulates an on-prem Server.

# Pre requisites
This lab requires sandard security type in VMs (not trusted launch):
```
az feature register --name UseStandardSecurityType --namespace Microsoft.Compute
az feature show --name UseStandardSecurityType --namespace Microsoft.Compute
```
