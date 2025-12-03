# AIOCR Session Start Script
# Run at beginning of session: .\.specify\scripts\powershell\start-session.ps1

param(
    [switch]$SkipCopilot,
    [switch]$Quick
)

$ErrorActionPreference = "SilentlyContinue"

Clear-Host

Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║       AIOCR Session Start Protocol v1.1               ║" -ForegroundColor Cyan
Write-Host "║       (Constitution v1.4.0 - Portable Development)   ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

$startTime = Get-Date
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss UTC"

Write-Host "`n🚀 Starting AIOCR Development Session" -ForegroundColor Green
Write-Host "⏰ Time: $timestamp" -ForegroundColor Gray

# Step 1: Verify Location
Write-Host "`n[1/7] Verifying Location..." -ForegroundColor Yellow
$currentPath = (Get-Location).Path
$expectedPath = "AIOCR"

if ($currentPath -like "*$expectedPath*") {
    Write-Host "✅ In AIOCR directory: $currentPath" -ForegroundColor Green
} else {
    Write-Host "⚠️ Not in AIOCR directory!" -ForegroundColor Red
    Write-Host "Current: $currentPath" -ForegroundColor Gray
    Write-Host "Expected to contain: $expectedPath" -ForegroundColor Gray
    exit 1
}

# Step 2: Git Status
Write-Host "`n[2/7] Checking Git Status..." -ForegroundColor Yellow
$branch = git branch --show-current
$lastCommit = git log -1 --oneline 2>$null
$uncommitted = git status --porcelain

Write-Host "📍 Branch: $branch" -ForegroundColor White
Write-Host "📝 Last commit: $lastCommit" -ForegroundColor White

if ($uncommitted) {
    Write-Host "⚠️ Uncommitted changes detected:" -ForegroundColor Yellow
    git status --short
} else {
    Write-Host "✅ Working directory clean" -ForegroundColor Green
}

# Fetch latest from remote
Write-Host "`nFetching latest from GitHub..." -ForegroundColor Cyan
git fetch origin --quiet 2>$null

$behind = git rev-list HEAD..origin/$branch --count 2>$null
if ($behind -gt 0) {
    Write-Host "⚠️ Your branch is $behind commits behind origin/$branch" -ForegroundColor Yellow
    Write-Host "Consider pulling: git pull origin $branch" -ForegroundColor Yellow
} else {
    Write-Host "✅ Up to date with remote" -ForegroundColor Green
}

# Step 3: Read Constitution
Write-Host "`n[3/7] Reading Constitution..." -ForegroundColor Yellow

if (Test-Path ".specify\memory\constitution.md") {
    $constitutionContent = Get-Content ".specify\memory\constitution.md" -Raw
    
    # Extract version
    if ($constitutionContent -match 'Version.*?:\s*(\d+\.\d+\.\d+)') {
        $constitutionVersion = $matches[1]
        Write-Host "📜 Constitution v$constitutionVersion loaded" -ForegroundColor Green
    }
    
    # Extract core principles count
    $principlesCount = ([regex]::Matches($constitutionContent, "###\s+[IVX]+\.")).Count
    Write-Host "📋 $principlesCount Core Principles acknowledged" -ForegroundColor Green
    
    # Show key principles
    Write-Host "`n🔑 Key Principles:" -ForegroundColor Cyan
    Write-Host "  I.   Modular Architecture (NON-NEGOTIABLE)" -ForegroundColor White
    Write-Host "  II.  User Control & Confirmation" -ForegroundColor White
    Write-Host "  III. Test-First Development (NON-NEGOTIABLE)" -ForegroundColor White
    Write-Host "  IV.  Specification-Driven Development" -ForegroundColor White
    Write-Host "  V.   Multiple Deployment Targets" -ForegroundColor White
    Write-Host "  VI.  Stability Over Features" -ForegroundColor White
    Write-Host "  VII. Simplicity & Pragmatism" -ForegroundColor White
    Write-Host "  VIII.Scalability by Design" -ForegroundColor White
    Write-Host "  IX.  Universal Connectivity" -ForegroundColor White
    
} else {
    Write-Host "❌ Constitution not found!" -ForegroundColor Red
    exit 1
}

# Step 4: Read Session State
Write-Host "`n[4/7] Loading Session State..." -ForegroundColor Yellow

