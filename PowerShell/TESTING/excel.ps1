$excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.Open('C:\Users\jwilli48\Desktop\RELC 200 Course Progress.xlsx')
$workSheet = $Workbook.Sheets.Item(1)

$i = 3
$videoNames = @()
While($workSheet.Cells.item($i,1).value() -ne $NULL){
  $videoNames += $workSheet.Cells.item($i,1).Value()
  $i++
}
$i = 3
$videoIDs = @()
While($workSheet.Cells.Item($i,2).value() -ne $NULL){
  $videoIDs += $workSheet.Cells.item($i,2).Value()
  $i++
}

$fileName = (Get-ChildItem 'N:\IS\Production\Courses\RELC-200\BYUOnline-RELC-200-M001\Development\Video\Transcriptions\Closed Captions\VTT or SRT files' | Where-Object {$_.name -match $videoNames[$j]} | % {$_.name})
