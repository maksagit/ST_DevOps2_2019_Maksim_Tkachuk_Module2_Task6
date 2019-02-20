### 2.4. Выключить виртуальную машину

[CmdletBinding()]
Param 
(
    [parameter(Mandatory = $true, HelpMessage = "Name of virual machine:")]
    [string]$NameOfVirtualMachine
)

Stop-VM -Name $NameOfVirtualMachine