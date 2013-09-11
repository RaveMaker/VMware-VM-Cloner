VMware-VM-Cloner
================

Clone multiple VMware virtual machines to a different Datastore as a backup

### Installation

1. Clone this script from github or copy the files manually to your prefered directory.

2. Edit the VM-Cloner.ps1 file and replace the following values:

##### Your vCenter server and credentials: 
- $vcenter = "vc.domain"
- $username = "" - leave blank to use current user credentials
- $password = ""

##### sourceLocation is a folder in your vcenter structure.
- $sourceLocation = "Production"

##### Target Datastore
- $datastore = "ESX1"

##### Target location - existing folder in vcenter structure, where the clones will be stored
- $targetlocation = "AutoBackup"

##### Datacenter name
- $datacenter = "DC1"

##### Target Resource Pool
- $targetResourcePool = "AutoBackup"

##### Target Host
- $targethost = "" - hostname.domain or leave blank to use current VM host as target


by [RaveMaker][RaveMaker].
[RaveMaker]: http://ravemaker.net
