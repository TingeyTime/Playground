#It just doesn't save correctly for some reason when within the for loop. I run them seperately by hand and it seems to work sometimes, but no matter how I program it it doesn't save the change to the alt text. I tried just .click() on the save button as well as moving the mouse to the save button and having powershell 'click' it.
function Click-MouseButton
{
    $signature=@'
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@

    $SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru

        $SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0);
        $SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0);
}

$IE = New-Object -ComObject "InternetExplorer.Application"
$url = "https://byumastercourses.next.agilixbuzz.com/login"
$IE.visible = $true
$IE.navigate2($url)
$IE.fullscreen = $true
Read-Host 'Ready?'
for($i = [int]'0'; $i -lt [int]'9'; $i++){
  ($ie.document.getElementsByTagName('a') | Where-Object {$_.innerText -match '.*Edit.*' -and $_.innerHTML -match '.*pencil.*'} | Select-Object -index $i).click()
  Start-Sleep -Seconds 5
  ($ie.document.getElementsByTagName('img') | Where-Object {$_.className -match '.*fr-fic.*'} | foreach{ $_.alt = "" })
  Read-Host 'Ready?'
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point('3379','24')
  Click-MouseButton
  Start-Sleep -Seconds 5
}

[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point('1600','600')
Click-MouseButton
start-sleep -seconds 1
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point('1608','708')
Click-MouseButton
start-sleep -seconds 1



Get-Content 'C:\Users\jwilli48\Desktop\LinkList\PIANO-041-D002_LinkList.txt' | Select-String -Pattern 'href="(.*?)"' -Allmatches | foreach {
  $link = $($_.matches.Value -replace 'href="(.*?)"', '$1')
  Write-Host $link
  Start-Process 'Chrome.exe' $link
}
Invoke-Webrequest




function Click-MouseButton
{
    $signature=@'
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@

    $SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru

        $SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0);
        $SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0);
}
$xStart = '1370'
$yStart = '375'
$yDistance = '60'
$yEdit = '20'
$xImage = '850'
$yImage = '765'
$xCurrent = $xStart
$yCurrent = $yStart
for($i = [int]'0'; $i -lt [int]'3'; $i++){
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($xCurrent,$yCurrent)
  Click-MouseButton
  Start-Sleep 2
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($xCurrent,$([int]$yCurrent + [int]$yEdit))
  Click-MouseButton
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($xImage,$yImage)
  Click-MouseButton
  $xCurrent = $xStart
  $yCurrent = [int]$yCurrent + [int]$yDistance
}
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(,)
