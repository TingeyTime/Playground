$loopAgain = 'No'
do{
  $numberOfModules = $chrome.FindElementsByTagName('button') | Where-Object {$_.getAttribute('class') -match '.*glyphicon-option.*'} | measure
  for($i = [int]'0'; $i -lt $($numberOfModules.count - 1); $i++){
    try{
      #Module option menu
      $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("button[class*='glyphicon-option']"))) | Out-Null
      ($chrome.FindElementsByTagName('button') | Where-Object {$_.getAttribute('class') -match '.*glyphicon-option.*'} | Select-Object -index $i).click()
      #Button to begin editing
      $chromeWait.until($conditions::ElementIsVisible($by::LinkText('Edit'))).click()
      #The image
      $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("img[class*='fr-draggable']"))) | Out-Null
      #If the image has a title, remove remove it.
      if($chrome.FindElementsByCssSelector("img[class*='fr-draggable']").getAttribute('title') -ne ''){
        $chrome.ExecuteScript("document.querySelector(`"img[class*='fr-draggable']`").setAttribute('title','')")
      }
      #Enter image options
      $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("img[class*='fr-draggable']"))).click()
      #Option to edit alt text
      $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("button[id*='imageAlt']"))).click()
      #Clears and saves blank alt text
      $chromeWait.until($conditions::ElementIsVisible($by::CssSelector("input[placeholder*='Alternative']"))).clear()
      #Update and save
      ($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Update'}).click()
      ($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Save'}).click()
      Write-Progress -Activity "Removing titles and alt text" -Status "Progress:" -PercentComplete ($i/$numberofModules.count*100)
    }
  catch{
      #If a timeout error happens above(meaning there is not img with alt text that can be edited) it will just save the page and restart the loop on the next module
      Write-Host 'Nothing Found'
      ($chrome.FindElementsByTagName('button') | Where-Object {$_.text -match 'Save'}).click()
      continue
    }
  }
  $loopAgain = Read-Host "Do you want to loop again? (Y/N)"
}while($loopAgain -match 'Y')
