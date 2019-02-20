### 1.3. На всех виртуальных компьютерах настроить (удалённо) получение адресов с DHСP.

$hosts = @("VM1-TKACHUK", "VM2-TKACHUK", "VM3-TKACHUK")

Invoke-Command -ComputerName $hosts -Credential "S2012R2\Administrator" -ScriptBlock `
    {Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=true" | `
    ForEach-Object -Process {$_.InvokeMethod("EnableDHCP", $null)}}

# Проверяем включено ли DHCP
#Invoke-Command -ComputerName $hosts -Credential "S2012R2\Administrator" -ScriptBlock `
#    {Get-WmiObject -Class Win32_NetworkAdapterConfiguration | `
#    where {$_.DHCPEnabled -eq "True" -and $_.IPEnabled -eq "True"} }
