#If you are worried about ruining everything when making changes, make sure you create a back up folder. This is a command that will copy the entire current directory to the destination given. You will also need to change the destination away from the one I put, which is just an example.
$Save_File = Split-Path -Path (Get-Location) -parent | Split-Path -leaf
Copy-Item . -Recurse $("C:\users\jwilli48\Desktop\COURSE_BACKUP\" + $Save_File + "_BACKUP")
