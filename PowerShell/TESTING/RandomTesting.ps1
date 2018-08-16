Get-ChildItem -recurse -exclude .\OLDHTML\ | Select-String -pattern '<div id="id(\d*)"' -AllMatches | foreach{
  foreach($i in $_.matches){
  $i
  }
}
(Get-Content -Path C:\Users\jwilli48\Desktop\VIDEO_ID\ENGL-362-M001_VIDEO_IDs.txt) -replace '<div id="(\d*)"', '$1'
  Add-Content -Path C:\Users\jwilli48\Desktop\VIDEO_ID\ENGL-362-M001_VIDEO_IDs.txt -Value $i.value



(Get-ChildItem -recurse -exclude .\OLDHTML\) | Select-String -pattern '<div id="id(\d*)"' | Set-Content -Path C:\Users\jwilli48\Desktop\VIDEO_ID\ENGL-362-M001_VIDEO_IDs.txt
(Get-Content -Path C:\Users\jwilli48\Desktop\VIDEO_ID\ENGL-362-M001_VIDEO_IDs.txt) -replace '<div id="id(\d*)".*', '$1' | Set-Content -Path C:\Users\jwilli48\Desktop\VIDEO_ID\ENGL-362-M001_VIDEO_IDs.txt
(Get-Content -Path C:\Users\jwilli48\Desktop\VIDEO_ID\ENGL-362-M001_VIDEO_IDs.txt) -replace '<div id="id(\d*)".*', '$1' | Set-Content -Path C:\Users\jwilli48\Desktop\VIDEO_ID\ENGL-362-M001_VIDEO_IDs.txt


file.txt

Get-ChildItem . -r  | ? { $_.PsIsContainer -and $_.FullName -notmatch @('~*', '*AA team folders*', '*Alec*', '*Ally*') } | foreach{
  Write-Host $_
}



$files = Get-ChildItem  . -include @('*.xlsx', '*.docx') -rec -Exclude '~*' | Where {$_.FullName -notlike '*AA team folders*'}
foreach($file in $files){
    $File_Name = Split-Path -Path $file.PSpath -Leaf -Resolve
    Copy-Item -Path $file.PSpath -Destination $('C:\Users\jwilli48\Desktop\Buzz_New_File_Names\' + 'a11y_' + $File_Name) -Recurse
}

Copy-Item -Path $_.PSPath -Destination $('C:\Users\jwilli48\Desktop\Buzz_New_File_Names\' + 'a11y_' + $_)
$Save_File = Split-Path -Path (Get-Location) -parent | Split-Path -leaf
Copy-Item . -Recurse $("C:\users\jwilli48\Desktop\COURSE_BACKUP\" + $Save_File + "_BACKUP")

$files = Get-ChildItem @('*.xlsx','*.docx') -r | Where-Object { $_.FullName -notmatch 'AA team folders' -and $_.FullName -notmatch 'a11y'}
$files | Rename-Item -NewName { $_.name -Replace '(.*?\.)','a11y_$1'}
