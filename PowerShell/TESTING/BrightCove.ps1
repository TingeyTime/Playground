$idList = @()
$videoNameList = @()
$videoLength = @()

$chrome.FindElementsByCssSelector('small') | ? {$_.text -match '\d{13}'} | %{$idList += $_.text}
$chrome.FindElementsByCssSelector('a[title*=" "') | % {$videoNameList += $_.text}
$chrome.FindElementsByCssSelector("div[class*='runtime']") | % {$videoLength += $_.text}

function ArrayToTable {
    param(
    [string]$idList,
    [string]$videoNameList,
    [string]$videoLength
    )
    $obj = New-Object PSObject
    $obj | Add-Member NoteProperty ID($idList)
    $obj | Add-Member NoteProperty Video_Name($videoNameList)
    $obj | Add-Member NoteProperty Video_Length($videoLength)
    Write-Output $obj
}

for($i = 0; $i -lt $idList.length; $i++){ (ArrayToTable $idList[$i] $videoNameList[$i] $videoLength[$i]) | Export-Csv -Path C:\Users\jwilli48\Desktop\test.csv -Append}
