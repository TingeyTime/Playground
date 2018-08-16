#Loop through all modules within the course
$numberOfModules = $chrome.FindElementsByClassName('item_name') | Where-Object {$_.text -ne ''} | measure
for($i=0; $i -lt $numberOfModules.count; $i++){
  try{
    $chromeWait.Until($conditions::ElementIsVisible($by::ClassName('item_name'))) | Out-Null
    #Selects module you are on
    $chrome.FindElementsByClassName('item_name') | Select-Object -index $i | % {$_.click()}
    #Hits edit button once it appears
    $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("a[class*='edit']"))).click() | Out-Null
    $iframe = $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("iframe[id*='wiki_page_body']")))
    #Enters the editable frame, not sure if this is even where you can change things
    $chrome.switchTo().frame($iframe) | Out-Null
    #Changes first image alt text to be empty, which we need to be careful about as if there is no banner it will clear the alt text for whatever himage is first
    $chrome.ExecuteScript("document.querySelector(`"img`").setAttribute('alt','')")
    #Hits save button
    $chrome.SwitchTo().Window($chrome.CurrentWindowHandle) | Out-Null
    $chrome.FindElementsByCssSelector("button[class*='submit']").click()
    #The home button is always there but we still need to wait for the page saves before hitting the home button, so instead we wait for the edit button to appear again
    $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("a[class*='edit']"))) | Out-Null
    $chrome.FindElementsByCssSelector("a[class='home']").click()
  }
    catch{
      #If no image is found it will save page and go back to home to begin the loop again
      $chrome.SwitchTo().Window($chrome.CurrentWindowHandle) | Out-Null
      $chrome.FindElementsByCssSelector("button[class*='submit']").click()
      $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("a[class*='edit']")))
      $chrome.FindElementsByCssSelector("a[class='home']").click()
    }
}
