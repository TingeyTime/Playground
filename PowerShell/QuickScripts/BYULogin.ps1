if($chrome.url -match 'instructure'){
  $chromeWait.Until($conditions::ElementIsVisible($by::ID('netid'))) | Out-Null
  $chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('id') -match 'netid' } | % {$_.sendKeys($BYUcredentials.username)}
  $chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('id') -match 'password' } | % {$_.sendKeys($BYUcredentials.GetNetworkCredential().password)}
  $chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('value') -match 'Sign In' } | Select-Object -index 0 | % {$_.submit()}
}else{
  $chrome.SwitchTo().Window($chrome.WindowHandles[1]) | Out-Null
  $chromeWait.Until($conditions::ElementIsVisible($by::ID('netid')))
  $chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('id') -match 'netid' } | % {$_.sendKeys($BYUcredentials.username)}
  $chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('id') -match 'password' } | % {$_.sendKeys($BYUcredentials.GetNetworkCredential().password)}
  $chrome.FindElementsByTagName('input') | Where-Object { $_.getAttribute('value') -match 'Sign In' } | Select-Object -index 0 | % {$_.submit()}
  $chrome.SwitchTo().Window($chrome.WindowHandles[0]) | Out-Null
}
