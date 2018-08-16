###PRELOAD###
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

$chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('id') -match 'netid' } | % {$_.sendKeys($BYUcredentials.username)}
$chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('id') -match 'password' } | % {$_.sendKeys($BYUcredentials.GetNetworkCredential().password)}
$chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('value') -match 'Sign In' } | Select-Object -index 0 | % {$_.submit()}
#Always needs to do DUO verification with this automated browser
Read-Host 'Waiting for DUO Verification'
#Switches back to correct tab as previous one was closed
$chrome.SwitchTo().Window($chrome.WindowHandles[0])
#Searches and goes to course specified
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
      #The image
      $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("img[class*='fr-draggable']"))) | Out-Null
      #If the image has a title, remove remove it.
      if($chrome.FindElementsByCssSelector("img[class*='fr-draggable']").getAttribute('title') -ne ''){
        $chrome.ExecuteScript("document.querySelector(`"img[class*='fr-draggable']`").setAttribute('title','')")
      }
      #Enter image options
      $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("img[class*='fr-draggable']"))).click()
      #Option to edit alt text
      $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("button[id*='imageAlt']"))).click()
      #Clears and saves blank alt text
      $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("input[placeholder*='Alternative']"))).clear()
      #Update and save
      ($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Update'}).click()
      ($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Save'}).click()
      Write-Progress -Activity "Removing titles and alt text" -Status "Progress:" -PercentComplete ($i/$numberofModules.count*100)
    }
  catch{
      #If a timeout error happens above(meaning there is not img with alt text that can be edited) it will just save the page and restart the loop on the next module
      Write-Host 'Nothing Found'
      ($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Save'}).click()
      continue
    }
  }
  $loopAgain = Read-Host "Do you want to loop again? (Y/N)"
}while($loopAgain -match 'Y')
