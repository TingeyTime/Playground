try{
  $chrome.switchTo().frame(3) | Out-Null
  $chrome.switchTo().frame('scoframe') | Out-Null
  $chrome.ExecuteScript($script)
  $chrome.SwitchTo().Window($chrome.CurrentWindowHandle) | Out-Null
}catch{
  $chrome.SwitchTo().Window($chrome.CurrentWindowHandle) | Out-Null
  $chrome.ExecuteScript($script)
}
