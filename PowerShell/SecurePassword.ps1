#Don't have to ever have your password anywhere as plain text
$PasswordType = Read-Host 'Password name'
$SetupCred = Get-Credential
$secureStringText = $SetupCred.Password | ConvertFrom-SecureString
Set-Content $("C:\Users\jwilli48\Desktop\Passwords\My"+ $PasswordType + "Password.txt") $secureStringText
