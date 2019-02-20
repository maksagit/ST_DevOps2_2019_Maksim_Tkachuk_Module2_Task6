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

### 1.3. На всех виртуальных компьютерах настроить (удалённо) получение адресов с DHСP.

$hosts = @("VM1-TKACHUK", "VM2-TKACHUK", "VM3-TKACHUK")

Invoke-Command -ComputerName $hosts -Credential "S2012R2\Administrator" -ScriptBlock `
    {Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=true" | `
    ForEach-Object -Process {$_.InvokeMethod("EnableDHCP", $null)}}

# Проверяем включено ли DHCP
#Invoke-Command -ComputerName $hosts -Credential "S2012R2\Administrator" -ScriptBlock `
#    {Get-WmiObject -Class Win32_NetworkAdapterConfiguration | `
#    where {$_.DHCPEnabled -eq "True" -and $_.IPEnabled -eq "True"} }

### 1.4. Расшарить папку на компьютере

net share GitShare=D:\git /users:13 /remark:"Git share!"

### 1.5. Удалить шару из п.1.4

net share GitShare /delete

### 2.1. Получить список коммандлетов работы с Hyper-V (Module Hyper-V)

Get-Command -Module hyper-v

# Get-Command -Module hyper-v | Out-GridView

### 2.2. Получить список виртуальных машин

Get-VM

### 2.3. Получить состояние имеющихся виртуальных машин

Get-VM | Select-Object Name, State, Status

### 2.4. Выключить виртуальную машину

[CmdletBinding()]
Param 
(
    [parameter(Mandatory = $true, HelpMessage = "Name of virual machine:")]
    [string]$NameOfVirtualMachine
)

Stop-VM -Name $NameOfVirtualMachine

### 2.5. Создать новую виртуальную машину

$VMName = "VM-TEST"

$VM = @{
  Name = $VMName 
  MemoryStartupBytes = 512Mb
  Generation = 2
  NewVHDPath = "C:\Hyper-V\$VMName\$VMName.vhdx"
  NewVHDSizeBytes = 1Gb
  BootDevice = "VHD"
  Path = "C:\Hyper-V\$VMName"
  SwitchName = "Internal"
}

New-VM @VM

### 2.6. Создать динамический жесткий диск

New-VHD -Path C:\Hyper-V\DynamicDefault.vhdx -SizeBytes 200Mb

### 2.7. Удалить созданную виртуальную машину

Remove-VM -Name "VM-TEST" -Force