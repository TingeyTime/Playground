[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\WebDriver.dll")
[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\WebDriver.Support.dll")
[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\Selenium.WebDriverBackedSelenium.dll")
#Opens a chrome browser that is controlled by Selenium

$chrome = New-Object "OpenQA.Selenium.Chrome.Chromedriver"
$chromeWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($chrome, (New-TimeSpan -Seconds 5))
$conditions = [OpenQA.Selenium.Support.UI.ExpectedConditions]
$by = [OpenQA.Selenium.By]
$chrome.url = "https://byumastercourses.next.agilixbuzz.com/login"
$chromeWait.until($conditions::ElementIsVisible([OpenQA.Selenium.By]::ClassName("mat-button")))

$chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'LOGIN'} | % {$_.click()}
$chrome.SwitchTo().Window($chrome.WindowHandles[1])
$chromeWait.Until($conditions::ElementIsVisible([OpenQA.Selenium.By]::ID('netid')))
$chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('id') -match 'netid' } | % {$_.sendKeys('jwilli48')}
$chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('id') -match 'password' } | % {$_.sendKeys('Joshua.Lee95')}
$chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('value') -match 'Sign In' } | Select-Object -index 0 | % {$_.submit()}
Read-Host 'Waiting for DUO Verification'
$chrome.SwitchTo().Window($chrome.WindowHandles[0])
$courseName = Read-Host 'Course Name'
$chrome.FindElementsByTagName('mat-card-title') | Where-Object {$_.text -match $courseName} | % {$_.click()}

Read-Host 'Ready?'
$numberOfModules = $chrome.FindElementsByTagName('button') | Where-Object {$_.getAttribute('class') -match '.*glyphicon-option.*'} | measure
for($i = [int]'0'; $i -lt $($numberOfModules.count - 1); $i++){
  try{
  $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("button[class*='glyphicon-option']")))
  ($chrome.FindElementsByTagName('button') | Where-Object {$_.getAttribute('class') -match '.*glyphicon-option.*'} | Select-Object -index $i).click()
  $chromeWait.until($conditions::ElementIsVisible($by::LinkText('Edit')))
  ($chrome.FindElementsByTagName('a') | Where-Object {$_.Displayed -eq 'true' -and $_.getAttribute('text') -match '.*Edit.*'}).click()
  $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("img[class*='fr-draggable']")))
  ($chrome.FindElementsByTagName('img') | Where-Object {$_.getAttribute('class') -match '.*fr-draggable'} | Select-Object -index 0).click()
  $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("button[id*='imageAlt']")))
  ($chrome.FindElementsByTagName('button') | Where-Object {$_.getAttribute('id') -match '.*imageAlt.*'}).click()
  $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("input[placeholder*='Alternative']")))
  ($chrome.FindElementsByTagName('input') | Where-Object {$_.getAttribute('placeholder') -match '.*Alternative.*'}).clear()
  ($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Update'}).click()
  ($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Save'}).click()
  }
  catch{
    Write-Host 'Nothing Found'
    ($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Save'}).click()
    continue
  }
}





$chromeWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($chrome, (New-TimeSpan -Seconds 10))
$condition = [OpenQA.Selenium.Support.UI.ExpectedConditions]
$chromeWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisibile([OpenQA.Selenium.By]::ClassName("mat-button")))
