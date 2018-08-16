###PRELOAD###
  $chrome = New-Object OpenQA.Selenium.Chrome.Chromedriver
  $chromeWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($chrome, (New-TimeSpan -Seconds 5))
  $conditions = [OpenQA.Selenium.Support.UI.ExpectedConditions]
  $by = [OpenQA.Selenium.By]
  $keys = [OpenQA.Selenium.Keys]
  $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("body")))
###END PRELOAD###

#Navigates to URL
$chrome.url = "https://byumastercourses.next.agilixbuzz.com/login"
#Waits for login button to show up
$chromeWait.until($conditions::ElementIsVisible($by::ClassName("mat-button"))).click()
#Switches window tabs to newly created one / the 2nd tab
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
#Searches for and goes to course specified
$courseName = Read-Host 'Course Name'
$chrome.FindElementsByTagName('mat-card-title') | Where-Object {$_.text -match $courseName} | % {$_.click()}

#The main loop once you get to the pages you want to remove alt text from.
Read-Host "Ready?"
#Variable to allow one to loop as many times as they want
$loopAgain = 'No'
do{
  #Gets the number of modules on the page for how many loops needed
  $numberOfModules = $chrome.FindElementsByTagName('button') | Where-Object {$_.getAttribute('class') -match '.*glyphicon-option.*'} | measure
  for($i = [int]'0'; $i -lt $($numberOfModules.count - 1); $i++){
    try{
      #Module option menu
      $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("button[class*='glyphicon-option']")))
      ($chrome.FindElementsByTagName('button') | Where-Object {$_.getAttribute('class') -match '.*glyphicon-option.*'} | Select-Object -index $i).click()
      #Button to begin editing
      $chromeWait.until($conditions::ElementIsVisible($by::LinkText('Edit'))).click()
      #Replaces identified tag with an h1 tag if the tag exists
      if($chromeWait.until($conditions::ElementIsVisible($by::CssSelector("span[class*='Head1']"))).Displayed){
        $chrome.ExecuteScript("var toReplace = document.querySelector(`"span[class*='Head1']`");
          var h1 = document.createElement('h1');
          h1.innerHTML = toReplace.innerHTML;
          toReplace.parentNode.replaceChild(h1,toReplace);")
      }
      #Gets rid of one font-size 14 span styles, hopefully the one we want but it doesn't really matter, theres to many anyway
      if($chromeWait.until($conditions::ElementIsVisible($by::CssSelector("span[style*='font-size: 14pt;']"))).Displayed){
        $chrome.ExecuteScript("document.querySelector(`"span[style*='font-size: 14pt;']`").setAttribute('style','')")
      }
      #This is to give an extra input needed for Buzz to register that changes had actually happened
      $chrome.FindElementsByCssSelector("button[id*='html']").click()
      #Save document
      ($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Save'}).click()
    }
  catch{
      #If a timeout error happens above(meaning there is not img with alt text that can be edited) it will just save the page and restart the loop on the next module
      #This if statement is to prevent errors if the program entered a non-editable page
      if($chrome.FindElementsByCssSelector("button[id*='html']") -ne $NULL){
        $chrome.FindElementsByCssSelector("button[id*='html']").click()
      }
      ($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Save'}).click()
      continue
    }
  }
  $loopAgain = Read-Host "Do you want to loop again? (Y/N)"
}while($loopAgain -match 'Y')