if (Test-Path ".specify\memory\session_state.md") {
    $sessionState = Get-Content ".specify\memory\session_state.md" -Raw
    
    # Extract current phase
    if ($sessionState -match 'Current Phase.*?:\s*(.+)') {
        $currentPhase = $matches[1]
        Write-Host "🎯 Current Phase: Phase 1 - Modular Desktop App" -ForegroundColor Green
    }
    
    # Extract status
    if ($sessionState -match 'Status:\s*([^\n]+)') {
        $status = $matches[1].Trim()
        Write-Host "📊 Status: $status" -ForegroundColor White
    }
    
    # Show progress tracker
    Write-Host "`n📋 Module Progress:" -ForegroundColor Cyan
    $modules = @("Camera", "Stream", "Capture", "OCR", "Prompt", "Agent", "Controller", "UI")
    foreach ($module in $modules) {
        Write-Host "  [ ] $module - Pending" -ForegroundColor Gray
    }
    
} else {
    Write-Host "⚠️ Session state not found, creating..." -ForegroundColor Yellow
}

# Step 5: Check Specifications
Write-Host "`n[5/7] Checking Specifications..." -ForegroundColor Yellow

$specs = Get-ChildItem "specs" -Directory -ErrorAction SilentlyContinue
if ($specs) {
    Write-Host "📚 Available Specifications:" -ForegroundColor Green
    foreach ($spec in $specs) {
        $specFile = Join-Path $spec.FullName "spec.md"
        if (Test-Path $specFile) {
            # Check if completed
            $status = "📋 Planned"
            if ($spec.Name -eq "001-webcam-ocr-ai") { $status = "✅ Completed" }
            if ($spec.Name -eq "003-modular-desktop-app") { $status = "🔄 Current" }
            
            Write-Host "  $status - $($spec.Name)" -ForegroundColor White
        }
    }
} else {
    Write-Host "⚠️ No specifications found" -ForegroundColor Yellow
}

# Step 6: Environment Check
Write-Host "`n[6/7] Environment Check..." -ForegroundColor Yellow

# Check Python
if (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "⚠️ Python not found" -ForegroundColor Yellow
}

# Check pytest
if (Get-Command pytest -ErrorAction SilentlyContinue) {
    Write-Host "✅ pytest available" -ForegroundColor Green
} else {
    Write-Host "⚠️ pytest not installed" -ForegroundColor Yellow
}

