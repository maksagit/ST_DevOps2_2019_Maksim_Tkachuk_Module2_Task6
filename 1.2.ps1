### 1.2. Получить mac-адреса всех сетевых устройств вашего компьютера и удалённо.

[CmdletBinding()]
Param 
(
    [parameter(Mandatory = $true, HelpMessage = "IP-address of computer?")]
    [string]$IPRemoteComputer
)
function GetMACAdapters ([array]$IPForCheck, [string]$OutText){
    $ArrayMACAdapters = Get-WmiObject -Class "Win32_NetworkAdapterConfiguration" -ComputerName $IPForCheck | `
        # filter - adapters and MAC-Address:
        Select-Object description, macaddress | `
        # remove adapters without MAC-Address
        ?{$_ -like "*:*"}
    Write-Host ($OutText) -ForegroundColor Blue
    Write-Output ($ArrayMACAdapters)
}
GetMACAdapters -IPForCheck localhost -OutText "Localhost: "
GetMACAdapters -IPForCheck $IPRemoteComputer -OutText "Remote Computer: "