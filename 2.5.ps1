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