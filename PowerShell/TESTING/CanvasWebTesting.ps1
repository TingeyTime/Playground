#Setup to use selenium
[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\WebDriver.dll")
[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\WebDriver.Support.dll")
[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\Selenium.WebDriverBackedSelenium.dll")
[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\ThoughtWorks.Selenium.Core.dll")
$chrome = New-Object "OpenQA.Selenium.Chrome.Chromedriver"
$chromeWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($chrome, (New-TimeSpan -Seconds 5))
#Conditions class to be used by $chromeWait
$conditions = [OpenQA.Selenium.Support.UI.ExpectedConditions]
#By class is used by the $conditions class to find specific elements
$by = [OpenQA.Selenium.By]

#Navigate to Canvas
$chrome.url = "https://byu.instructure.com/"
#Login (Will need to do the duo authentication manually)
Start-Sleep 2
$chromeWait.Until($conditions::ElementIsVisible($by::ID('netid')))
$password = Read-Host 'Password'
$chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('id') -match 'netid' } | % {$_.sendKeys('jwilli48')}
$chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('id') -match 'password' } | % {$_.sendKeys($password)}
$chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('value') -match 'Sign In' } | Select-Object -index 0 | % {$_.submit()}
#Always needs to do DUO verification with this
Read-Host 'Waiting for DUO Verification'
#Goes to course here
$courseName = Read-Host 'Name of course'
$chrome.FindElementsByTagName('div') | Where-Object {$_.getAttribute('title') -match $courseName} | Select-Object -index 0 | % {$_.click()}
$chromeWait.Until($conditions::ElementIsVisible($by::ClassName('item_name')))

#Loop through all modules within the course
$numberOfModules = $chrome.FindElementsByClassName('item_name') | Where-Object {$_.text -ne ''} | measure
for($i=0; $i -lt $numberOfModules.count; $i++){
  try{
    $chromeWait.Until($conditions::ElementIsVisible($by::ClassName('item_name')))
    #Selects module you are on
    $chrome.FindElementsByClassName('item_name') | Select-Object -index $i | % {$_.click()}
    #Hits edit button once it appears
    $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("a[class*='edit']"))).click()
    $iframe = $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("iframe[id*='wiki_page_body']")))
    #Enters the editable frame, not sure if this is even where you can change things
    $chrome.switchTo().frame($iframe);
    #Changes first image alt text to be empty, which we need to be careful about as if there is no banner it will clear the alt text for whatever himage is first
    $chrome.ExecuteScript("document.querySelector(`"img`").setAttribute('alt','')")
    #Hits save button
    $chrome.SwitchTo().Window($chrome.CurrentWindowHandle)
    $chrome.FindElementsByCssSelector("button[class*='submit']").click()
    #The home button is always there but we still need to wait for the page saves before hitting the home button, so instead we wait for the edit button to appear again
    $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("a[class*='edit']")))
    $chrome.FindElementsByCssSelector("a[class='home']").click()
  }
    catch{
      #If no image is found it will save page and go back to home to begin the loop again
      Write-Host 'No image found'
      $chrome.SwitchTo().Window($chrome.CurrentWindowHandle)
      $chrome.FindElementsByCssSelector("button[class*='submit']").click()
      $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("a[class*='edit']")))
      $chrome.FindElementsByCssSelector("a[class='home']").click()
      continue
    }
}



#In order to find anything within the edit box you need to switch focus to that iframe and then when finished you need to change it back
$chrome.FindElementsByTagName('iframe') | Where-Object {$_.getAttribute('id') -match 'wiki_page_body'}
$chrome.switchTo().frame($iframe);
$chrome.SwitchTo().Window($chrome.CurrentWindowHandle)

#As of now I can not figure out how to change anything within the editable content
#Options are to either enter the iframe or finding the textarea tag, but I haven't been able to change the content from either of those options
$chrome.ExecuteScript("document.getElementById('testing').alt = ''")
$chrome.ExecuteScript("document.querySelector(`"img`").alt = ''")
#Gets first elemetn to match CssSelector
$chrome.ExecuteScript("document.querySelector(`"img`").setAttribute('alt','')")
$chrome.ExecuteScript("document.querySelector(`"img[alt*='banner']`").setAttribute('alt','test')")
