$chrome.ExecuteScript("document.querySelector(`"span[style*='font-size: 11pt;']`").setAttribute('style','')")
$chrome.ExecuteScript("document.querySelector(`"span[style*='font-size: 11pt;']`").setAttribute('style','')")
$chrome.ExecuteScript("document.querySelector(`"span[style*='font-size: 14pt;']`").setAttribute('style','')")
$chrome.ExecuteScript("document.querySelector(`"span[class*='Head1']`").setAttribute('class','')")
$chrome.ExecuteScript("var strong = document.querySelector(`"strong`");
  var h1tag = document.createElement('h1');
  h1tag.innerHTML = strong.innerHTML;
  strong.parentNode.replaceChild(h1tag,strong);")






$chrome.ExecuteScript("document.querySelector(`"span[style*='font-size: 11pt;']`").remove()")
$chrome.ExecuteScript("document.querySelector(`"span[style*='font-size: 11pt;']`").remove()")
$chrome.ExecuteScript("document.querySelector(`"span[style*='font-size: 14pt;']`").remove()")
$chrome.ExecuteScript("document.querySelector(`"span[class*='Head1']`").remove()")
$chrome.ExecuteScript("document.querySelector(`"strong`").remove()")
