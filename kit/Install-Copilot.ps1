<#
.SYNOPSIS
  Make GitHub Copilot on this machine use the kit: link its skills and instructions into ~/.copilot.

.DESCRIPTION
  Creates directory junctions (no admin rights needed) so a `git pull` updates Copilot straight away:
    ~/.copilot/skills/<kit-skill>          -> kit/copilot/skills/<kit-skill>
    ~/.copilot/instructions/consultancy-kit -> kit/copilot/instructions
  Copilot in VS Code and the Copilot CLI both read these folders. Existing skills and instructions are left
  alone; a folder that is not a junction into the kit is never replaced. Junctions for kit skills that no
  longer exist are removed. It also turns off pushing from this clone, so nothing can go back by accident.
  Honours COPILOT_HOME if set. Run it again after a pull that adds skills; -Uninstall removes the links.

  With -Folder, it also writes a marked block into <Folder>\AGENTS.md telling Copilot, working in that folder,
  where the clone is and how to update it. Anything else in AGENTS.md is kept; re-running replaces only the
  block, and -Uninstall -Folder removes it.

.EXAMPLE
  .\kit\Install-Copilot.ps1 -Folder C:\Work\notebook
  .\kit\Install-Copilot.ps1 -Uninstall -Folder C:\Work\notebook
#>
param([switch]$Uninstall, [string]$Folder)
$ErrorActionPreference = 'Stop'

$repo = Split-Path $PSScriptRoot
$startMark = '<!-- consultancy-kit:start - written by Install-Copilot.ps1; re-run it rather than editing -->'
$endMark = '<!-- consultancy-kit:end -->'

function Set-FolderBlock([string]$Dir, [bool]$Remove) {
  $file = Join-Path $Dir 'AGENTS.md'
  $old = if (Test-Path -LiteralPath $file) { [IO.File]::ReadAllText($file) } else { '' }
  $pattern = '(?s)\r?\n?' + [regex]::Escape('<!-- consultancy-kit:start') + '.*?' + [regex]::Escape($endMark) + '\r?\n?'
  $rest = ([regex]::Replace($old, $pattern, "`n")).Trim()
  if ($Remove) {
    if ($rest) { [IO.File]::WriteAllText($file, "$rest`n", [Text.UTF8Encoding]::new($false)) }
    elseif (Test-Path -LiteralPath $file) { Remove-Item -LiteralPath $file }
    Write-Host "Removed the kit block from $file"
    return
  }
  $block = @"
$startMark
## Consultancy kit

A read-only clone of a personal, company-free repo is at ``$repo``. Its generic skills (``kit-*``) and
instructions are installed for Copilot from ``$repo\kit\copilot``.

- You may read the clone for reference: its ``README.md`` and ``kit/``. Never edit, commit or push in it, and
  never copy anything from this folder or this machine into it.
- When the user says "update the kit", run ``git -C "$repo" pull --ff-only``, then
  ``& "$repo\kit\Install-Copilot.ps1" -Folder "$Dir"``, and report what changed.
- To get a second opinion from outside the company, use the ``kit-ask-consultant`` skill.
- Company rules and this folder's other instructions come first.
$endMark
"@
  $new = if ($rest) { "$rest`n`n$block`n" } else { "$block`n" }
  $null = New-Item -ItemType Directory -Force -Path $Dir
  [IO.File]::WriteAllText($file, $new, [Text.UTF8Encoding]::new($false))
  Write-Host "Wrote the kit block to $file"
}

$kit = Join-Path $PSScriptRoot 'copilot'
$home_ = if ($env:COPILOT_HOME) { $env:COPILOT_HOME } else { Join-Path $HOME '.copilot' }
$skillsDir = Join-Path $home_ 'skills'
$instrLink = Join-Path $home_ 'instructions\consultancy-kit'

function Test-KitLink([string]$Path) {
  $i = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
  $i -and $i.LinkType -eq 'Junction' -and "$($i.Target)".StartsWith($kit, [StringComparison]::OrdinalIgnoreCase)
}
function Remove-KitLink([string]$Path) {
  # Deletes the junction itself, never what it points to.
  [IO.Directory]::Delete($Path, $false)
  Write-Host "Removed $Path"
}
function New-KitLink([string]$Path, [string]$Target) {
  if (Test-KitLink $Path) { return }
  if (Test-Path -LiteralPath $Path) { Write-Warning "Skipped ${Path}: something else is already there."; return }
  $null = New-Item -ItemType Directory -Force -Path (Split-Path $Path)
  $null = New-Item -ItemType Junction -Path $Path -Target $Target
  Write-Host "Linked $Path"
}

# Remove junctions into the kit whose skill is gone (or all of them on -Uninstall).
if (Test-Path -LiteralPath $skillsDir) {
  foreach ($d in Get-ChildItem -LiteralPath $skillsDir -Directory -Force) {
    if ((Test-KitLink $d.FullName) -and ($Uninstall -or -not (Test-Path -LiteralPath $d.Target))) { Remove-KitLink $d.FullName }
  }
}
if ($Uninstall) {
  if (Test-KitLink $instrLink) { Remove-KitLink $instrLink }
  if ($Folder) { Set-FolderBlock $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Folder) $true }
  return
}

foreach ($s in Get-ChildItem -LiteralPath (Join-Path $kit 'skills') -Directory) {
  New-KitLink (Join-Path $skillsDir $s.Name) $s.FullName
}
New-KitLink $instrLink (Join-Path $kit 'instructions')

if ($Folder) { Set-FolderBlock $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Folder) $false }

git -C $repo remote set-url --push origin 'no-push: this clone is read-only'
Write-Host 'Pushing from this clone is turned off. Update with: git pull'
