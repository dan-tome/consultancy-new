<#
.SYNOPSIS
  Put text on the web clipboard so another machine can paste it.

.DESCRIPTION
  Saves -Text (or -Path's contents) under -Code on clipboardify.com. On the other machine, open
  https://clipboardify.com/#<Code>: the page pulls the text into its box. The service deletes a clip when it is
  read, so this does not read it back. Sending replaces whatever is waiting under the code. Text only, up to
  10,000 characters. Never put a secret in it.

  -Screen refuses to send if the text looks like it holds private material: email addresses, IP addresses,
  user or network paths, internal host names, URLs other than github.com and clipboardify.com, secrets and
  connection strings, or long random-looking strings. It lists what it found. It is a backstop, not a
  replacement for reading the text line by line.

.EXAMPLE
  .\Send-Clip.ps1 -Text 'Get-Date'
  .\Send-Clip.ps1 -Path request.txt -Screen
#>
param(
  [string]$Text,
  [string]$Path,
  [string]$Code = 'NINETTE',
  [switch]$Screen
)
$ErrorActionPreference = 'Stop'
if ($Path) { $Text = Get-Content -Raw -LiteralPath $Path }
if (-not $Text) { throw 'Give -Text or -Path.' }
if ($Text.Length -gt 10000) { throw "Text is $($Text.Length) characters; the clipboard takes 10,000." }

if ($Screen) {
  $checks = [ordered]@{
    'email address'          = '[\w.+-]+@[\w-]+\.[\w.-]+'
    'IP address'             = '\b(?:\d{1,3}\.){3}\d{1,3}\b'
    'user or network path'   = '(?i)[a-z]:\\users\\|\\\\[\w.-]+\\|/home/\w|/Users/\w'
    'internal host name'     = '(?i)\b[\w-]+(?:\.[\w-]+)*\.(?:local|corp|internal|intranet|lan|ad)\b'
    'URL'                    = '(?i)https?://(?!(?:www\.)?(?:github\.com|clipboardify\.com)\b)\S+'
    'secret or key'          = '(?i)\b(?:password|passwd|pwd|secret|token|api[_-]?key|client[_-]?secret|bearer)\b\s*[:=]\s*\S+|\bbearer\s+(?:(?=\S*\d)\S{3,}|\S{20,})|-----BEGIN [A-Z ]*PRIVATE KEY-----'
    'connection string'      = '(?i)\b(?:server|data source|accountkey|sharedaccesskey|user id|uid)\s*='
    'long random string'     = '\b[A-Za-z0-9+/_-]{32,}={0,2}'
  }
  $found = foreach ($k in $checks.Keys) {
    foreach ($m in [regex]::Matches($Text, $checks[$k])) { "  ${k}: $($m.Value)" }
  }
  if ($found) {
    Write-Host 'Not sent. The text looks like it holds private material:'
    $found | Select-Object -Unique | ForEach-Object { Write-Host $_ }
    Write-Host 'Rewrite those parts in generic terms and try again.'
    exit 2
  }
}

$body = @{ code = $Code; text = $Text } | ConvertTo-Json -Compress
$null = Invoke-RestMethod -Method Post -Uri 'https://clipboardify.com/api.php?type=put' -ContentType 'application/json' -Body ([Text.Encoding]::UTF8.GetBytes($body))
Write-Host "Saved $($Text.Length) characters. Open https://clipboardify.com/#$Code"
