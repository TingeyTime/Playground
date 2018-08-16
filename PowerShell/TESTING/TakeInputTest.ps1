$files = gci . *.html -Recurse
foreach($file in $files)
{
    $File_Content_First = Get-Content -Encoding UTF8 -Path $file.PSpath -raw
    $File_Content = $File_Content_First
    $File_Content | Select-String '(<a[^>]*>)(.*?)(<\/a>)' -AllMatches | Foreach{
      foreach($i in $_.matches){
        Write-Host $i.value -ForegroundColor Cyan
        $Yes_No = Read-Host 'Do you want to change this link text? (Y/N)'
        if($Yes_No -eq "Y"){
          $ReplaceText = Read-Host 'Replacement Text (Do not put the number 1 as the first character)'
          $ReplaceText = $i.value -replace '(<a[^>]*>)(.*?)(<\/a>)', ('$1' + $ReplaceText + '$3')
          $File_Content_First = $File_Content_First -replace [regex]::Escape($i.value) , $ReplaceText
          $File_Content_First | Set-Content -Encoding UTF8 -Path $file.PSpath
          Write-Host 'Link text changed' -ForegroundColor Blue
        }
      }
      }
}

$Yes_No = Read-Host 'Do you want to change this link? ' + $LinkText

$files = gci . *.html -Recurse
foreach($file in $files)
{
    $File_Content = Get-Content -Encoding UTF8 -Path $file.PSpath
    Foreach($line in $File_Content)
    {
      $line | Select-String '(<a[^>]*>)(.*?)(<\/a>)' -AllMatches | Foreach{$_.matches.value}
    }
}

$files = gci . *.html -Recurse
foreach($file in $files)
{
  $file | select-string '(<a[^>]*>)(.*?)(<\/a>)' -AllMatches | foreach{
    foreach($i in $_.matches){
      Write-Host 'Line' -ForegroundColor Cyan
      $i
      Write-Host 'End Line' -ForegroundColor Cyan
    }
  }
}
