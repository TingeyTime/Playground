#Create a list of links
$Save_File = Split-Path -Path (Get-Location) -parent | Split-Path -leaf
(Get-ChildItem -recurse -exclude .\OLDHTML\) | Select-String -pattern '(<a[^>]*>)(.*?)(<\/a>)' -AllMatches | Format-List -Property Filename, LineNumber | Out-File -FilePath $("C:\Users\jwilli48\Desktop\LinkList\" + $Save_File + "_LinkList.txt")
(Get-Content -Path $("C:\Users\jwilli48\Desktop\LinkList\" + $Save_File + "_LinkList.txt")) -replace ':.*?(<a[^>]*>.*?<\/a>).*', ': $1' | Set-Content -Path $("C:\Users\jwilli48\Desktop\LinkList\" + $Save_File + "_LinkList.txt")
(Get-Content -Path $("C:\Users\jwilli48\Desktop\LinkList\" + $Save_File + "_LinkList.txt")) -replace '', '' | Set-Content -Path $("C:\Users\jwilli48\Desktop\LinkList\" + $Save_File + "_LinkList.txt")


(Get-ChildItem -recurse -exclude .\OLDHTML\) | Select-String -pattern '(<a[^>]*>)(.*?)(<\/a>)' -AllMatches | %{$_.matches} | Format-List -Property *

$Save_File = Split-Path -Path (Get-Location) -parent | Split-Path -leaf
(Get-ChildItem -recurse -exclude .\OLDHTML\) | Select-String -pattern '(<a[^>]*>)(.*?)(<\/a>)' -AllMatches | Foreach{
  Add-Content -Path $("C:\Users\jwilli48\Desktop\LinkList\" + $Save_File + "_LinkList.txt") -Value ("FileName`t: " + $_.FileName)
    Add-Content -Path $("C:\Users\jwilli48\Desktop\LinkList\" + $Save_File + "_LinkList.txt") -Value ("LineNumber`t: " + $_.LineNumber)
  Foreach($i in $_.matches){
    Add-Content -Path $("C:\Users\jwilli48\Desktop\LinkList\" + $Save_File + "_LinkList.txt") -Value ("Link`t`t: " + $i.value + "`r`n")
  }
}
