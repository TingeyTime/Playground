###PRELOAD###
  [System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\WebDriver.dll")
  [System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\WebDriver.Support.dll")
  [System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\Selenium.WebDriverBackedSelenium.dll")
  [System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\ThoughtWorks.Selenium.Core.dll")
  $chrome = New-Object OpenQA.Selenium.Chrome.Chromedriver
  $chromeWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($chrome, (New-TimeSpan -Seconds 5))
  $conditions = [OpenQA.Selenium.Support.UI.ExpectedConditions]
  $by = [OpenQA.Selenium.By]
  $keys = [OpenQA.Selenium.Keys]
  $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("body")))
###END PRELOAD###

$videoURLS = "https://d32xj74kbqkoqn.cloudfront.net/videos/guide/video_file/464/001_tools.mp4"
$chrome.url = "https://acethinker.com/online-downloader"

$chromeWait.until($conditions::ElementIsVisible($by::CssSelector("input[placeholder*='Paste the video'"))).sendKeys($videoURLS)
$chromeWait.until($conditions::ElementIsVisible($by::CssSelector("button"))).click()

$downloadButton = $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("a[class*='download']")))
#Right-clicks download button
$chrome.Mouse.ContextClick($downloadButton.Coordinates)
$actions = New-Object  OpenQA.Selenium.Interactions.Actions($chrome)
$actions.MoveToElement($downloadButton).ContextClick().build().Perform()
[System.Windows.Forms.SendKeys]::SendWait("{DOWN}");

$chromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions

#I found out powershell can just download files by itself... idk why I tried to force Selenium into it.....
#Now I just need to create a list of links and then it will be simple to download them all.
$url ="https://d32xj74kbqkoqn.cloudfront.net/videos/guide/video_file/464/001_tools.mp4"
$fileName = $url.split("/")[-1]
(New-Object System.Net.WebClient).DownloadFile($url,$fileName)
