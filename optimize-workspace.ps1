# VS Code Workspace Auto-Optimizer
# Automatically detects project type and applies optimal VS Code settings
# Author: sparkysmith99
# Usage: Run from your project directory to auto-configure workspace settings

param(
    [string]$TemplateType = ""
)

# Templates directory
$TemplatesDir = "$env:USERPROFILE\.vscode\workspace-templates"

# Detect project type based on files in current directory
function Detect-ProjectType {
    Write-Host "Detecting project type..." -ForegroundColor Cyan
    
    # Check for Python/Tkinter
    if (Test-Path "*.py") {
        $pythonFiles = Get-Content *.py -Raw -ErrorAction SilentlyContinue
        if ($pythonFiles -match "tkinter|tk\.") {
            return "python-tkinter"
        }
    }
    
    # Check for Android/Gradle
    if ((Test-Path "gradlew") -or (Test-Path "build.gradle") -or (Test-Path "app\src\main")) {
        return "android-java"
    }
    
    # Check for Web Development
    if ((Test-Path "package.json") -or (Test-Path "index.html") -or (Test-Path "www\")) {
        return "web-dev"
    }
    
    # Check for Data Science
    if (Test-Path "*.ipynb") {
        return "data-science"
    }
    
    return $null
}

# Apply template to current workspace
function Apply-Template {
    param([string]$Type)
    
    $templatePath = "$TemplatesDir\$Type.json"
    
    if (-not (Test-Path $templatePath)) {
        Write-Host "Template not found: $templatePath" -ForegroundColor Red
        return $false
    }
    
    # Read template
    $template = Get-Content $templatePath -Raw | ConvertFrom-Json
    
    Write-Host "`nApplying template: $($template.name)" -ForegroundColor Green
    Write-Host "Description: $($template.description)" -ForegroundColor Gray
    
    # Create .vscode directory if not exists
    if (-not (Test-Path ".vscode")) {
        New-Item -ItemType Directory -Path ".vscode" | Out-Null
    }
    
    # Write settings
    $settingsPath = ".vscode\settings.json"
    $template.settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
    
    Write-Host "`n✓ Created workspace settings: $settingsPath" -ForegroundColor Green
    
    # Display recommended extensions
    if ($template.extensions) {
        Write-Host "`nRecommended Extensions:" -ForegroundColor Yellow
        $template.extensions | ForEach-Object {
            Write-Host "  - $_" -ForegroundColor Gray
        }
    }
    
    return $true
}

# Main execution
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "VS Code Workspace Optimizer" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

# Determine template type
if ($TemplateType -eq "") {
    $detectedType = Detect-ProjectType
    if ($detectedType) {
        Write-Host "Detected: $detectedType" -ForegroundColor Green
        $TemplateType = $detectedType
    } else {
        Write-Host "Could not detect project type automatically." -ForegroundColor Yellow
        Write-Host "Please specify template type with -TemplateType parameter" -ForegroundColor Yellow
        Write-Host "`nAvailable templates:" -ForegroundColor Cyan
        Get-ChildItem "$TemplatesDir\*.json" | ForEach-Object {
            $name = $_.BaseName
            Write-Host "  - $name" -ForegroundColor Gray
        }
        exit 1
    }
} else {
    Write-Host "Using specified template: $TemplateType" -ForegroundColor Cyan
}

# Apply template
$success = Apply-Template -Type $TemplateType

if ($success) {
    Write-Host "`n✓ Workspace optimization complete!" -ForegroundColor Green
    Write-Host "Reload VS Code window to apply changes.`n" -ForegroundColor Yellow
} else {
    Write-Host "`n✗ Optimization failed!" -ForegroundColor Red
    exit 1
}
