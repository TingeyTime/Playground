###PRELOAD###
  $chrome = New-Object OpenQA.Selenium.Chrome.Chromedriver
  $chromeWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($chrome, (New-TimeSpan -Seconds 5))
  $conditions = [OpenQA.Selenium.Support.UI.ExpectedConditions]
  $by = [OpenQA.Selenium.By]
  $keys = [OpenQA.Selenium.Keys]
  $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("body")))
###END PRELOAD###

#Navigate to Canvas
$chrome.url = "https://byu.instructure.com/"
#Login (Will need to do the duo authentication manually)
$chromeWait.Until($conditions::ElementIsVisible($by::ID('netid')))
$chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('id') -match 'netid' } | % {$_.sendKeys($BYUcredentials.username)}
$chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('id') -match 'password' } | % {$_.sendKeys($BYUcredentials.GetNetworkCredential().password)}
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
      $chrome.SwitchTo().Window($chrome.CurrentWindowHandle)
      $chrome.FindElementsByCssSelector("button[class*='submit']").click()
      $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("a[class*='edit']")))
      $chrome.FindElementsByCssSelector("a[class='home']").click()
    }
}
