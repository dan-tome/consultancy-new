<#
.SYNOPSIS
  Put text on the web clipboard so another machine can paste it.

.DESCRIPTION
  Saves -Text (or -Path's contents) under -Code on clipboardify.com. On the other machine, open
  https://clipboardify.com/#<Code>: the page pulls the text into its box. The service deletes a clip when it is
  read, so this does not read it back. Text only, up to 10,000 characters. Never put a secret in it.

.EXAMPLE
  .\Send-Clip.ps1 -Text 'Get-Date'
  .\Send-Clip.ps1 -Path next.ps1 -Code NINETTE
#>
param(
  [string]$Text,
  [string]$Path,
  [string]$Code = 'NINETTE'
)
$ErrorActionPreference = 'Stop'
if ($Path) { $Text = Get-Content -Raw -LiteralPath $Path }
if (-not $Text) { throw 'Give -Text or -Path.' }
if ($Text.Length -gt 10000) { throw "Text is $($Text.Length) characters; the clipboard takes 10,000." }
$body = @{ code = $Code; text = $Text } | ConvertTo-Json -Compress
$null = Invoke-RestMethod -Method Post -Uri 'https://clipboardify.com/api.php?type=put' -ContentType 'application/json' -Body ([Text.Encoding]::UTF8.GetBytes($body))
Write-Host "Saved $($Text.Length) characters. Open https://clipboardify.com/#$Code"
