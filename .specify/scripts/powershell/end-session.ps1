# AIOCR Session End Script
# Run before logging off: .\.specify\scripts\powershell\end-session.ps1

param(
    [switch]$SkipTests,
    [switch]$SkipLinting,
    [switch]$Quick
)

$ErrorActionPreference = "SilentlyContinue"

Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║       AIOCR Session End Protocol v1.0                 ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

$startTime = Get-Date

# Step 1: Cleanup
Write-Host "`n[1/6] Code Cleanup..." -ForegroundColor Yellow
$cleaned = 0

# Remove Python cache
Get-ChildItem -Path . -Recurse -Include '__pycache__','*.pyc','*.pyo' -Force | ForEach-Object {
    Remove-Item $_.FullName -Recurse -Force
    $cleaned++
}

# Remove temporary files
Get-ChildItem -Path . -Recurse -Include '*.tmp','*.temp','*.swp','*.swo' -Force | ForEach-Object {
    Remove-Item $_.FullName -Force
    $cleaned++
}

# Remove test artifacts
$testArtifacts = @("htmlcov", ".coverage", ".pytest_cache", "test-results", ".mypy_cache")
foreach ($artifact in $testArtifacts) {
    if (Test-Path $artifact) {
        Remove-Item -Recurse -Force $artifact
        $cleaned++
    }
}

Write-Host "✅ Cleanup complete ($cleaned items removed)" -ForegroundColor Green

# Step 2: Security Check
Write-Host "`n[2/6] Security Check..." -ForegroundColor Yellow
$securityIssues = @()

# Check if .env is tracked
if (git ls-files | Select-String -Pattern "^\.env$" -Quiet) {
    Write-Host "⚠️ CRITICAL: .env is tracked! Removing from git..." -ForegroundColor Red
    git rm --cached .env
    $securityIssues += ".env was tracked (now removed)"
}

# Check for API keys in code
$apiKeyPatterns = @(
    'api_key\s*=\s*["\'][a-zA-Z0-9-_]{20,}',
    'API_KEY\s*=\s*["\'][a-zA-Z0-9-_]{20,}',
    'sk-[a-zA-Z0-9]{20,}',
    'password\s*=\s*["\'][^"\']{8,}'
)

Get-ChildItem -Path src,tests -Recurse -Include '*.py' -ErrorAction SilentlyContinue | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    foreach ($pattern in $apiKeyPatterns) {
        if ($content -match $pattern) {
            $securityIssues += "Potential secret in: $($_.Name)"
        }
    }
}

if ($securityIssues.Count -gt 0) {
    Write-Host "⚠️ Security issues found:" -ForegroundColor Red
    $securityIssues | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    Write-Host "`nFix these before pushing!" -ForegroundColor Red
    if (-not $Quick) {
        Read-Host "Press Enter to continue anyway or Ctrl+C to abort"
    }
} else {
    Write-Host "✅ No security issues detected" -ForegroundColor Green
}

# Step 3: Tests
if (-not $SkipTests -and -not $Quick) {
    Write-Host "`n[3/6] Running Tests..." -ForegroundColor Yellow
    if (Test-Path "tests") {
        if (Get-Command pytest -ErrorAction SilentlyContinue) {
            $testResult = pytest tests/ -q --tb=line 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Host "❌ Tests failed!" -ForegroundColor Red
                Write-Host $testResult -ForegroundColor Gray
                Write-Host "`nFix tests before pushing!" -ForegroundColor Yellow
                Read-Host "Press Enter to continue anyway or Ctrl+C to abort"
            } else {
                Write-Host "✅ All tests passed" -ForegroundColor Green
            }
        } else {
            Write-Host "⚠️ pytest not found, skipping tests" -ForegroundColor Yellow
        }
    } else {
        Write-Host "ℹ️ No tests directory found" -ForegroundColor Gray
    }
} else {
    Write-Host "`n[3/6] Tests skipped" -ForegroundColor Gray
}

