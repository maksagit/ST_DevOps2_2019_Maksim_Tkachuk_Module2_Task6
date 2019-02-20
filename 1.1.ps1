### 1.1. Вывести все IP адреса вашего компьютера (всех сетевых интерфейсов)

[CmdletBinding()]
Param 
(
    [parameter(Mandatory = $true, HelpMessage = "IP-address of computer?")]
    [string]$IPComputer
)

$ArrayIP4 = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $IPComputer | `
    # filter the objects where an address actually exists:
    Where { $_.IPAddress } | `
    # retrieve only the property *value*:    
    Select -Expand IPAddress | `
    # filter IP4 Address:
    ?{$_ -notlike "*:*"}

foreach ($ip in $ArrayIP4)
{
    Write-Output("IP-address: " + $ip)
}