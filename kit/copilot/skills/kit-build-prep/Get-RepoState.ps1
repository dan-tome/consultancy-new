<#
.SYNOPSIS
  Show whether each git checkout is current with its upstream, before a build. Changes no files.

.DESCRIPTION
  For each path: fetches from the upstream's remote (unless -NoFetch), then prints one line with the
  branch, commit, local changes, commits ahead/behind the upstream, and a State:

    UP-TO-DATE    clean, on a branch, same as upstream.
    BEHIND        clean, on a branch, upstream has newer commits; `git pull --ff-only` would refresh it.
    AHEAD         clean, has local commits the upstream lacks; nothing to refresh.
    DIRTY         uncommitted changes. Don't refresh; ask the user.
    DIVERGED      both ahead and behind. Don't refresh; ask the user.
    DETACHED      not on a branch. Don't refresh; ask the user.
    NO-UPSTREAM   branch has no upstream. Ask the user.
    FETCH-FAILED  fetch failed (network, credentials); ahead/behind may be stale. Ask the user.
    NOT-A-REPO    path missing or not a git checkout.

  Fetching updates only remote-tracking refs, never the working tree or local branches.
  Works in Windows PowerShell 5.1 and PowerShell 7.

.EXAMPLE
  & .\Get-RepoState.ps1 -Path C:\src\app, C:\src\lib
  & .\Get-RepoState.ps1 -Path C:\src\app -NoFetch
#>
param(
  [Parameter(Mandatory = $true)][string[]]$Path,
  [switch]$NoFetch
)
$ErrorActionPreference = 'Continue'
# Called via `powershell -File`, "a,b" arrives as one string: split it unless it is itself a real path.
$Path = @(foreach ($p in $Path) { if ((Test-Path -LiteralPath $p) -or $p -notmatch ',') { $p } else { $p -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ } } })

function Invoke-Git([string]$Dir, [string[]]$GitArgs) {
  $out = & git -C $Dir @GitArgs 2>$null
  [pscustomobject]@{ Ok = ($LASTEXITCODE -eq 0); Out = @($out) }
}

$rows = foreach ($p in $Path) {
  $row = [ordered]@{ Repo = $p; State = ''; Branch = ''; Commit = ''; Changes = ''; Ahead = ''; Behind = '' }
  $inside = Invoke-Git $p @('rev-parse', '--is-inside-work-tree')
  if (-not (Test-Path -LiteralPath $p) -or -not $inside.Ok -or $inside.Out[0] -ne 'true') {
    $row.State = 'NOT-A-REPO'; [pscustomobject]$row; continue
  }
  $row.Commit = (Invoke-Git $p @('rev-parse', '--short', 'HEAD')).Out[0]
  $row.Changes = @((Invoke-Git $p @('status', '--porcelain')).Out | Where-Object { $_ }).Count
  $br = Invoke-Git $p @('symbolic-ref', '--short', '-q', 'HEAD')
  if (-not $br.Ok) { $row.Branch = '(detached)'; $row.State = 'DETACHED'; [pscustomobject]$row; continue }
  $row.Branch = $br.Out[0]
  $up = Invoke-Git $p @('rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{u}')
  if (-not $up.Ok) { $row.State = 'NO-UPSTREAM'; [pscustomobject]$row; continue }
  $fetchFailed = $false
  if (-not $NoFetch) {
    $remote = (Invoke-Git $p @('config', "branch.$($row.Branch).remote")).Out[0]
    if (-not $remote) { $remote = 'origin' }
    $fetchFailed = -not (Invoke-Git $p @('fetch', '--quiet', $remote)).Ok
  }
  $counts = (Invoke-Git $p @('rev-list', '--left-right', '--count', 'HEAD...@{u}')).Out[0] -split '\s+'
  $row.Ahead = [int]$counts[0]; $row.Behind = [int]$counts[1]
  $row.State =
    if ($fetchFailed) { 'FETCH-FAILED' }
    elseif ($row.Changes -gt 0) { 'DIRTY' }
    elseif ($row.Ahead -gt 0 -and $row.Behind -gt 0) { 'DIVERGED' }
    elseif ($row.Behind -gt 0) { 'BEHIND' }
    elseif ($row.Ahead -gt 0) { 'AHEAD' }
    else { 'UP-TO-DATE' }
  [pscustomobject]$row
}
$rows | Format-Table -AutoSize | Out-String -Width 4096 | Write-Output
if ($NoFetch) { Write-Output 'Not fetched (-NoFetch): ahead/behind is as of the last fetch.' }
