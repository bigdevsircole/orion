# PowerShell helper to push this local folder to a GitHub repository
# Usage:
# 1. Open PowerShell in this folder: cd d:\CODINGS\orion
# 2. Run: .\push-to-github.ps1 -RemoteUrl "https://github.com/USERNAME/REPO.git" -Branch main
#
# This script will initialize git (if needed), add all files, commit, add remote, and push.
# It will prompt for credentials if required. For a smoother experience, use the GitHub CLI (gh) or a PAT.

param(
    [Parameter(Mandatory=$true)]
    [string]$RemoteUrl,

    [Parameter(Mandatory=$false)]
    [string]$Branch = "main",

    [Parameter(Mandatory=$false)]
    [string]$CommitMessage = "Initial commit from local workspace"
)

function Run-Git {
    param($args)
    Write-Host "git $args"
    git $args
    if ($LASTEXITCODE -ne 0) {
        throw "Git command failed: git $args"
    }
}

# Ensure git is available
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "git is not installed or not in PATH. Install Git for Windows and retry."
    exit 1
}

# Initialize repo if needed
if (-not (Test-Path .git)) {
    Write-Host "Initializing git repository..."
    Run-Git "init"
    # Ensure default branch exists
    Run-Git "checkout -b $Branch"
} else {
    Write-Host ".git already exists; using existing repository."
}

# Stage and commit
Run-Git "add -A"

# Only commit if there are staged changes
$changes = git status --porcelain
if ($changes) {
    Run-Git "commit -m '$CommitMessage'"
} else {
    Write-Host "No changes to commit."
}

# Add remote (replace if exists)
$existing = git remote get-url origin 2>$null
if ($existing) {
    Write-Host "Remote 'origin' already exists: $existing"
    if ($existing -ne $RemoteUrl) {
        Write-Host "Updating 'origin' to $RemoteUrl"
        Run-Git "remote set-url origin $RemoteUrl"
    }
} else {
    Run-Git "remote add origin $RemoteUrl"
}

# Push
Write-Host "Pushing to $RemoteUrl (branch: $Branch)"
Run-Git "push -u origin $Branch"

Write-Host "Push complete. Verify repository on GitHub."