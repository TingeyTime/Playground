#May need to change the Select-String pattern as well as the bottom -replace pattern
#Normal form: '<div id="[^\d]*(\d{13})"', sometimes 'id="myExperience\d*'
#If this fails to run / has an error of path not found for the bottom Get-Content then it failed to find any videos that fit the criteria given.
[string[]]$excludes = @('*OLDHTML*', '*OLD.html')
$Save_File = Split-Path -Path (Get-Location) -parent | Split-Path -leaf
(Get-ChildItem -recurse -exclude $excludes ) | Select-String -pattern '<div id="[^\d]*(\d{13})"' -AllMatches | Sort-Object -Property FileName | Foreach{
  Add-Content -Encoding UTF8 -Path $("C:\Users\jwilli48\Desktop\VIDEO_ID\" + $Save_File + "_VideoID.txt") -Value ("FileName`t: " + $_.FileName)
  Add-Content -Encoding UTF8 -Path $("C:\Users\jwilli48\Desktop\VIDEO_ID\" + $Save_File + "_VideoID.txt") -Value ("LineNumber`t: " + $_.LineNumber)
  Foreach($i in $_.matches){
    Add-Content -Encoding UTF8 -Path $("C:\Users\jwilli48\Desktop\VIDEO_ID\" + $Save_File + "_VideoID.txt") -Value ("VideoID`t`t: " + $i.value)
  }
  Add-Content -Encoding UTF8 -Path $("C:\Users\jwilli48\Desktop\VIDEO_ID\" + $Save_File + "_VideoID.txt") -Value "`r`n"
}
(Get-Content -Encoding UTF8 -Path $("C:\Users\jwilli48\Desktop\VIDEO_ID\" + $Save_File + "_VideoID.txt")) -replace '<div id="[^\d]*(\d{13})"' , '$1' | Set-Content -Encoding UTF8 -Path $("C:\Users\jwilli48\Desktop\VIDEO_ID\" + $Save_File + "_VideoID.txt")
#This will open the newly created file
Invoke-Item -Path $("C:\Users\jwilli48\Desktop\VIDEO_ID\" + $Save_File + "_VideoID.txt")
