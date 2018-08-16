[iTextSharp.text.pdf.parser.TaggedPdfReaderTool].DeclaredMembers

$help = ([appdomain]::CurrentDomain.GetAssemblies())|?{$_.Modules.name.contains('itext')}
$help.GetModules().getTypes() | ? {$_.isPublic -AND $_.isClass} | Select-String 'PDF' | Out-GridView

$help = ([appdomain]::CurrentDomain.GetAssemblies())|?{$_.Modules.name.contains('Selenium') -or $_.Modules.name.conta
ins('WebDriver')}

Get-History