# Step 4: Git Status
Write-Host "`n[4/6] Git Status..." -ForegroundColor Yellow
$branch = git branch --show-current
$uncommitted = git status --porcelain

Write-Host "Branch: $branch" -ForegroundColor White

if ($uncommitted) {
    Write-Host "`nUncommitted changes:" -ForegroundColor Yellow
    git status --short
    
    if (-not $Quick) {
        Write-Host "`n⚠️ You have uncommitted changes!" -ForegroundColor Yellow
        Write-Host "Options:" -ForegroundColor Yellow
        Write-Host "  1. Commit them now (recommended)" -ForegroundColor White
        Write-Host "  2. Continue without committing" -ForegroundColor White
        Write-Host "  3. Abort (Ctrl+C)" -ForegroundColor White
        
        $choice = Read-Host "`nChoice (1/2)"
        
        if ($choice -eq "1") {
            $message = Read-Host "Commit message"
            if ($message) {
                git add -A
                git commit -m $message
                Write-Host "✅ Changes committed" -ForegroundColor Green
            }
        }
    }
} else {
    Write-Host "✅ Working directory clean" -ForegroundColor Green
}

# Step 5: Update Session State
Write-Host "`n[5/6] Session State..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss UTC"
$lastCommit = git log -1 --oneline 2>$null

Write-Host "Current time: $timestamp" -ForegroundColor White
Write-Host "Last commit: $lastCommit" -ForegroundColor White

if (-not $Quick) {
    Write-Host "`n⚠️ Remember to update:" -ForegroundColor Yellow
    Write-Host "  .specify/memory/session_state.md" -ForegroundColor White
    Write-Host "  (Add what you accomplished this session)" -ForegroundColor Gray
}

# Step 6: Push to GitHub
Write-Host "`n[6/6] Pushing to GitHub..." -ForegroundColor Yellow

# Fetch first to check if we're behind
git fetch origin $branch 2>$null

$ahead = git rev-list origin/$branch..$branch --count 2>$null
$behind = git rev-list $branch..origin/$branch --count 2>$null

if ($behind -gt 0) {
    Write-Host "⚠️ Your branch is $behind commits behind remote" -ForegroundColor Yellow
    Write-Host "Consider pulling first: git pull origin $branch" -ForegroundColor Yellow
    
    if (-not $Quick) {
        Read-Host "Press Enter to force push or Ctrl+C to abort"
    }
}

# Push current branch
Write-Host "Pushing $branch..." -ForegroundColor Cyan
git push origin $branch 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Pushed to origin/$branch" -ForegroundColor Green
    
    # Also sync to master if on main development branch
    if ($branch -eq "001-webcam-ocr-ai") {
        Write-Host "Syncing to master..." -ForegroundColor Cyan
        git push origin ${branch}:master --force 2>&1 | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Master branch updated" -ForegroundColor Green
        } else {
            Write-Host "⚠️ Failed to update master" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "❌ Push failed!" -ForegroundColor Red
    Write-Host "Check your network connection and git credentials" -ForegroundColor Yellow
}

# Summary
$elapsed = (Get-Date) - $startTime
Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║       ✅ Session End Complete - Safe to Log Off        ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`n📊 Summary:" -ForegroundColor Cyan
Write-Host "  Repository: https://github.com/lizzardkink/AIOCR" -ForegroundColor White
Write-Host "  Branch: $branch" -ForegroundColor White
Write-Host "  Timestamp: $timestamp" -ForegroundColor White
Write-Host "  Duration: $($elapsed.TotalSeconds.ToString('0.0'))s" -ForegroundColor White
Write-Host "  Cleaned: $cleaned items" -ForegroundColor White

if ($securityIssues.Count -eq 0 -and -not $uncommitted) {
    Write-Host "`n✨ All good! Repository is clean and synced." -ForegroundColor Green
}

Write-Host "`n👋 See you next session!" -ForegroundColor Cyan
