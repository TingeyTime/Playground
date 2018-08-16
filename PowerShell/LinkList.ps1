#Generate a list of every link in the course and save it to a .txt file
[string[]]$excludes = @('*OLDHTML*', '*OLD.html')
$Save_File = Split-Path -Path (Get-Location) -parent | Split-Path -leaf
(Get-ChildItem -recurse -exclude $excludes ) | Select-String -pattern '(<a href="http:[^>]*>)(.*?)(<\/a>)' -AllMatches | Sort-Object -Property FileName | Foreach{
  Add-Content -Encoding UTF8 -Path $("C:\Users\jwilli48\Desktop\LinkList\" + $Save_File + "_LinkList.txt") -Value ("FileName`t: " + $_.FileName)
  Add-Content -Encoding UTF8 -Path $("C:\Users\jwilli48\Desktop\LinkList\" + $Save_File + "_LinkList.txt") -Value ("LineNumber`t: " + $_.LineNumber)
  Foreach($i in $_.matches){
    Add-Content -Encoding UTF8 -Path $("C:\Users\jwilli48\Desktop\LinkList\" + $Save_File + "_LinkList.txt") -Value ("Link`t`t: " + $i.value)
  }
  Add-Content -Encoding UTF8 -Path $("C:\Users\jwilli48\Desktop\LinkList\" + $Save_File + "_LinkList.txt") -Value "`r`n"
}
#This will open the file
Invoke-Item -Path $("C:\Users\jwilli48\Desktop\LinkList\" + $Save_File + "_LinkList.txt")


#This will open every link contained in that file in chrome
$openLinks = Read-Host "Do you want to open every link found (Y/N)"
if($openLinks -match 'Y'){
  Get-Content -Path $("C:\Users\jwilli48\Desktop\LinkList\" + $Save_File + "_LinkList.txt") | Select-String -Pattern 'href="(.*?)"' -Allmatches | foreach {
    $link = $($_.matches.Value -replace 'href="(.*?)"', '$1')
    Start-Process 'Chrome.exe' $link
  }
}
