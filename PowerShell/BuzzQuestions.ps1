#For Buzz Language Question assessments. This will only work on one file at a time, which is fine since you are going to need to copy paste the buzz question plain text code into a different file of the name assigned to $file_name then copy paste it back into Buzz.
$file_name = 'ReplaceFile1.html'
(Get-Content -Encoding UTF8 -Path $file_name -raw) -replace '(\w*[^\x00-\x7F×]+(\w* *[\w./,\- -][^\x00-\x7F×]+)*\w*)', '<span lang="ja">$1</span>' | Set-Content -Encoding UTF8 -Path $file_name;
(Get-Content -Encoding UTF8 -Path $file_name -raw) -replace '(\r\n(|(\*))((\d*)|[a-z])(\.|\)|@) )', '[/HTML]$1[HTML]' | Set-Content -Encoding UTF8 -Path $file_name;
(Get-Content -Encoding UTF8 -Path $file_name -raw) -replace '(\r\n@\[Always\] )','[/HTML]$1[HTML]' | Set-Content -Encoding UTF8 -Path $file_name;
(Get-Content -Encoding UTF8 -Path $file_name -raw) -replace '( = )','[/HTML]$1[HTML]' | Set-Content -Encoding UTF8 -Path $file_name;
(Get-Content -Encoding UTF8 -Path $file_name -raw) -replace '(\r\n\r\n)','[/HTML]$1' | Set-Content -Encoding UTF8 -Path $file_name;
(Get-Content -Encoding UTF8 -Path $file_name -raw) -replace '(((Passage: |Id: )[\w-]*)|(Objectives: [\d\. ,]*)|(Score: *\d*, *Partial))(\[/HTML\])','$1' | Set-Content -Encoding UTF8 -Path $file_name;
(Get-Content -Encoding UTF8 -Path $file_name -raw) -replace '((\[HTML\])\[HTML\])|((\[/HTML\])\[/HTML\])','$2$4' | Set-Content -Encoding UTF8 -Path $file_name;
