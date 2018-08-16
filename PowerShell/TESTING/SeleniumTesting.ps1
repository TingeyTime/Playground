#Loads Selenium
[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\WebDriver.dll")
[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\WebDriver.Support.dll")
[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\Selenium.WebDriverBackedSelenium.dll")

#Starts a Chrome controlled by Selenium
$chrome = New-Object "OpenQA.Selenium.Chrome.Chromedriver"
#Run $chrome | gm to get methods

#Controls focus / contains operations you can do
$actions = New-Object  OpenQA.Selenium.Interactions.Actions($chrome)
#Run #actions | gm to get methods

#Changes which tab you are on
$chrome.SwitchTo().Window($chrome.WindowHandles[1])


#Random commands that could be useful
$chrome.FindElementByClassName('submit').submit()
$actions.MoveToElement($MyElement).click().perform()
$MyElement = $chrome.FindElementByClassName('submit')
($chrome.FindElementsByTagName('button') | Where-Object {$_.getAttribute('class') -match '.*glyphicon-option.*'} | Select-Object -index 0)
($chrome.FindElementsByTagName('a') | Where-Object {$_.Displayed -eq 'true' -and $_.getAttribute('text') -match '.*Edit.*'}).click()
($chrome.FindElementsByTagName('img') | Where-Object {$_.getAttribute('class') -match '.*fr-draggable'}).click()
($chrome.FindElementsByTagName('button') | Where-Object {$_.getAttribute('id') -match '.*imageAlt-2.*'}).click()
($chrome.FindElementsByTagName('input') | Where-Object {$_.getAttribute('placeholder') -match '.*Alternative.*'}).clear()
($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Save'}).click()
($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Update'}).click()

#Script Testing
for($i = [int]'0'; $i -lt [int]'9'; $i++){
  ($chrome.FindElementsByTagName('button') | Where-Object {$_.getAttribute('class') -match '.*glyphicon-option.*'} | Select-Object -index $i).click()
  Read-Host 'Ready?'
  ($chrome.FindElementsByTagName('a') | Where-Object {$_.Displayed -eq 'true' -and $_.getAttribute('text') -match '.*Edit.*'}).click()
  Read-Host 'Ready?'
  ($chrome.FindElementsByTagName('img') | Where-Object {$_.getAttribute('class') -match '.*fr-draggable'} | Select-Object -index 0).click()
  Read-Host 'Ready?'
  ($chrome.FindElementsByTagName('button') | Where-Object {$_.getAttribute('id') -match '.*imageAlt.*'}).click()
  Read-Host 'Ready?'
  ($chrome.FindElementsByTagName('input') | Where-Object {$_.getAttribute('placeholder') -match '.*Alternative.*'}).clear()
  Read-Host 'Ready?'
  ($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Update'}).click()
  Read-Host 'Ready?'
  ($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Save'}).click()
  Read-Host 'Ready?'
}

$chrome.SwitchTo().Window($chrome.WindowHandles[0])
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

(New-Object -ComObject WScript.Shell).AppActivate((gps | Where-Object {$_.MainWindowTitle -eq 'Chrome - Google Chrome'}).MainWindowTitle)
(gps | Where-Object {$_.MainWindowTitle -eq 'Chrome - Google Chrome'}).MainWindowHandle

$sig = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
Add-Type -MemberDefinition $sig -name NativeMethods -namespace Win32
$hwnd = (gps | Where-Object {$_.MainWindowTitle -eq 'Chrome - Google Chrome'}).MainWindowHandle
# Minimize window
[Win32.NativeMethods]::ShowWindowAsync($hwnd, 2)
# Restore window
[Win32.NativeMethods]::ShowWindowAsync($hwnd, 4)
Start-Sleep 1
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
