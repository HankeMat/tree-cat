$Output = "output.txt"
Set-Content -Path $Output -Value ""

$ExcludeDirs = @(

)

$ExcludeFiles = @(

)

$AllowedExtensions = @(

)

$SkippedDirs = @{}

function IsExcludedDir($path) {
    foreach ($d in $ExcludeDirs) {
        if ($path -like "*\$d\*") {
            return $d
        }
    }
    return $null
}

function IsExcludedFile($path) {
    $basename = Split-Path $path -Leaf
    foreach ($f in $ExcludeFiles) {
        if ($basename -like $f) {
            return $true
        }
    }
    return $false
}

function HasAllowedExtension($path) {
    foreach ($ext in $AllowedExtensions) {
        if ($path.EndsWith($ext)) { return $true }
    }
    return $false
}

function ProcessFile($file) {
    $full = $file.FullName

    $excludedDir = IsExcludedDir $full
    if ($excludedDir) {
        if (-not $SkippedDirs.ContainsKey($excludedDir)) {
            Add-Content -Path $Output -Value "[SKIP_DIR] .\$excludedDir"
            $SkippedDirs[$excludedDir] = $true
        }
        return
    }

    if (IsExcludedFile $full) {
        Add-Content -Path $Output -Value "[SKIP_FILE] $full"
        return
    }

    if (HasAllowedExtension $full) {
        Add-Content -Path $Output -Value "===== $full ====="
        Add-Content -Path $Output -Value (Get-Content $full)
        Add-Content -Path $Output -Value "`n"
    }
    else {
        Add-Content -Path $Output -Value "[NO_CAT] $full"
    }
}

Get-ChildItem -Recurse -File | ForEach-Object {
    ProcessFile $_
}

Write-Host "Done -> saved in $Output"
