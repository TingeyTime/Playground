#If you are worried about ruining everything when making changes, make sure you create a back up folder. This is a command that will copy the entire current directory to the destination given. You will also need to change the destination away from the one I put, which is just an example.
$Save_File = Split-Path -Path (Get-Location) -parent | Split-Path -leaf
Copy-Item . -Recurse $("C:\users\jwilli48\Desktop\COURSE_BACKUP\" + $Save_File + "_BACKUP")

#Will help debug any commands as they are happening, tells you what commands are running at a given time type of thing. -Trace 0 is off, -Trace 1 is commands, -Trace 2 is everything
Set-PSDebug -Trace 1

#This will let you run a script even though our powershell is restricted. Not really sure when to use this as you can't run this as a script either, might as well copy paste the other scripts.
$SCRIPT_NAME = Read-Host 'Script to run'
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Unrestricted -File $("M:\DESIGNER\Content EditorsELTA\Accessibility Assistants\AA team folders\Josh\PowerShell\" + $SCRIPT_NAME + '.ps1')

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Unrestricted -File $("")
#Changes executionPolicy
Set-ExecutionPolicy Bypass -Scope Process

#This is nice as it piping anything to it will display it in a nice grid format that is much more readable then having it all a mess within the PowerShell
Out-GridView
#Example
Get-Process | Where-Object { $_.MainWindowTitle } | Out-GridView
