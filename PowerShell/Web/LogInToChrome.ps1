###PRELOAD###
  $chrome = New-Object OpenQA.Selenium.Chrome.Chromedriver
  $chromeWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($chrome, (New-TimeSpan -Seconds 5))
  $conditions = [OpenQA.Selenium.Support.UI.ExpectedConditions]
  $by = [OpenQA.Selenium.By]
  $keys = [OpenQA.Selenium.Keys]
  $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("body")))
###END PRELOAD###

#Logging in through base chrome signin
$chrome.url = "chrome://chrome-signin"

Start-Sleep 1
$chrome.Keyboard.SendKeys($GoogleCredentials.username)
Start-Sleep 1
$chrome.Keyboard.SendKeys($keys::Enter)
Start-Sleep 1
$chrome.Keyboard.SendKeys($GoogleCredentials.GetNetworkCredential().password)
Start-Sleep 1
$chrome.Keyboard.SendKeys($keys::Enter)
