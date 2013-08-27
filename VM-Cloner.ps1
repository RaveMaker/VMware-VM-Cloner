# PowerShell/PowerCLI - VMware-VM-Cloner/VM-Cloner.ps1
# Clone multiple VMware virtual machines to a different Datastore as a backup.
#
# by RaveMaker - http://ravemaker.net

# use PowerCLI/PowerShell Switches
$CLIMode = "PowerCLI"

# Establish Connection
if ($CLIMode -eq "PowerShell") {
	# Add the VMware snapin for PowerShell - not needed for VMware PowerCLI
	Add-PSSnapin VMware.VimAutomation.Core
}

# Backup = True : Appends date to VM name;
# Backup =  False : Creates a clone with the same VM name.
$Backup = "True"

# DebugMode = True : Will not clone VM
# DebugMode = False : Will clone the VM.
$DebugMode = "True"

# Get current date.
$BackupDate = (get-date -uformat %Y-%m-%d)

# Log File.
$LogFile =  "VM-Cloner-" + $BackupDate + ".txt"
echo  "Backup started at ($BackupDate) - ($LogFile)" >> $LogFile

# vCenter Server and Credentials - leave blank to use without user and password
$vCenter = "vc-hostname.domain"
$UserName = ""
$Password = ""

# Establish Connection
if ($UserName -eq "") {
  Connect-VIServer -server $vCenter
}
else {
  Connect-VIServer -server $vCenter -user $UserName -password $Password
}

# SourceFolder is a folder in your vCenter structure.
$SourceFolder = "Production"

# Target Datastore
$Datastore = "ESX1"

# TargetFolder - existing folder in vCenter structure to store clones
$TargetFolder = "AutoBackup"

# Datacenter name
$Datacenter = "DC1"

# Target Resource Pool
$TargetResourcePool = "AutoBackup"

# Get servers list from the Source Folder
$VMwareServers = Get-VM -Location $SourceFolder

# Loop through servers 
echo  "Begin ($SourceFolder)" >> $LogFile
foreach ($VM in $VMwareServers)
{

# Target Host - Blank TargetHost means use source host.
$TargetHost = ""
if ($TargetHost -eq "") {
  $TargetHost = $VM.vmhost.name
}

# Source VM Name
$VMName = $VM.name 

# Target VM Name - VM name if BACKUP is FALSE
$VMtarget = $VM.name 
$Datastore = Get-Datastore $Datastore -vmhost $TargetHost

if ($Backup -eq "True")  {
  # Clone the VM to vmname-Backup-date
  $VMtarget = $VMtarget + "-" + "Backup-" + $BackupDate
}

# Highlight Clone action
Write-Host -foregroundcolor green "Cloning $VM to $VMtarget"

if ($DebugMode -ne "TRUE") {
   # Clone the VM.
   New-VM -name $VMtarget -vm $VM -vmhost $TargetHost -datastore $Datastore -Location $TargetFolder -ResourcePool ( Get-ResourcePool $TargetResourcePool ) -DiskStorageFormat thin
}

# Check if Clone succeded and log the status.
if (Get-VM $VMtarget) {
  echo  "Cloned $VMName to $VMtarget on $TargetHost disk $Datastore resource pool $TargetResourcePool" >> $LogFile
}
else {
  echo  "Failed Cloning $VMName to $VMtarget on $TargetHost"  >> $LogFile
}
# End foreach loop through servers
}
