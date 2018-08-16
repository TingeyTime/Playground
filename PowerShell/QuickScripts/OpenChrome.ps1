###PRELOAD###
  $Global:chrome = New-Object OpenQA.Selenium.Chrome.Chromedriver
  $Global:chromeWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($chrome, (New-TimeSpan -Seconds 3))
  $Global:conditions = [OpenQA.Selenium.Support.UI.ExpectedConditions]
  $Global:by = [OpenQA.Selenium.By]
  $Global:keys = [OpenQA.Selenium.Keys]
  $Global:chromeWait.until($conditions::ElementIsVisible($by::CssSelector("body"))) | Out-Null
###END PRELOAD###
