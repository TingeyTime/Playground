###PRELOAD###
  $chrome = New-Object OpenQA.Selenium.Chrome.Chromedriver
  $chromeWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($chrome, (New-TimeSpan -Seconds 5))
  $conditions = [OpenQA.Selenium.Support.UI.ExpectedConditions]
  $by = [OpenQA.Selenium.By]
  $keys = [OpenQA.Selenium.Keys]
  $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("body")))
###END PRELOAD###

Read-Host 'Read'
$filenames = $chrome.FindElementsByTagName('mat-card-title').text
$filenames | foreach {
  Copy-Item -Path 'C:\Users\jwilli48\Desktop\CAR - Accessibility Review Template.xlsx' -Destination $('C:\Users\jwilli48\Desktop\a11y_' + $_ + '.xlsx')
}
