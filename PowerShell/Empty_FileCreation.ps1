$file_name = Read-Host 'File Name'
$start_number = Read-Host 'Start number for file names'
$end_number = Read-Host 'End number for file names'
for($i=[int]$start_number; $i -le [int]$end_number; $i++){
'' | Out-File -FilePath $('C:\Users\jwilli48\Desktop\VIDEO_ID\' + $i + $file_name)
}
