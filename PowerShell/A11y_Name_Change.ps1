#Directory copying to must already exists. Will copy all files to a different directory and rename them to have a11y_ in the front of the file name.
$files = Get-ChildItem  . -include @('*.xlsx', '*.docx') -rec -Exclude '~*' | Where {$_.FullName -notlike '*AA team folders*'}
foreach($file in $files){
    $File_Name = Split-Path -Path $file.PSpath -Leaf -Resolve
    Copy-Item -Path $file.PSpath -Destination $('C:\Users\jwilli48\Desktop\Buzz_New_File_Names\' + 'a11y_' + $File_Name) -Recurse
}
