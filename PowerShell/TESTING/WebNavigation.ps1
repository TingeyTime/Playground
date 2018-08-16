$IE = New-Object -ComObject "InternetExplorer.Application"
$url = "https://byumastercourses.next.agilixbuzz.com/login"
$IE.visible = $true
$IE.navigate2($url)
$IE.fullscreen = $true
while($ie.Busy){Start-Sleep -Seconds 5}
($ie.document.getElementsByTagName('button') | select -first 1).click()

($ie.document.getElementsByTagName('button') | Where-Object {$_.title -eq "Actions"} | select -first 1).click()
#You can skip to command above this and just do this one.
($ie.document.getElementsByTagName('a') | Where-Object {$_.innerText -match '.*Edit.*' -and $_.innerHTML -match '.*pencil.*'} | select -first 1).click()
#Change alt text for images on the page to be blank alt text.
($ie.document.getElementsByTagName('img') | Where-Object {$_.className -match '.*fr-fic.*'}).alt = ""
($doc.getElementsByTagName('img') | Where-Object {$_.className -match '.*fr-fic.*'} | foreach{ $_.alt = "" })
#Move mouse to the Code View button.
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point('1942','499')

#Performs a left click whereever the mouse is. For some reason this function is really touchy, make sure to copy pate it exactly how it is and don't change any spacing or things like that
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

Click-MouseButton

#Hits the save button
($ie.document.getElementsByTagName('button') | Where-Object {$_.textContent -match '.*save.*'} | select -first 1).click()
#Editing alt text. This selects the first line and replaces alt text but it doesn't work for some reason
($ie.document.getElementsByTagName('span') | Where-Object {$_.role -eq 'presentation'} | select -first 1).innerHTML = ($ie.document.getElementsByTagName('spa
n') | Where-Object {$_.role -eq 'presentation'} | select -first 1).innerHTML -replace '(alt</span>=<span class="cm-string">)"' , '$1"test'


#Scripting Attempts.
######################
#Create IE object
$IE = New-Object -ComObject "InternetExplorer.Application"
$url = "https://byumastercourses.next.agilixbuzz.com/login"
$IE.visible = $true
$IE.navigate2($url)
#You should now manually navigate to where you need to be
#Begin to go through each edit of the pages you have selected
$ie.document.getElementsByTagName('a') | Where-Object {$_.innerText -match '.*Edit.*' -and $_.innerHTML -match '.*pencil.*'} | foreach{
  $_.click()
  Start-Sleep -Seconds 6
  $ie.document.getElementsByTagName('img') | Where-Object {$_.className -match '.*fr-fic.*'} | foreach{ $_.alt = "" }
  Write-Host 'Alt text changed' -ForegroundColor Cyan
  ($ie.document.getElementsByTagName('button') | Where-Object {$_.textContent -match '.*save.*'}).click()
  Write-Host 'Saving...' -ForegroundColor Green
  Start-Sleep -Seconds 6
}
#Code above won't work because it involves the page refreshing so the first foreach loop is broken
------
$ie.document.getElementsByTagName('a') | Where-Object {$_.innerText -match '.*Edit.*' -and $_.innerHTML -match '.*pencil.*'} | foreach{
  $_
  start-sleep -seconds 5
}

##Attempt 2
for($i = [int]'0'; $i -lt [int]'9'; $i++){
  ($ie.document.getElementsByTagName('a') | Where-Object {$_.innerText -match '.*Edit.*' -and $_.innerHTML -match '.*pencil.*'} | Select-Object -index $i).click()
  Read-Host 'Ready?'
  ($ie.document.getElementsByTagName('img') | Where-Object {$_.className -match '.*fr-fic.*'} | foreach{ $_.alt = "" })
  Read-Host 'Ready?'
  ($ie.document.getElementsByTagName('button') | Where-Object {$_.textContent -match '.*save.*'}).click()
  Read-Host 'Ready?'
}

do{
  ($ie.document.getElementsByTagName('a') | Where-Object {$_.innerText -match '.*Edit.*' -and $_.innerHTML -match '.*pencil.*'} | Select-Object -index $i).click()
  Start-Sleep -Seconds 5
  ($ie.document.getElementsByTagName('img') | Where-Object {$_.className -match '.*fr-fic.*'} | foreach{ $_.alt = "" })
  ($ie.document.getElementsByTagName('button') | Where-Object {$_.textContent -match '.*save.*'}).click()
  Start-Sleep -Seconds 5
}while(($ie.document.getElementsByTagName('a') | Where-Object {$_.innerText -match '.*Edit.*' -and $_.innerHTML -match '.*pencil.*'} | Select-Object -index $i) -ne $null)
