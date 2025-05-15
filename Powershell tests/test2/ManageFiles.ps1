# PowerShell Test 2: Directory and File Operations

# --- 1. Create a Directory ---
$newDirPath = Read-Host "Enter the full path for the new directory to create (e.g., C:\Temp\MyTestDir)"

if (-not $newDirPath) {
    Write-Error "Directory path cannot be empty. Exiting."
    exit 1
}

if (-not (Test-Path -Path $newDirPath)) {
    try {
        New-Item -Path $newDirPath -ItemType Directory -Force -ErrorAction Stop | Out-Null
        Write-Host "Directory '$newDirPath' created successfully." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to create directory '$newDirPath'. Error: $($_.Exception.Message)"
        exit 1
    }
} else {
    Write-Host "Directory '$newDirPath' already exists." -ForegroundColor Cyan
}

# --- 2. Create Files ---
$fileNames = @("file1.txt", "file2.txt", "file3.txt")
Write-Host "`nCreating files in '$newDirPath'..." -ForegroundColor Yellow

foreach ($fileName in $fileNames) {
    $filePath = Join-Path -Path $newDirPath -ChildPath $fileName
    try {
        if (-not (Test-Path -Path $filePath)) {
            New-Item -Path $filePath -ItemType File -ErrorAction Stop | Out-Null
            Write-Host "  Created file: $fileName" -ForegroundColor Green
        } else {
            Write-Host "  File '$fileName' already exists." -ForegroundColor Cyan
        }
    }
    catch {
        Write-Error "  Failed to create file '$fileName'. Error: $($_.Exception.Message)"
    }
}

# --- 3. Write to Files ---
Write-Host "`nWriting content to files..." -ForegroundColor Yellow
$sampleContent = @(
    "This is the first line in file1.",
    "This is some sample text for file2, with a second line.",
    "Hello from file3! PowerShell is fun."
)

for ($i = 0; $i -lt $fileNames.Count; $i++) {
    $filePath = Join-Path -Path $newDirPath -ChildPath $fileNames[$i]
    $content = if ($i -lt $sampleContent.Count) { $sampleContent[$i] } else { "Default content for $($fileNames[$i])" }
    try {
        Set-Content -Path $filePath -Value $content -ErrorAction Stop
        Write-Host "  Wrote content to $($fileNames[$i])" -ForegroundColor Green
    }
    catch {
        Write-Error "  Failed to write to file '$($fileNames[$i])'. Error: $($_.Exception.Message)"
    }
}

# --- 4. List Files ---
Write-Host "`nListing files in '$newDirPath' with their sizes:" -ForegroundColor Yellow
try {
    Get-ChildItem -Path $newDirPath -File -ErrorAction Stop | Format-Table Name, Length -AutoSize
}
catch {
    Write-Error "Failed to list files in '$newDirPath'. Error: $($_.Exception.Message)"
}


# --- 5. Delete a File ---
Write-Host "" # Empty line
$fileToDelete = Read-Host "Enter the name of a file to delete from '$newDirPath' (e.g., file1.txt)"

if (-not $fileToDelete) {
    Write-Warning "No filename entered for deletion. Skipping delete operation."
} else {
    $fullPathToDelete = Join-Path -Path $newDirPath -ChildPath $fileToDelete
    if (Test-Path -Path $fullPathToDelete -PathType Leaf) { # Leaf means a file
        try {
            Remove-Item -Path $fullPathToDelete -Force -ErrorAction Stop
            Write-Host "File '$fileToDelete' deleted successfully from '$newDirPath'." -ForegroundColor Green
        }
        catch {
            Write-Error "Failed to delete file '$fileToDelete'. Error: $($_.Exception.Message)"
        }
    } else {
        Write-Warning "File '$fileToDelete' not found in '$newDirPath' or it is a directory."
    }
}

Write-Host "`nScript finished."