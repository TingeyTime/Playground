#If this is false then there is no profile
Test-Path $profile

New-Item -path $profile -type file –force
