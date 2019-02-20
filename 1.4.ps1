### 1.4. Расшарить папку на компьютере

(Get-WmiObject -List -ComputerName . | `
    Where-Object -FilterScript {$_.Name –eq "Win32_Share"}).InvokeMethod("Create",("D:\git","GitShare",0,13,"My Git share!"))

# net share GitShare=D:\git /users:13 /remark:"My Git share!"