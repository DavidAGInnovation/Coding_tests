# PowerShell Test 1: Scan Directory and Display File Contents

param (
    [Parameter(Mandatory=$true, HelpMessage="Enter the directory path to scan for .txt files.")]
    [string]$DirectoryPath
)

# Check if the directory exists
if (-not (Test-Path -Path $DirectoryPath -PathType Container)) {
    Write-Error "Error: The specified directory '$DirectoryPath' does not exist or is not a directory."
    exit 1
}

Write-Host "Scanning directory: $DirectoryPath for .txt files..." -ForegroundColor Yellow

# Get all .txt files in the specified directory (non-recursive)
$textFiles = Get-ChildItem -Path $DirectoryPath -Filter "*.txt" -File

if ($textFiles.Count -eq 0) {
    Write-Host "No .txt files found in '$DirectoryPath'." -ForegroundColor Cyan
    exit 0
}

Write-Host "Text files found:" -ForegroundColor Green
for ($i = 0; $i -lt $textFiles.Count; $i++) {
    Write-Host ("[{0}] {1}" -f ($i + 1), $textFiles[$i].Name)
}

Write-Host "" # Empty line for spacing

# Loop for user input
while ($true) {
    $selection = Read-Host "Enter the number of the file to display (or 'q' to quit)"

    if ($selection -eq 'q') {
        Write-Host "Exiting."
        break
    }

    # Validate input is a number
    if ($selection -match "^\d+$") {
        $fileIndex = [int]$selection - 1 # Adjust for 0-based array index

        if ($fileIndex -ge 0 -and $fileIndex -lt $textFiles.Count) {
            $selectedFile = $textFiles[$fileIndex]
            Write-Host ("--- Contents of '{0}' ---" -f $selectedFile.Name) -ForegroundColor Magenta
            try {
                Get-Content -Path $selectedFile.FullName
            }
            catch {
                Write-Error "Error reading file '$($selectedFile.FullName)': $_"
            }
            Write-Host ("--- End of '{0}' ---" -f $selectedFile.Name) -ForegroundColor Magenta
            Write-Host ""
            # Optional: break here if you only want them to select one file per run
            # break 
        } else {
            Write-Warning "Invalid selection. Please enter a number from the list."
        }
    } else {
        Write-Warning "Invalid input. Please enter a number or 'q'."
    }
}

Write-Host "Script finished."