# Scans the Images folder and regenerates manifest.js
# Run this any time you add new image folders

$scriptDir  = Split-Path -Parent $MyInvocation.MyCommand.Path
$imagesPath = Join-Path $scriptDir "Images"
$outputPath = Join-Path $scriptDir "manifest.js"

if (-not (Test-Path $imagesPath)) {
    Write-Host "ERROR: Images folder not found at $imagesPath" -ForegroundColor Red
    pause; exit 1
}

$imgExts = @('.jpg','.jpeg','.png','.gif','.webp','.svg','.bmp')

# Sort numerically when folder names are numbers, else alphabetically
$folders = Get-ChildItem -Path $imagesPath -Directory | Sort-Object {
    $n = 0
    if ([int]::TryParse($_.Name, [ref]$n)) { $n } else { [int]::MaxValue }
}

$entries = @()
foreach ($folder in $folders) {
    $files     = Get-ChildItem -Path $folder.FullName
    $imageFile = $files | Where-Object { $imgExts -contains $_.Extension.ToLower() } | Select-Object -First 1
    $pdfFile   = $files | Where-Object { $_.Extension.ToLower() -eq '.pdf' }         | Select-Object -First 1

    if ($imageFile) {
        $entries += [PSCustomObject]@{
            folder = $folder.Name
            image  = $imageFile.Name
            pdf    = if ($pdfFile) { $pdfFile.Name } else { $null }
        }
    }
}

# Build JSON manually to control null vs string output cleanly
$lines = $entries | ForEach-Object {
    $pdf = if ($_.pdf) { "`"$($_.pdf)`"" } else { "null" }
    "  {`"folder`":`"$($_.folder)`",`"image`":`"$($_.image)`",`"pdf`":$pdf}"
}
$json   = "[\n" + ($lines -join ",`n") + "`n]"
$output = "window.IMAGES_MANIFEST = $json;"

[System.IO.File]::WriteAllText($outputPath, $output, [System.Text.Encoding]::UTF8)

Write-Host ""
Write-Host "  manifest.js updated — $($entries.Count) images found." -ForegroundColor Green
Write-Host "  Refresh index.html in your browser (or push to GitHub)." -ForegroundColor Cyan
Write-Host ""
Start-Sleep -Seconds 2
