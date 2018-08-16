#Navigates to URL
$chrome.url = "https://byumastercourses.next.agilixbuzz.com/teacher/home/courses"
if($courseName -ne "" -and $courseName -ne $NULL){
  $chromeWait.Until($conditions::ElementIsVisible($by::CssSelector('mat-card-title'))) | Out-Null
  $chrome.FindElementsByTagName('mat-card-title') | Where-Object {$_.text -match $courseName} | % {$_.click()}
}
