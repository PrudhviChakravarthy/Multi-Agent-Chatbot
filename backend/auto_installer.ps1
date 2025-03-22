# Script: Update-Requirements.ps1
# This script:
# 1. Finds a Python virtual environment in the current directory
# 2. Installs packages from requirements.txt if it exists
# 3. Updates requirements.txt with the current pip freeze output

## Note: update the envFolder with the current folder u are working with.

# Function to find virtual environment in current directory
function Find-VirtualEnv {
    # Common virtual environment folder names
    $envFolders = @("env", "venv", ".env", ".venv", "virtualenv")
    
    foreach ($folder in $envFolders) {
        if (Test-Path $folder) {
            $activatePath = Join-Path -Path $folder -ChildPath "Scripts\Activate.ps1"
            if (Test-Path $activatePath) {
                return $folder
            }
        }
    }
    
    # If no environment found in common folders, search the current directory
    $possibleEnvs = Get-ChildItem -Directory | Where-Object {
        $activatePath = Join-Path -Path $_.FullName -ChildPath "Scripts\Activate.ps1"
        Test-Path $activatePath
    }
    
    if ($possibleEnvs.Count -gt 0) {
        return $possibleEnvs[0].FullName
    }
    
    return $null
}

# Main script execution
try {
    # Try to find a virtual environment
    $envPath = Find-VirtualEnv
    
    if ($null -eq $envPath) {
        Write-Error "Error: Could not find a virtual environment in the current directory."
        Write-Host "Please create a virtual environment or specify the path manually." -ForegroundColor Yellow
        exit 1
    }
    
    # Determine the activate script location
    $activateScript = Join-Path -Path $envPath -ChildPath "Scripts\Activate.ps1"
    
    Write-Host "Found virtual environment at: $envPath" -ForegroundColor Green
    Write-Host "Activating virtual environment..." -ForegroundColor Green
    
    # Activate the virtual environment
    & $activateScript
    
    # Check if activation was successful
    if (-not $env:VIRTUAL_ENV) {
        Write-Error "Error: Failed to activate the virtual environment."
        exit 1
    }
    
    Write-Host "Virtual environment activated successfully." -ForegroundColor Green
    
    # Check if requirements.txt exists and install packages if it does
    $requirementsPath = "requirements.txt"
    if (Test-Path $requirementsPath) {
        Write-Host "Found existing requirements.txt file. Installing packages..." -ForegroundColor Green
        
        # Install packages from requirements.txt
        pip install -r $requirementsPath
        
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Some packages may have failed to install. Continuing anyway..."
        } else {
            Write-Host "Successfully installed packages from requirements.txt" -ForegroundColor Green
        }
    } else {
        Write-Host "No existing requirements.txt found. Will create a new one." -ForegroundColor Yellow
    }
    
    # Update requirements.txt with current environment packages
    Write-Host "Updating requirements.txt file with current environment packages..." -ForegroundColor Green
    
    # Run pip freeze and output to requirements.txt
    $pip_data = pip freeze 
    $pip_data | Out-File -FilePath $requirementsPath -Encoding utf8
    
    # Check if requirements.txt was created successfully
    if (Test-Path $requirementsPath) {
        $packageCount = (Get-Content $requirementsPath | Measure-Object -Line).Lines
        Write-Host "Successfully updated requirements.txt with $packageCount package(s)." -ForegroundColor Green
        Write-Host "File saved at: $(Resolve-Path $requirementsPath)" -ForegroundColor Green
    } else {
        Write-Error "Error: Failed to update requirements.txt."
        exit 1
    }
} catch {
    Write-Error "An error occurred: $_"
    exit 1
} finally {
    # Deactivate the virtual environment if it was activated
    if ($env:VIRTUAL_ENV) {
        # In PowerShell, we need to use the deactivate function that was added to the session
        deactivate
        Write-Host "Virtual environment deactivated." -ForegroundColor Green
    }
}