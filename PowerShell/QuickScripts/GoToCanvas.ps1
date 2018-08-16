#Navigate to Canvas
$chrome.url = "https://byu.instructure.com/"
if($courseName -ne "" -and $courseName -ne $NULL){
  $chrome.FindElementsByTagName('div') | Where-Object {$_.getAttribute('title') -match $courseName} | Select-Object -index 0 | % {$_.click()}
}
