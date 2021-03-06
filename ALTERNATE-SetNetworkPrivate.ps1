## The Network Location feature was introduced in Windows Vista. 
## It provides an easy way to customize your firewall settings based on whether you trust or don’t trust the computers around you. 
## There are three Network Location types - Private, Public and Domain. If your computer is a member of the domain then you won’t be able to change the Network Location type. If your computer is standalone or part of the workgroup, then you can choose what type of network location do you want - Public or Private. Private means that you are a member of the trusted network and you can lower your network security a little bit. Public means that you have no trust for the network outside, and you should not let your guard down.
##
## The network location is per connection/network card. Every time a new connection is added - the dialog will appear, 
## asking you to choose the network location type.
##
## Setting the correct network location type is very important for Windows PowerShell Remoting. 
## You cannot enable Windows PowerShell Remoting on your machine if your connections are set to Public. 
## It means you won’t be able to connect to this machine using Windows PowerShell Remoting. 
## Vista provides a UI dialog for setting network location, but, unfortunately, there is no command-line utility for that. 
## You can however do it with Windows PowerShell.
##
## Vladimir Averkin 
#############################################################

# Skip network location setting for pre-Vista operating systems 
if([environment]::OSVersion.version.Major -lt 6) { return } 

# Skip network location setting if local machine is joined to a domain. 
if(1,3,4,5 -contains (Get-WmiObject win32_computersystem).DomainRole) { return } 

# Get network connections 
$networkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}")) 
$connections = $networkListManager.GetNetworkConnections() 

# Set network location to Private for all networks 
$connections | % {$_.GetNetwork().SetCategory(1)}