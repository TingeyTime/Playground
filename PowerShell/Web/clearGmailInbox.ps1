###PRELOAD###
  $chrome = New-Object OpenQA.Selenium.Chrome.Chromedriver
  $chromeWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($chrome, (New-TimeSpan -Seconds 5))
  $conditions = [OpenQA.Selenium.Support.UI.ExpectedConditions]
  $by = [OpenQA.Selenium.By]
  $keys = [OpenQA.Selenium.Keys]
  $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("body")))
###END PRELOAD###

#This is logging in to gmail
$chrome.url = "https://mail.google.com"
$chromeWait.Until($conditions::ElementIsVisible($by::CssSelector("input"))).sendKeys($GoogleCredentials.username)
($chrome.FindElementsByTagName('content') | Where-Object {$_.text -match 'Next'}).click()
$chromeWait.Until($conditions::ElementIsVisible($by::CssSelector("input[type='password']"))).sendKeys($GoogleCredentials.GetNetworkCredential().password)
($chrome.FindElementsByTagName('content') | Where-Object {$_.text -match 'Next'}).click()

#Loop until nothing is left unread in inbox
while($chromeWait.Until($conditions::ElementIsVisible($by::CssSelector("a[title*='Inbox']"))).text[7] -ne $NULL){
  $chromeWait.Until($conditions::ElementIsVisible($by::CssSelector("div[id=':jy']"))).click()
  $chrome.FindElement
  $chromeWait.Until($conditions::ElementIsVisible($by::CssSelector("div[aria-label='Refresh']"))).click()
}
