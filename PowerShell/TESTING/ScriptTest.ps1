
$files = Get-ChildItem . *.html -rec
$sw1.start()
foreach ($file in $files)
{
  Write-Host $file -ForegroundColor Cyan;
  $sw2.start();
  $File_Content = Get-Content -Encoding UTF8 -Path $file.PSpath -raw;
  $sw2.stop();
  $sw3.start();
  $File_Content = $File_Content -replace '<i>' , '<em>';
  Write-Host "Finished replacing <i> with <em>";
  $sw3.stop();
  $sw4.start();
  $File_Content = $File_Content -replace '</i>' , '</em>';
  Write-Host "Finished replacing </i> with </em>";
  $sw4.stop();
  $sw5.start();
  $File_Content = $File_Content -replace '<b>' , '<strong>';
  Write-Host "Finished replacing <b> with <strong>";
  $sw5.stop();
  $sw6.start();
  $File_Content = $File_Content -replace '</b>' , '</strong>';
  Write-Host "Finished replacing </b> with </strong>";
  $sw6.stop();
  $sw7.start();
  $File_Content = $File_Content -replace '(?!.*alt=".*")(.*)(<img)(.*)' , '$1$2 alt=""$3';
  Write-Host 'Finished replacing missing alt=""';
  $sw7.stop();
  $sw8.start();
  $File_Content = $File_Content -replace 'alt="banner"' , 'alt=""';
  Write-Host 'Finished replacing alt="banner" with alt=""';
  $sw8.stop();
  $sw9.start();
  $File_Content = $File_Content -replace 'alt="\[~\][/%\.\w\d]*"' , 'alt=""';
  Write-Host 'Finished replacing alt text with image link with alt=""';
  $sw9.stop();
  $sw10.start();
  $File_Content = $File_Content -replace 'alt="Placeholder for LessonBanner"' , 'alt=""';
  Write-Host 'Finished replacing alt="Placeholder for LessonBanner" with alt=""';
  $sw10.stop();
  $sw11.start();
  $File_Content = $File_Content -replace 'alt="Placeholder Text"' , 'alt=""';
  Write-Host 'Finished replacing alt="Placeholder Text" with alt=""';
  $sw11.stop();
  $sw12.start();
  $File_Content | Set-Content -Encoding UTF8 -Path $file.PSpath
  $sw12.stop();
}
$sw1.stop();

#Stopwatches
$sw1 = [Diagnostics.Stopwatch]::new()
$sw2 = [Diagnostics.Stopwatch]::new()
$sw3 = [Diagnostics.Stopwatch]::new()
$sw4 = [Diagnostics.Stopwatch]::new()
$sw5 = [Diagnostics.Stopwatch]::new()
$sw6 = [Diagnostics.Stopwatch]::new()
$sw7 = [Diagnostics.Stopwatch]::new()
$sw8 = [Diagnostics.Stopwatch]::new()
$sw9 = [Diagnostics.Stopwatch]::new()
$sw10 = [Diagnostics.Stopwatch]::new()
$sw11 = [Diagnostics.Stopwatch]::new()
$sw12 = [Diagnostics.Stopwatch]::new()
$sw13 = [Diagnostics.Stopwatch]::new()
$sw14 = [Diagnostics.Stopwatch]::new()
$sw15 = [Diagnostics.Stopwatch]::new()

echo $sw1.ElapsedMilliseconds, $sw2.ElapsedMilliseconds, $sw3.ElapsedMilliseconds, $sw4.ElapsedMilliseconds, $sw5.ElapsedMilliseconds, $sw6.ElapsedMilliseconds, $sw7.ElapsedMilliseconds, $sw8.ElapsedMilliseconds, $sw9.ElapsedMilliseconds, $sw10.ElapsedMilliseconds, $sw11.ElapsedMilliseconds, $sw12.ElapsedMilliseconds
