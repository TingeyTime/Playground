#The convenience of these scripts can be increased by using a text editor (such as Atom) that can have a built in PowerShell that will automatically open within the directory you are working in.

#This is will find and replace for an entire directory, just copy past it into your Windows PowerShell. Make sure you are in the correct directory before running this.
$files = Get-ChildItem . *.html -rec
foreach ($file in $files)
{
(Get-Content -Encoding UTF8 -Path $file.PSPath -raw) -replace '(\w*[^\x00-\x7F×]+(\w* *[\w./,\- -][^\x00-\x7F×]+)*\w*)', '<span lang="ja">$1</span>' | Set-Content -Encoding UTF8 -Path $file.PSPATH;
(Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace '(\r\n(|(\*))((\d*)|[a-z])(\.|\)|@) )', '[/HTML]$1[HTML]' | Set-Content -Encoding UTF8 -Path $file.PSpath;
(Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace '(\r\n@\[Always\] )','[/HTML]$1[HTML]' | Set-Content -Encoding UTF8 -Path $file.PSpath;
(Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace '( = )','[/HTML]$1[HTML]' | Set-Content -Encoding UTF8 -Path $file.PSpath;
(Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace '(\r\n\r\n)','[/HTML]$1' | Set-Content -Encoding UTF8 -Path $file.PSpath;
(Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace '(((Passage: |Id: )[\w-]*)|(Objectives: [\d\. ,]*)|(Score: *\d*, *Partial))(\[/HTML\])','$1' | Set-Content -Encoding UTF8 -Path $file.PSpath;
(Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace '((\[HTML\])\[HTML\])|((\[/HTML\])\[/HTML\])','$2$4' | Set-Content -Encoding UTF8 -Path $file.PSpath;
}

<# Description
$files = Get-ChildItem . *.html -rec :This will assign all of the files in the current directory that are .html to an array of the name "$files" (so this can be changed for any filetype that you want. *.* is every file in the directory)
foreach ($file in $files)  :Will begin a loop through every file
The next lines are similar to above: you get the content from each file (without the -raw it will split each file into an array, like the $files = Get-ChildItem command, which we don't want since we matched some lines based on newlines), then replace based on your match and replace input you gave
Set-Content is what will save your changes to the current file
-Encoding UTF8 is because the HTML files use that encoding in my file base and this will prevent any accidental symbol changes
#>


#For single file use, assign $file_name to be to whatever file name you want, such as below
$file_name = 'ReplaceFile1.html'
(Get-Content -Encoding UTF8 -Path $file_name -raw) -replace '(\w*[^\x00-\x7F×]+(\w* *[\w./,\- -][^\x00-\x7F×]+)*\w*)', '<span lang="ja">$1</span>' | Set-Content -Encoding UTF8 -Path $file_name;
(Get-Content -Encoding UTF8 -Path $file_name -raw) -replace '(\r\n(|(\*))((\d*)|[a-z])(\.|\)|@) )', '[/HTML]$1[HTML]' | Set-Content -Encoding UTF8 -Path $file_name;
(Get-Content -Encoding UTF8 -Path $file_name -raw) -replace '(\r\n@\[Always\] )','[/HTML]$1[HTML]' | Set-Content -Encoding UTF8 -Path $file_name;
(Get-Content -Encoding UTF8 -Path $file_name -raw) -replace '( = )','[/HTML]$1[HTML]' | Set-Content -Encoding UTF8 -Path $file_name;
(Get-Content -Encoding UTF8 -Path $file_name -raw) -replace '(\r\n\r\n)','[/HTML]$1' | Set-Content -Encoding UTF8 -Path $file_name;
(Get-Content -Encoding UTF8 -Path $file_name -raw) -replace '(((Passage: |Id: )[\w-]*)|(Objectives: [\d\. ,]*)|(Score: *\d*, *Partial))(\[/HTML\])','$1' | Set-Content -Encoding UTF8 -Path $file_name;
(Get-Content -Encoding UTF8 -Path $file_name -raw) -replace '((\[HTML\])\[HTML\])|((\[/HTML\])\[/HTML\])','$2$4' | Set-Content -Encoding UTF8 -Path $file_name;

#blank replace line, add regex to first quotes then the replace in the 2nd quotes.
(Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace '' , '' | Set-Content -Encoding UTF8 -Path $file.PSpath;

#Insert new Find & Replace here. Copy paste any regex find and replace in this file to within the brackets to run that expression on every file in a directory
$files = Get-ChildItem . *.html -rec
foreach ($file in $files)
{

}
#I inserted stopwatches because I was curious how fast they run.
#Basic Accessibility changes, more optimized version below this one.
$sw = [Diagnostics.Stopwatch]::new()
$sw.start()
$files = Get-ChildItem . *.html -rec
foreach ($file in $files)
{
  Write-Host $file -ForegroundColor Cyan;
  (Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace '<i>' , '<em>' | Set-Content -Encoding UTF8 -Path $file.PSpath;
  Write-Host "Finished replacing <i> with <em>";
  (Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace '</i>' , '</em>' | Set-Content -Encoding UTF8 -Path $file.PSpath;
  Write-Host "Finished replacing </i> with </em>";
  (Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace '<b>' , '<strong>' | Set-Content -Encoding UTF8 -Path $file.PSpath;
  Write-Host "Finished replacing <b> with <strong>";
  (Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace '</b>' , '</strong>' | Set-Content -Encoding UTF8 -Path $file.PSpath;
  Write-Host "Finished replacing </b> with </strong>";
  (Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace '(<img )(?!.*alt=".*")' , '$1alt="" ' | Set-Content -Encoding UTF8 -Path $file.PSpath;
  Write-Host 'Finished replacing missing alt=""';
  (Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace 'alt="banner"' , 'alt=""' | Set-Content -Encoding UTF8 -Path $file.PSpath;
  Write-Host 'Finished replacing alt="banner" with alt=""';
  (Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace 'alt="\[~\][/%\.\w\d]*"' , 'alt=""' | Set-Content -Encoding UTF8 -Path $file.PSpath;
  Write-Host 'Finished replacing alt text with image link with alt=""';
  (Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace 'alt="Placeholder for LessonBanner"' , 'alt=""' | Set-Content -Encoding UTF8 -Path $file.PSpath;
  Write-Host 'Finished replacing alt="Placeholder for LessonBanner" with alt=""';
  (Get-Content -Encoding UTF8 -Path $file.PSpath -raw) -replace 'alt="Placeholder Text"' , 'alt=""' | Set-Content -Encoding UTF8 -Path $file.PSpath;
  Write-Host 'Finished replacing alt="Placeholder Text" with alt=""';
}
$sw.stop()
echo $sw.ElapsedMilliseconds
#If you are worried about ruining everything when making changes, make sure you create a back up folder. This is a command that will copy the entire current directory to the destination given. You will also need to change the destination away from the one I put, which is just an example.
Copy-Item . -Recurse C:\users\jwilli48\Desktop\COURSE_BACKUP\COURSE-NAME-M001_BACKUP

#Different implementation of above, runs around 6 times faster (1.5seconds vs. 9seconds)
$sw = [Diagnostics.Stopwatch]::new()
$sw.start()
$files = Get-ChildItem . *.html -rec
foreach ($file in $files)
{
  Write-Host $file -ForegroundColor Cyan;
  $File_Content = Get-Content -Encoding UTF8 -Path $file.PSpath -raw;

  $File_Content = $File_Content -replace '<i>' , '<em>';
  Write-Host "Finished replacing <i> with <em>";
  $File_Content = $File_Content -replace '</i>' , '</em>';
  Write-Host "Finished replacing </i> with </em>";
  $File_Content = $File_Content -replace '<b>' , '<strong>';
  Write-Host "Finished replacing <b> with <strong>";
  $File_Content = $File_Content -replace '</b>' , '</strong>';
  Write-Host "Finished replacing </b> with </strong>";
  $File_Content = $File_Content -replace '(<img )(?!.*alt=".*")' , '$1alt="" ';
  Write-Host 'Finished replacing missing alt=""';
  $File_Content = $File_Content -replace 'alt="banner"' , 'alt=""';
  Write-Host 'Finished replacing alt="banner" with alt=""';
  $File_Content = $File_Content -replace 'alt="\[~\][/%\.\w\d]*"' , 'alt=""';
  Write-Host 'Finished replacing alt text with image link with alt=""';
  $File_Content = $File_Content -replace 'alt="Placeholder for LessonBanner"' , 'alt=""';
  Write-Host 'Finished replacing alt="Placeholder for LessonBanner" with alt=""';
  $File_Content = $File_Content -replace 'alt="Placeholder Text"' , 'alt=""';
  Write-Host 'Finished replacing alt="Placeholder Text" with alt=""';

  $File_Content | Set-Content -Encoding UTF8 -Path $file.PSpath;
  Write-Host 'File saved' -ForegroundColor Blue;
}
$sw.stop();
echo $sw.ElapsedMilliseconds;
#Other Commands
Set-PSDebug -Trace 1
