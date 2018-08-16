#Find and replace in current directory based on input given. Additional replace commands can be added anywhere within the brackets after the Get-Content command and before the Set-Content command.
$Save_File = Split-Path -Path (Get-Location) -parent | Split-Path -leaf
Copy-Item . -Recurse $("C:\users\jwilli48\Desktop\COURSE_BACKUP\" + $Save_File + "_BACKUP")

[string[]]$excludes = @('*OLDHTML*', '*OLD.html')
$sw = [Diagnostics.Stopwatch]::new()
$sw.start()
$files = Get-ChildItem . *.html -rec -Exclude $excludes
foreach ($file in $files)
{
  Write-Host $file -ForegroundColor Cyan

  $File_Content = Get-Content -Encoding UTF8 -Path $file.PSpath -raw

  $File_Content = $File_Content -replace '<i>' , '<em>'
  Write-Host "Finished replacing <i> with <em>"

  $File_Content = $File_Content -replace '</i>' , '</em>'
  Write-Host "Finished replacing </i> with </em>"

  $File_Content = $File_Content -replace '<b>' , '<strong>'
  Write-Host "Finished replacing <b> with <strong>"

  $File_Content = $File_Content -replace '</b>' , '</strong>'
  Write-Host "Finished replacing </b> with </strong>"

  $File_Content = $File_Content -replace '(<img )(?!.*alt=".*")' , '$1alt="" '
  Write-Host 'Finished replacing missing alt=""'

  $File_Content = $File_Content -replace 'alt=".*?banner.*?"' , 'alt=""'
  Write-Host 'Finished replacing alt=".*?banner.*?" with alt=""'

  $File_Content = $File_Content -replace 'alt="\[~\][/%\.\w\d]*"' , 'alt=""'
  Write-Host 'Finished replacing alt text that is just an image link with alt=""'

  $File_Content = $File_Content -replace 'alt=".*?Placeholder.*?"' , 'alt=""'
  Write-Host 'Finished replacing alt=".*?Placeholder.*?" with alt=""'

  $File_Content = $File_Content -replace 'alt=".*?Lesson Banner.*?"' , 'alt=""'
  Write-host 'Finished replacing alt=".*?Lesson banner.*?" with alt=""'

  $File_Content = $File_Content -replace '<a[^>]*><span[^>]*>Click Here To Watch Video\.</span></a>', ''
  Write-Host 'Finished replacing "Click Here to Watch Video" links'

  $File_Content = $File_Content -replace '(<a )(name)(="top"></a>)', '$1id$3'
  Write-Host 'Finished replacing name="top" tag with id="top"'

  $File_Content = $File_Content -replace "(<a )(onclick=`"OpenExternalLink\(')([^']*)('\); return false;`")", '$1href="$3"'
  Write-Host 'Finished replacing Onclick links with href="" links'

  $File_Content = $File_Content -replace '<td scope="row">', '<td>'
  Write-Host 'Finished replacing misused table scope tags'

  $File_Content | Set-Content -Encoding UTF8 -Path $file.PSpath
  Write-Host 'File saved' -ForegroundColor Green
}
$sw.stop()
echo $sw.ElapsedMilliseconds
