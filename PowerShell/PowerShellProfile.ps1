#Change Shell title
function Custom-Console {
  $hosttime = (Get-ChildItem -Path $pshome\PowerShell.exe).CreationTime
  $hostversion="$($Host.Version.Major)`.$($Host.Version.Minor)"
  $Host.UI.RawUI.WindowTitle = $("PowerShell " + $hostversion +" " + $hosttime)
  Clear-Host
}
Custom-Console

#Change prompt
function Prompt{
	$width = ($Host.UI.RawUI.WindowSize.Width - 2 - $(Get-Location).ToString().Length)
	$hr = New-Object System.String @('-',$width)
	Write-Host -ForegroundColor Red $(Get-Location) $hr
	Write-Host '[' -NoNewline
	Write-Host (Get-Date -Format 'T') -ForegroundColor Green -NoNewline
	Write-Host ']:' -NoNewline
	Write-Host (Split-Path (Get-Location) -Leaf) -NoNewline
	return "$ "
}
"PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineOption -HistoryNoDuplicates
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

$host.privatedata.ProgressBackgroundColor = $Host.UI.RawUI.BackgroundColor
$host.privatedata.ProgressForegroundColor = "Green"

# LS.MSH
# Colorized LS function replacement
# /\/\o\/\/ 2006
# http://mow001.blogspot.com
function LL
{
    param ($dir = ".", $all = $false)

    $origFg = $host.ui.rawui.foregroundColor
    if ( $all ) { $toList = ls -force $dir }
    else { $toList = ls $dir }

    foreach ($Item in $toList)
    {
        Switch ($Item.Extension)
        {
			".Exe" {$host.ui.rawui.foregroundColor = "Yellow"}
			".cmd" {$host.ui.rawui.foregroundColor = "Red"}
			".msh" {$host.ui.rawui.foregroundColor = "Red"}
			".vbs" {$host.ui.rawui.foregroundColor = "Red"}
			".html" {$host.ui.rawui.foregroundColor = "Cyan"}
			".docx" {$host.ui.rawui.foregroundColor = "Magenta"}
			".pdf" {$host.ui.rawui.foregroundColor = "Yellow"}
			".xlsx" {$host.ui.rawui.foregroundColor = "Gray"}
			".ps1" {$host.ui.rawui.foregroundColor = "Blue"}
            Default {$host.ui.rawui.foregroundColor = $origFg}
        }
        if ($item.Mode.StartsWith("d")) {$host.ui.rawui.foregroundColor = "Green"}
        $item
    }
    $host.ui.rawui.foregroundColor = $origFg
}

function lla
{
    param ( $dir=".")
    ll $dir $true
}

function cdl{
    param(
        [string]$Directory
        )
    cd $Directory
    ll
}

function ..{
	cdl ..
}

function h10 {
	(Get-History -Count 10).CommandLine
}

function h50 {
	(Get-History -Count 50).CommandLine
}

