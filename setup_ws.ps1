#Requirements
# Windows Server Installed
# Enable HyperV Role using Install-WindowsFeature -Name Hyper-V -IncludeManagementTools
# Reboot
# Nvidia Drivers Installed
# Download VHD from: https://aniccaautomation.blob.core.windows.net/vhd/UbuntuTemplate.vhdx

#Import Modules
Import-Module Hyper-V

#Set Environment Variables
$VMName = "Ubuntu"
$vhdpath = "C:\VMs\Ubuntu.vhdx"
$NATSwitchName = "NATSwitch"

#Check vSwitch with External vSwitch
#$netadapter = Get-NetAdapter -physical | where status -eq "up"
#Write-Host "Creating Virtual Switch using" $netadapter.Name "Adapter"
#New-VMSwitch -Name "External Network" -NetAdapterName $netadapter.Name -AllowManagementOS:$true

#Creating a Internal vSwitch with NAT
New-VMSwitch -Name $NATSwitchName -SwitchType Internal
New-NetIPAddress -IPAddress 192.168.50.1 -PrefixLength 24 -InterfaceAlias "vEthernet (NATSwitch)"
New-NetNat -Name NAT -InternalIPInterfaceAddressPrefix 192.168.50.0/24

#Create VM
New-VM -Name $vmname -MemoryStartupBytes 16GB -Generation 2 -VHDPath $vhdpath
Set-VMFirmware -VMName $VMName -EnableSecureBoot Off


#Query Device Location
$pnpdevs = Get-PnpDevice -PresentOnly
$pcidevs = $pnpdevs | Where-Object {$_.InstanceId -like "PCI*"}

foreach ($pcidev in $pcidevs) {
    if($pcidev.FriendlyName.equals("NVIDIA Tesla T4")) {
        Write-Host -ForegroundColor White -BackgroundColor Black $pcidev.FriendlyName
        $locationpath = ($pcidev | get-pnpdeviceproperty DEVPKEY_Device_LocationPaths).data[0]
        Write-Host "Disabling GPU from Host..."
        Get-PnpDevice -FriendlyName $pcidev.FriendlyName | Disable-PnpDevice
    }
    else
    {
        continue
    }
}


#Plan for DDA Attachment Disable GPU
Set-VM -Name $VMName -AutomaticStopAction TurnOff
Set-VM -GuestControlledCacheTypes $true -VMName $VMName
Set-VM -LowMemoryMappedIoSpace 3Gb -VMName $VMName
Set-VM -HighMemoryMappedIoSpace 16280Mb -VMName $VMName
Write-Host "Dismounting GPU from Host..."
Dismount-VMHostAssignableDevice -force -LocationPath $locationpath

#Mount GPU to VM
Write-Host "Mountin GPU to VM"
Add-VMAssignableDevice -LocationPath $locationPath -VMName $VMName
Get-VMNetworkAdapter -VMName $VMName | Connect-VMNetworkAdapter -SwitchName $NATSwitchName


#Start VM
Start-VM -Name $VMName
