#This will find every link, show you what it is and give you the option to replace the text with whatever you input. If for some reason there are two links that are exactly the same (as in same URL, same link text, same everything) this will replace all occurances to the same thing as well.
[string[]]$excludes = @('*OLDHTML*', '*OLD.html')
$files = gci . *.html -Recurse -Exclude $excludes
foreach($file in $files)
{
  Write-Host $file -ForegroundColor Green
  $File_Content_Orig = Get-Content -Encoding UTF8 -Path $file.PSpath -raw
  $File_Content = $File_Content_Orig
  $File_Content | Select-String '(<a[^>]*>)(.*?)(<\/a>)' -AllMatches | Foreach{
    foreach($i in $_.matches){
      Write-Host $i.value -ForegroundColor Cyan
      $Yes_No = Read-Host 'Do you want to change this link text? (Y/N)'
      if($Yes_No -eq "Y"){
        $Context = Read-Host 'Would you like to see context for this link? (Y/N)'
        if($Context -eq "Y"){
          $currentColor = $Host.UI.RawUI.ForegroundColor
          $Host.UI.RawUI.ForegroundColor = 'Green'
          Select-String -Path $file.PSpath -SimpleMatch $i.value -Context 2
          $Host.UI.RawUI.ForegroundColor = $currentColor
        }
        $ReplaceText = Read-Host 'Replacement Text'
        #The ### are temporary to make sure capture group 1 and 3 ($1 and $3) are never lost.
        $ReplaceText = $i.value -replace '(<a[^>]*>)(.*?)(<\/a>)', ('$1###' + $ReplaceText + '###$3')
        Write-Host "New link (The ### are temporary): " -ForegroundColor Red -NoNewLine
        Write-Host $ReplaceText -ForegroundColor Red
        $File_Content_Orig = $File_Content_Orig -replace [regex]::Escape($i.value) , $ReplaceText
        $File_Content_Orig = $File_Content_Orig -replace '###', ''
        $File_Content_Orig | Set-Content -Encoding UTF8 -Path $file.PSpath
        Write-Host 'Link text changed' -ForegroundColor Magenta
      }
    }
  }
  Write-Host "Going to next file..." -ForegroundColor Gray
}
