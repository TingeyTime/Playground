<#
Summer 2018
Joshua Williamson

Functions to ease use of Selenium Webdriver to be used inside of Windows PowerShell for Chrome browser automations.
#>
[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\WebDriver.dll") | Out-Null
[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\WebDriver.Support.dll") | Out-Null
[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\Selenium.WebDriverBackedSelenium.dll") | Out-Null
[System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\ThoughtWorks.Selenium.Core.dll") | Out-Null

#Opens a browser controlled by Selenium Webdriver as well as initiating important variables used in Selenium
function Open-Chrome{
  param(
    [switch]$Headless
  )
  if($Headless){
    [OpenQA.Selenium.Chrome.ChromeOptions]$chrome_options = New-Object OpenQA.Selenium.Chrome.ChromeOptions
    $chrome_options.addArguments('headless','disable-gpu')
    $Global:chrome = New-Object OpenQA.Selenium.Chrome.Chromedriver($chrome_options)
  }else{
    $Global:chrome = New-Object OpenQA.Selenium.Chrome.Chromedriver
  }
  #Object that allows you to wait until a certain condition is filled
  $Global:chromeWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($chrome, (New-TimeSpan -Seconds 3))
  #The condition for the above WebDriverWait object
  $Global:conditions = [OpenQA.Selenium.Support.UI.ExpectedConditions]
  #Search conditions that can be input, mostly for the WebDriverWait object
  $Global:by = [OpenQA.Selenium.By]
  #If you need to send any keys that are not regular (such as an ENTER or SHIFT)
  $Global:keys = [OpenQA.Selenium.Keys]
  $Global:chromeWait.until($conditions::ElementIsVisible($by::CssSelector("body"))) | Out-Null
}

function Chrome-Status{
  $chrome.url
  $chrome.title
}
function Run-Javascript{
  param(
    [string]$script
  )
  $chrome.ExecuteScript($script)
}

function Element-SetAttribute{
    param(
        [string]$cssSelector,
        [string]$attribute,
        [string]$attributeValue,
        [int]$elementNumber = 0
        )
    Run-Javascript -script "document.querySelectorAll('$cssSelector')[$elementNumber].setAttribute('$attribute','$attributeValue')"
}

function Chrome-Find{
  param(
    [string]$selector,
    [switch]$byTagName,
    [switch]$byClassName,
    [switch]$byID,
    [switch]$byLinkText,
    [switch]$byPartialLinkText,
    [switch]$byCssSelector,
    [switch]$byXPath,
    [switch]$byName
  )
  if($byTagName){ $chrome.FindElementsByTagName($selector) }
  elseif($byClassName){ $chrome.FindElementsByClassName($selector) }
  elseif($byID){ $chrome.FindElementsById($selector) }
  elseif($byLinkText){ $chrome.FindElementsByLinkText($selector) }
  elseif($byPartialLinkText){ $chrome.FindElementsByPartialLinkText($selector) }
  elseif($byCssSelector){ $chrome.FindElementsByCssSelector($selector) }
  elseif($byXPath){ $chrome.FindElementsByXPath($selector) }
  elseif($byName){ $chrome.FindElementsByName($selector) }
  else{ Write-Host "Please choose the type of selector you are wanting to use." }
}

function Chrome-WaitUntilElementIsVisible{
    param(
      [string]$selector,
      [switch]$byTagName,
      [switch]$byClassName,
      [switch]$byID,
      [switch]$byLinkText,
      [switch]$byPartialLinkText,
      [switch]$byCssSelector,
      [switch]$byXPath,
      [switch]$byName
    )
    if($byTagName){ $chromeWait.Until($conditions::ElementIsVisible($by::TagName($selector))) }
    elseif($byClassName){ $chromeWait.Until($conditions::ElementIsVisible($by::ClassName($selector))) }
    elseif($byID){ $chromeWait.Until($conditions::ElementIsVisible($by::Id($selector))) }
    elseif($byLinkText){ $chromeWait.Until($conditions::ElementIsVisible($by::LinkText($selector))) }
    elseif($byPartialLinkText){ $chromeWait.Until($conditions::ElementIsVisible($by::PartialLinkText($selector))) }
    elseif($byCssSelector){ $chromeWait.Until($conditions::ElementIsVisible($by::CssSelector($selector))) }
    elseif($byXPath){ $chromeWait.Until($conditions::ElementIsVisible($by::XPath($selector))) }
    elseif($byName){ $chromeWait.Until($conditions::ElementIsVisible($by::Name($selector))) }
    else{ Write-Host "Please choose the type of selector you are wanting to use." }
}

function Chrome-Back{
  $chrome.Navigate().Back()
}

function Chrome-Forward{
    $chrome.Navigate().Forward()
}

function Chrome-Refresh{
  $chrome.Navigate().Refresh()
}

function Navigate-To{
  param{
    [string]$url
  }
  $chrome.url = $url
}

function Take-Screenshot{
  param{
    [string]$fileName,
    [switch]$bmp,
    [switch]$Jpeg,
    [switch]$Gif,
    [switch]$Png
  }
  $type = "Png"
  if($bmp){ $type = "bmp"}
  elseif($Jpeg){ $type = "Jpeg"}
  elseif($Gif){ $type = "gif" }
  elseif($Png){ $type = "Png" }
  else{
    Write-Verbose "Default type choosen, PNG file"
  }
  $chrome.GetScreenshot().SaveAsFile("C:\Users\jwilli48\Desktop\$fileName", [OpenQA.Selenium.ScreenshotImageFormat]::$type)
}

function Switch-Tab{
  param(
    [int]$tabNumber = 0
  )
  $chrome.SwitchTo().Window($chrome.WindowHandles[$tabNumber]) | Out-Null
}

function Switch-Frame{
  param(
    [string]$frame
  )
  $chrome.SwitchTo().frame($frame)
}

function Close-Chrome{
  $chrome.close()
}
