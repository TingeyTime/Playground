###PRELOAD###
  [System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\WebDriver.dll")
  [System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\WebDriver.Support.dll")
  [System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\Selenium.WebDriverBackedSelenium.dll")
  [System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\ThoughtWorks.Selenium.Core.dll")
  $chrome = New-Object OpenQA.Selenium.Chrome.Chromedriver
  $chromeWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($chrome, (New-TimeSpan -Seconds 3))
  $conditions = [OpenQA.Selenium.Support.UI.ExpectedConditions]
  $by = [OpenQA.Selenium.By]
  $keys = [OpenQA.Selenium.Keys]
  $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("body")))
###END PRELOAD###

#Navigates to URL
$chrome.url = "https://byumastercourses.next.agilixbuzz.com/login"
#Waits for login button to show up
$chromeWait.until($conditions::ElementIsVisible($by::ClassName("mat-button"))).click()
#Switches window tabs to newly created one
$chrome.SwitchTo().Window($chrome.WindowHandles[1])
#Waits for input boxes to appear
$chromeWait.Until($conditions::ElementIsVisible($by::ID('netid')))
$credentials = Get-Credential
$chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('id') -match 'netid' } | % {$_.sendKeys($credentials.username)}
$chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('id') -match 'password' } | % {$_.sendKeys($credentials.GetNetworkCredential().password)}
$chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('value') -match 'Sign In' } | Select-Object -index 0 | % {$_.submit()}
#Always needs to do DUO verification with this automated browser
Read-Host 'Waiting for DUO Verification'
#Switches back to correct tab as previous one was closed
$chrome.SwitchTo().Window($chrome.WindowHandles[0])
#Searches and goes to course specified
$courseName = Read-Host 'Course Name'
$chrome.FindElementsByTagName('mat-card-title') | Where-Object {$_.text -match $courseName} | % {$_.click()}

#The main loop once you get to the pages you want to remove alt text from.
Read-Host "Ready?"
#Gets the number of modules on the page for how many loops needed
$loopAgain = 'No'
do{
  $numberOfModules = $chrome.FindElementsByTagName('button') | Where-Object {$_.getAttribute('class') -match '.*glyphicon-option.*'} | measure
  for($i = [int]'0'; $i -lt $($numberOfModules.count - 1); $i++){
    try{
      #Module option menu
      $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("button[class*='glyphicon-option']"))) | Out-Null
      ($chrome.FindElementsByTagName('button') | Where-Object {$_.getAttribute('class') -match '.*glyphicon-option.*'} | Select-Object -index $i).click()
      #Button to begin editing
      $chromeWait.until($conditions::ElementIsVisible($by::LinkText('Edit'))).click()

      $pageHtml = $chromeWait.Until($conditions::ElementIsVisible($by::CssSelector("div[contenteditable='true']"))).getAttribute('innerHTML')
      $pageTitle = $chrome.FindElementsByCssSelector("div[class='dialog-title']").text
      $pageHtml | Out-File -FilePath $('C:\Users\nltingey\Desktop\Testing\' + $pageTitle + '.html') -Encoding UTF8

      $chrome.FindElementsByCssSelector("button[mattooltip='Back']").click()
      try{
        $chromeWait.Until($conditions::ElementIsVisible($by::CssSelector("div[class*='xli-modal-header']")))
        $chrome.FindElementsByCssSelector("span[class*='mat-button-wrapper']") | ? {$_.text -match 'Leave'} | % {$_.click()}
      }catch{}
      Write-Host $($pageTitle + ' file was created.' + "`t`t`t`t(" + ($i + 1) + '/' + ($numberOfModules.count - 1) + ')')
      Write-Progress -Activity "Saving Files" -Status "Progress:" -PercentComplete ($i/$numberofModules.count*100)
    }


  catch{
      #If a timeout error happens above(meaning there is not img with alt text that can be edited) it will just save the page and restart the loop on the next module
      $chrome.FindElementsByCssSelector("button[mattooltip='Back']").click()
      try{
        $chromeWait.Until($conditions::ElementIsVisible($by::CssSelector("div[class*='xli-modal-header']")))
        $chrome.FindElementsByCssSelector("span[class*='mat-button-wrapper']") | ? {$_.text -match 'Leave'} | % {$_.click()}
      }catch{}
    }
  }
  $i = '0'
  $loopAgain = Read-Host "Do you want to loop again? (Y/N)"
  Write-Host "`n"
}while($loopAgain -match 'Y')
