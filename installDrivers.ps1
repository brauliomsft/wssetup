Get-ChildItem "C:\Users\Administrator\Downloads\drivers" -Recurse -Filter "*.inf" | 
ForEach-Object { PNPUtil.exe /add-driver $_.FullName /install }