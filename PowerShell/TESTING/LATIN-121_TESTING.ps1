#The REGEX works in Atom pretty well, but there are to many variations to make it stable enough for a script
#Extra headers for the table should be <h2> tags above table
(<table>\r\n) <tr>\r\n <td([^>]*)><h1([^>]*)>(.*?)</h1></td>\r\n </tr>
<h2$3>$4</h2>\r\n$1

<tr>\r\n<td colspan="4"><h1([^>])>(.*?)</h1></td>\r\n</tr>
<caption$1><strong>$2</strong></caption>

<td><h2>([A-Z][a-z]*)</h2></td>
<th scope="col">$1</th>

<td><h2>(.*?)</h2></td>
<th>$1</th>

(</tr>\r\n)(<tr>\r\n<th scope)
$1</table>\r\n<table>\r\n<caption></caption>\r\n$2

(<caption>.*?</caption>)([.\s\S]*?<th scope="col">Case[.\s\S]*?)(<tr>\r\n<th scope="col">Case)
$1$2$1\r\n$3

(<caption>.*?</caption>\r\n)<caption>.*?</caption>
$1
#This should fix all of their inaccessible tables. Still making sure it doesn't mess it up though
$file = Read-Host 'File name'
$File_Content = (Get-Content -Encoding UTF8 -Path $file -raw)
$File_Content = $File_Content -replace '<tr>\r\n<td colspan="4"><h1([^>])>(.*?)</h1></td>\r\n</tr>' , '<caption $2><strong>$3</strong></caption>'
Write-Host "Changed headings to be captions"
$File_Content = $File_Content -replace '<td><h2>([A-Z][a-z]*)</h2></td>' , '<th scope="col">$1</th>'
Write-Host "Changed headers inside of the table to be native table headers"
$File_Content = $File_Content -replace '<td><h2>(.*?)</h2></td>' , '<th>$1</th>'
Write-Host "Changed row headers to be native headers"
$File_Content = $File_Content -replace '(</tr>\r\n)(<tr>\r\n<th scope)' , '$1</table><table>$2'
Write-Host "Split the tables up to be easier to navigate"
$File_Content = $File_Content -replace '(<caption>.*?</caption>)([.\s\S]*?<th scope="col">Case[.\s\S]*?)(<tr>\r\n<th scope="col">Case)' , '$1$2$1$3'
Write-Host "Copying correct captions to the newly made split tables"
$File_Content = $File_Content -replace '(<caption>.*?</caption>\r\n)<caption>.*?</caption>', '$1'
Write-host 'Removing extra captions'
$File_Content | Set-Content -Encoding UTF8 -Path $file;

<tr>
<td colspan="\d"><h1><i>domus </i>: home, house (&ldquo;domicile,&rdquo; &ldquo;domestic,&rdquo; &ldquo;major domo&rdquo;)</h1></td>
</tr>



#New ones
<tr>\r\n.*?<td([^>]*)>\r\n.*?<h1([^>]*)>(.*?)\r\n.*?</h1></td>\r\n.*?</tr>
<caption $1 $2><strong>$3</strong></caption>

<td>\r\n.*?<h2>([A-Z][A-Z a-z]*)</h2></td>
<th>$1</th>

<td>\r\n.*?<h2>(<em>.*?)</h2>.*?</td>
<td>$1</td>

<tr>\r\n.*?<td([^>]*)>\r\n.*?<h1([^>]*)>(.*?)\r\n.*?</tr>
<caption $1 $2><strong>$3</strong></caption>

<tr>\r\n<td[^>]*><h1>(.*?)</h1></td>\r\n</tr>