###Personal Scripts
function Run-Script{
	param(
		[string]$ScriptName
	)
	.$('M:\DESIGNER\Content EditorsELTA\Accessibility Assistants\AA team folders\Josh\PowerShell\' + $ScriptName)
}

function List-Scripts{
	Get-ChildItem 'M:\DESIGNER\Content EditorsELTA\Accessibility Assistants\AA team folders\Josh\PowerShell' *.ps1 -rec
}

function Find-Replace{
	run FindReplace.ps1
}

function BackUp-Direcotry{
	run Back_Up.ps1
}

function Make-LinkList{
	run LinkList
}

function Secure-Password{
	run SecurePassword.ps1
}

function Clear-GmailInbox{
	run Web\clearGmailInbox.ps1
}

function ArrayToTable{
    param(
    [string]$aliasList,
    [string]$commandList
    )
    $obj = New-Object PSObject
    $obj | Add-Member NoteProperty Alias($aliasList)
    $obj | Add-Member NoteProperty Command($commandList)
    Write-Output $obj
    }

function List-CustomAlias{
    $aliasList = @()
    $commandList = @()
    $alias = Get-Content $PROFILE | Select-String -Pattern 'Set-Alias [A-Za-z].*'
    $alias | %{
        $aliasList += $_.toString().split()[1]
        $commandList += $_.toString().split()[2]
        }
    for($i = 0; $i -lt $aliasList.length; $i++){ ArrayToTable $aliasList[$i] $commandList[$i]}
}

function List-CustomCommands{
    Get-Content $PROFILE | Select-String -Pattern 'functio[a-z] (.*?){' | % { Write-Host $_.Matches.Groups[1].Value -ForegroundColor Yellow}
}
#Get-Alias | ? {$_.HelpUri -eq ""}     <-- this will also get all custom alias
function la {
    ($AliasList = List-CustomAlias)
    $AliasList | Write-PSObject -ColoredColumns "Alias", "Command" -ColumnForeColor Gray, Green -InjectRowsSeparator -RowsSeparator "_" -RowsSeparatorForeColor Cyan
}

#Web navigation scripts
function OpenChrome{
    run QuickScripts\OpenChrome.ps1
}

function Login{
    run QuickScripts\BYULogin.ps1
}

function GoTo-Canvas{
    param(
        [string]$courseName
        )
    if($chrome -eq $NULL){
        OpenChrome
    }
    run QuickScripts\GoToCanvas.ps1
}

function GoTo-Buzz{
    param(
        [string]$courseName
        )
    if($chrome -eq $NULL){
        OpenChrome
    }
    run QuickScripts\GoToBuzz.ps1
}

function replaceAlt {
    if($chrome.url -match 'instruct'){
        run QuickScripts\canvasReplaceAlt.ps1
    }elseif($chrome.url -match 'agilix'){
        run QuickScripts\buzzReplaceAlt.ps1
    }
}

#Running Javascript on Canvas/Buzz
function ListJS{
    Get-ChildItem 'M:\DESIGNER\Content EditorsELTA\Accessibility Assistants\AA team folders\Josh\JavaScript\Scripts\' *.js -rec
}
function Get-JavaScript{
    param(
        [string]$ScriptName
        )
    return $script = Get-Content -Path $("M:\DESIGNER\Content EditorsELTA\Accessibility Assistants\AA team folders\Josh\JavaScript\Scripts\" + $ScriptName) -raw
}

function Buzz-JavaScript{
    run QuickScripts\buzzJS.ps1
}

function Canvas-JavaScript{
    run QuickScripts\canvasJS.ps1
}

function RunJS{
    param(
        [string]$scriptName,
        [bool]$CustomScript = $false,
        [string]$script
        )
    if($CustomScript){}
    else{
        $script = getJS $scriptName
    }
    if($chrome.url -match 'instruct'){
        cjs $script
    }elseif($chrome.url -match 'agilix'){
        bjs $script
    }else{
        $chrome.ExecuteScript($script)
    }
}

function Set-ElementAttribute{
    param(
        [string]$cssSelector,
        [string]$attribute,
        [string]$attributeValue,
        [int]$elementNumber = 0
        )
    RunJS -CustomScript $true -script "document.querySelectorAll('$cssSelector')[$elementNumber].setAttribute('$attribute','$attributeValue')"
}

function AltText{
    RunJS PopAltText.js
}

function ShowAltText{
    RunJS ShowAltText.js
}

function MathAltText{
    RunJS MathAltText.js
}

<#function Headings{
    runJS ShowHeadings.js
}#>

function Headings{
    RunJS h1.js
    RunJS h2.js
    RunJS h3.js
    RunJS h4.js
    RunJS h5.js
    RunJS h6.js
}

function tota11y{
    RunJS tota11y.js
}

function Landmarks{
    RunJS ShowLandMarks.js
}

function Forms{
    RunJS ShowForms.js
}

function ComplexTables{
    RunJS ComplexTables.js
}

function IframeTitle{
    RunJS IframeTitle.js
}

function RemoveAltBar{
    RunJS RemoveAltBar.js
}

function RemoveHeaders{
    RunJS RemoveHeaders.js
}

function removeAccessibilityHelpers{
    RunJS RemoveAccessibilityHelpers.js
}

function Basic-Accessibility{
    IframeTitle
    ShowAltText
    Headings
}

#This is still a little buggy if you want to remove then re-add the accessibility helpers.
#If you remove the accessibility stuff, then re-add it, everything works besides the headers and you have to remove it again then re-add them a 2nd time in order for them to actually show up(in canvas)
function Remove-AccessibilityHelpers{
    RemoveAltBar
    removeAccessibilityHelpers
    if($chrome.url -match 'instruct'){
        RemoveHeaders
    }
}

function Chrome-Find{
    param(
        [string]$cssSelector
        )
    run QuickScripts\ChromeFind.ps1
}

function Chrome-Wait{
    param(
        [string]$cssSelector
        )
    run QuickScripts\ChromeWait.ps1
}

function Chrome-Refresh{
    run QuickScripts\ChromeRefresh.ps1
}

#ALIAS
Set-Alias sa Set-ElementAttribute
Set-Alias ra Remove-AccessibilityHelpers
Set-Alias ba Basic-Accessibility
Set-Alias refresh Chrome-Refresh
Set-Alias cf Chrome-Find
Set-Alias cw Chrome-Wait
Set-Alias cjs Canvas-JavaScript
Set-Alias bjs Buzz-JavaScript
Set-Alias getJS Get-JavaScript
Set-Alias rAlt replaceAlt
Set-Alias buzz GoTo-Buzz
Set-Alias canvas GoTo-Canvas
Set-Alias open OpenChrome
Set-Alias clearGmailInbox Clear-GmailInbox
Set-Alias spwd Secure-Password
Set-Alias lList Make-LinkList
Set-Alias fr Find-Replace
Set-Alias list List-Scripts
Set-Alias run Run-Script

#Global VARIABLES
$PsScriptDirectory = 'M:\DESIGNER\Content EditorsELTA\Accessibility Assistants\AA team folders\Josh\PowerShell\'

#My BYU credentials
$username = "jwilli48"
$password = Get-Content "C:\Users\jwilli48\Desktop\Passwords\MyByuPassword.txt"
$securePwd = $password | ConvertTo-SecureString
$BYUcredentials = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePwd
#Google
$username = "jlwilliamson95@gmail.com"
$password = Get-Content "C:\Users\jwilli48\Desktop\Passwords\MyGooglePassword.txt"
$securePwd = $password | ConvertTo-SecureString
$GoogleCredentials = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePwd

#Load common .dll that I use
  [System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\WebDriver.dll") | Out-Null
  [System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\WebDriver.Support.dll") | Out-Null
  [System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\Selenium.WebDriverBackedSelenium.dll") | Out-Null
  [System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Downloads\selenium-dotnet-3.1.0\net40\ThoughtWorks.Selenium.Core.dll") | Out-Null
  [System.Reflection.Assembly]::LoadFrom("C:\Users\jwilli48\Desktop\itextsharp.5.5.13\lib\itextsharp.dll") | Out-Null

run GetWeather.ps1
