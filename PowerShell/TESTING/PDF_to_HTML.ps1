[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Desktop\itextsharp.5.5.13\lib\itextsharp.dll")
$pdfReader = New-Object iTextSharp.text.pdf.Pdfreader -ArgumentList 'C:\Users\jwilli48\Desktop\ColorWheel.pdf'
$fileDirectory = 'C:\Users\jwilli48\Desktop\testing.html'
$fileStream = [System.IO.FileStream]::new($fileDirectory, [System.IO.FileMode]::Open)
$TaggedPDF_ReaderTool = [iTextSharp.text.pdf.parser.TaggedPdfReaderTool]::new()
$TaggedPDF_ReaderTool.ConvertToXml($pdfReader, $fileStream)

#Use in directory with PDF text files
$files = Get-ChildItem . *.html -rec
foreach ($file in $files)
{
  Write-Host $file -ForegroundColor Cyan

  $File_Content = Get-Content -Encoding UTF8 -Path $file.PSpath -raw

  $File_Content = $File_Content -replace '<Sect>',''
  $File_Content = $File_Content -replace '<H.*?(\d)>(.*?)</H.*?\d>','<h$1>$2</h$1>'
  $File_Content = $File_Content -replace '<Normal>','<p>'
  $File_Content = $File_Content -replace '</Normal','</p>'
  $File_Content = $File_Content -replace '<L>','<ul>'
  $File_Content = $File_Content -replace '<LI><LBody>(.*?)</LBody>','<li>$1</li>'
  $File_Content = $File_Content -replace '</LI>',''
  $File_Content = $File_Content -replace '</L>','</ul>'
  $File_Content = $File_Content -replace '<figure></figure>','<img alt="" src="">'
  $File_Content = $File_Content -replace '<Link>','<a href="" target="_blank">'
  $File_Content = $File_Content -replace '</Link>','</a>'
  $File_Content = $File_Content -replace '</Sect>',''


  $File_Content | Set-Content -Encoding UTF8 -Path $file.PSpath
  Write-Host 'File saved' -ForegroundColor Green
}
