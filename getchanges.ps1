&git --version | Out-Null
if (-not $?) {
	throw "Git does not exist"
}

&git update-index -q --refresh | Out-Null
$Changed = (&git diff-index --name-only HEAD --).Length -gt 0

if ($Changed) {
	throw "Uncommitted changes detected, please commit, stash or discard your changes"
}

$BaseDirectory = Split-Path $MyInvocation.MyCommand.Path
$OutputDirectory = $Home

$ExistingFiles = @()
$ExistingFiles += Get-ChildItem (Join-Path $BaseDirectory "files")
$ExistingFiles += Get-ChildItem (Join-Path $BaseDirectory (Join-Path "private" "files"))

$ExistingFiles | % {
	$FileName = $_.Name
	$ExistingFile = $_.FullName
	$OutputFile = Join-Path $OutputDirectory $FileName
	if (Test-Path $OutputFile) {
		Write-Host ("Copying [{0}] to [{1}]" -f @($OutputFile, $ExistingFile))
		Remove-Item -Path $ExistingFile -Recurse -Force
		Copy-Item -Path $OutputFile -Destination $ExistingFile -Recurse
	} else {
		Write-Host ("Skipping updating [{0}] as [{1}] does not exist" -f @($FileName, $OutputFile))
	}
}

$VundleDirectory = Join-Path $BaseDirectory (Join-Path "files" (Join-Path ".vim" "bundle"))
if (Test-Path $VundleDirectory) {
	Write-Host ("Deleting [{0}]" -f @($VundleDirectory))
	Remove-Item -Path $VundleDirectory -Recurse -Force
}

$IrssiFiles = Get-ChildItem (Join-Path $BaseDirectory (Join-Path "files" ".irssi"))
$IrssiFiles | % {
	$File = $_.FullName
	Write-Host ("Fixing line endings of [{0}]" -f @($File))
	$Content = Get-Content $File
	$Content | Set-Content $File
}

$RegKeyMaps = @{
	"ConEmu" = "HKEY_CURRENT_USER\Software\ConEmu\.Vanilla"
}

$RegKeyMaps.Keys | % {
	$Name = $_
	$File = Join-Path $BaseDirectory (Join-Path "reg_keys" "$Name.Reg")
	$KeyPath = $RegKeyMaps[$_]
	if (Test-Path (Join-Path Registry:: $KeyPath)) {
		Write-Host ("Exporting [{0}] to [{1}]" -f @($KeyPath, $File))
		&regedit @('/E', $File, $KeyPath)
	} else {
		Write-Host ("Skipping updating [{0}] as [{1}] does not exist" -f @($File, $KeyPath))
	}
}