# Check .env file
if (Test-Path ".env") {
    Write-Host "✅ .env file exists" -ForegroundColor Green
    
    # Check for required keys
    $envContent = Get-Content ".env" -Raw
    $requiredKeys = @("OPENAI_API_KEY", "TESSERACT_PATH")
    foreach ($key in $requiredKeys) {
        if ($envContent -match "$key\s*=\s*.+") {
            Write-Host "  ✓ $key configured" -ForegroundColor Gray
        } else {
            Write-Host "  ⚠️ $key missing or empty" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "⚠️ .env file not found" -ForegroundColor Yellow
    Write-Host "  Create from .env.example" -ForegroundColor Gray
}

# Check Tesseract
$tesseractPath = "C:\Program Files\Tesseract-OCR\tesseract.exe"
if (Test-Path $tesseractPath) {
    Write-Host "✅ Tesseract OCR installed" -ForegroundColor Green
} else {
    Write-Host "⚠️ Tesseract not found at default location" -ForegroundColor Yellow
}

# Step 7: Terminal Setup & Launch Copilot
if (-not $SkipCopilot -and -not $Quick) {
    Write-Host "`n[7/8] Terminal Setup (Constitution Principle X)..." -ForegroundColor Yellow
    
    Write-Host "`n📋 Two-Terminal Workflow:" -ForegroundColor Cyan
    Write-Host "   This script follows Constitution v1.3.0 - Terminal Separation" -ForegroundColor Gray
    Write-Host ""
    Write-Host "   🗣️  Terminal 1 (THIS ONE): Conversation with Copilot" -ForegroundColor White
    Write-Host "      • Clean history: Only prompts and responses" -ForegroundColor Gray
    Write-Host "      • No command output clutter" -ForegroundColor Gray
    Write-Host "      • Stay here for discussions" -ForegroundColor Gray
    Write-Host ""
    Write-Host "   ⚙️  Terminal 2 (OPEN SEPARATELY): Execute commands" -ForegroundColor White
    Write-Host "      • Run: pytest, python, git, etc." -ForegroundColor Gray
    Write-Host "      • See: Test results, build output, logs" -ForegroundColor Gray
    Write-Host "      • Open side-by-side or on second monitor" -ForegroundColor Gray
    
    Write-Host "`n⚠️  IMPORTANT: Open a second terminal now!" -ForegroundColor Yellow
    Write-Host "   Path: $currentPath" -ForegroundColor Gray
    Write-Host "   Purpose: Run all commands there (not here)" -ForegroundColor Gray
    
    Write-Host "`n   Example commands for Terminal 2:" -ForegroundColor Cyan
    Write-Host "      cd $currentPath" -ForegroundColor Gray
    Write-Host "      pytest tests/" -ForegroundColor Gray
    Write-Host "      python src/main.py" -ForegroundColor Gray
    Write-Host "      git status" -ForegroundColor Gray
    
    Write-Host "`n✅ Benefits of Terminal Separation:" -ForegroundColor Green
    Write-Host "   • Clean conversation history (easy to review)" -ForegroundColor Gray
    Write-Host "   • Command output doesn't clutter discussion" -ForegroundColor Gray
    Write-Host "   • Better focus on each task" -ForegroundColor Gray
    Write-Host "   • TDD workflow: discuss here, run tests there" -ForegroundColor Gray
    
    Write-Host "`n📖 See: .specify\memory\constitution.md (Principle X)" -ForegroundColor Cyan
    
    Write-Host "`n⏸️  Press Enter when you've opened Terminal 2..." -ForegroundColor Yellow
    Read-Host
    
    Write-Host "`n[8/8] Starting GitHub Copilot CLI..." -ForegroundColor Yellow
    
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        Write-Host "✅ GitHub CLI available" -ForegroundColor Green
        Write-Host "`n📝 Copilot will read:" -ForegroundColor Cyan
        Write-Host "  • Constitution (v$constitutionVersion - Portable Development + Terminal Separation)" -ForegroundColor White
        Write-Host "  • Session State (current phase)" -ForegroundColor White
        Write-Host "  • Project Specs" -ForegroundColor White
        Write-Host "  • Recent commits" -ForegroundColor White
        
        Write-Host "`n🤖 Launching GitHub Copilot in THIS terminal (conversation only)..." -ForegroundColor Cyan
        Write-Host "   Remember: Run all commands in Terminal 2!" -ForegroundColor Yellow
        Write-Host "   (Type 'exit' to close Copilot and return to terminal)" -ForegroundColor Gray
        Write-Host ""
        
        # Give user time to read
        Start-Sleep -Seconds 2
        
        # Start Copilot with context
        gh copilot
        
    } else {
        Write-Host "⚠️ GitHub CLI (gh) not found" -ForegroundColor Yellow
        Write-Host "   Install: winget install GitHub.cli" -ForegroundColor Gray
    }
} else {
    Write-Host "`n[7/8] Terminal separation info skipped (-Quick mode)" -ForegroundColor Gray
    Write-Host "`n[8/8] Copilot launch skipped" -ForegroundColor Gray
}

# Summary
$elapsed = (Get-Date) - $startTime
Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║       ✅ Session Start Complete - Ready to Code!       ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`n📊 Session Summary:" -ForegroundColor Cyan
Write-Host "  Repository: https://github.com/lizzardkink/AIOCR" -ForegroundColor White
Write-Host "  Branch: $branch" -ForegroundColor White
Write-Host "  Constitution: v$constitutionVersion (11 principles + Portable Development)" -ForegroundColor White
Write-Host "  Current Phase: Phase 1 - Modular Desktop App" -ForegroundColor White
Write-Host "  Status: Ready to begin TDD implementation" -ForegroundColor White
Write-Host "  Duration: $($elapsed.TotalSeconds.ToString('0.0'))s" -ForegroundColor White

Write-Host "`n🗣️  Terminal 1 (THIS): Conversation Only" -ForegroundColor Cyan
Write-Host "  • Discuss with Copilot" -ForegroundColor Gray
Write-Host "  • Ask questions, plan features" -ForegroundColor Gray
Write-Host "  • Clean history, easy to review" -ForegroundColor Gray

Write-Host "`n⚙️  Terminal 2 (SEPARATE): Execution Only" -ForegroundColor Cyan
Write-Host "  • Run: pytest tests/" -ForegroundColor Gray
Write-Host "  • Run: python src/main.py" -ForegroundColor Gray
Write-Host "  • Run: git status" -ForegroundColor Gray
Write-Host "  • Run: .\.specify\scripts\powershell\end-session.ps1" -ForegroundColor Gray

Write-Host "`n🎯 Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Review current spec: specs\003-modular-desktop-app\spec.md" -ForegroundColor White
Write-Host "  2. Start with ConfigManager module tests (TDD)" -ForegroundColor White
Write-Host "  3. Follow Red-Green-Refactor cycle" -ForegroundColor White

Write-Host "`n💡 Remember: Run all commands in Terminal 2!" -ForegroundColor Yellow

if (-not $SkipCopilot -and -not $Quick) {
    Write-Host "`n🤖 GitHub Copilot is ready!" -ForegroundColor Green
    Write-Host "   Ask: 'Read the constitution and continue where we left off'" -ForegroundColor White
}

Write-Host "`n✨ Happy Coding! Follow TDD: Red → Green → Refactor" -ForegroundColor Cyan
Write-Host ""
