#Testing new regex to see if there is a performance increase
$sw = [Diagnostics.Stopwatch]::new()
$files = gci . *.html -Recurse
foreach($file in $files)
{
  $File_Content = Get-Content -Encoding UTF8 -Path $file.PSpath -raw;
  $sw.start();
  $File_Content = $File_Content -replace '(<img )(?!.*alt=".*")' , '$1alt="" ';
  $sw.stop();
  $File_Content | Set-Content -Encoding UTF8 -Path $file.PSpath;
}
echo $sw.ElapsedMilliseconds
#Took 10-11 milliseconds when nothing needed to replace, up to around 20milliseconds when replacing 720 matches.
$File_Content = $File_Content -replace '(<img )(?!.*alt=".*")' , '$1alt="" ';
#Took on average 50,000 milliseconds (50 seconds) with no matches, and around the same time even with the 720 matches.
$File_Content = $File_Content -replace '(?!.*alt=".*")(.*)(<img)(.*)' , '$1$2 alt=""$3';
