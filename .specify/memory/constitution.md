# AIOCR Project Constitution

## Core Principles

### I. Modular Architecture (NON-NEGOTIABLE)
- Every feature must be broken into **functional modules** with single responsibility
- Modules must be independently testable and reusable
- Clear separation of concerns: Camera, Stream, Capture, OCR, Prompt, Agent
- No monolithic code - refactor existing code into modules before adding features
- Dependencies flow in one direction: Base → Services → Controller → UI

### II. User Control & Confirmation
- **AI operations require explicit user confirmation** - no automatic submissions
- Users must be able to review and edit prompts before submission
- Provide cancel/abort options at every step
- Show intermediate results (OCR text, confidence, extracted choices) before proceeding
- Respect user workflow: Capture → OCR → Review → Confirm → AI

### III. Test-First Development (NON-NEGOTIABLE)
- **TDD mandatory**: Tests written → User approved → Tests fail → Then implement
- Red-Green-Refactor cycle strictly enforced
- Every module must have passing tests before merging
- Tests define the contract - implementation must satisfy tests
- No production code without corresponding tests

### IV. Specification-Driven Development
- Every feature requires a spec in `specs/[ID]-[name]/spec.md`
- Every spec requires an implementation plan in `specs/[ID]-[name]/plan.md`
- Specs must define: Goals, Architecture, Module Structure, Success Criteria, Test Strategy
- Implementation follows the plan phases sequentially
- Get approval on spec before coding

### V. Multiple Deployment Targets
- Desktop application (OpenCV + Tkinter) - local execution
- Web service (FastAPI + Docker) - remote accessible
- Both must share core modules (reusability principle)
- Desktop-first: prove functionality locally before web deployment
- Containerization required for web services

### VI. Stability Over Features
- OpenCV for video streaming (proven stable, no crashes)
- Avoid tkinter PhotoImage for continuous frames (known memory leak on Windows)
- Test long-running sessions (>30 minutes) before declaring stability
- Camera initialization errors must be handled gracefully
- Preserve working code - branch before refactoring

### VII. Simplicity & Pragmatism (GUIDING PRINCIPLE)
- **Simple, straightforward solutions** over clever/complex ones
- Choose proven technologies over experimental
- Readable code over compact code
- Flat is better than nested
- Explicit is better than implicit
- If it can't be explained simply, it's too complex

### VIII. Scalability by Design
- **Design for growth from day one**
- Horizontal scaling capability (add more servers/containers)
- Stateless services where possible
- Queue-based processing for async operations
- Database connection pooling and caching
- Load balancing support built-in
- Performance metrics and monitoring hooks

### IX. Universal Connectivity
- **Integration-first architecture**
- Standard protocols: REST API, WebSocket, webhooks
- Well-documented API endpoints (OpenAPI/Swagger)
- Support multiple input formats (JSON, form-data, multipart)
- Support multiple output formats (JSON, plain text, structured)
- Webhook support for async notifications
- Plugin/extension system for custom integrations
- OAuth2/API key authentication options

### X. Terminal Separation (WORKFLOW PRINCIPLE)
- **Conversation terminal vs. Execution terminal** - Keep them separate
- GitHub Copilot CLI session runs in dedicated terminal for conversation
- All command execution (tests, builds, scripts) runs in separate terminal
- Conversation terminal stays clean: only prompts and responses
- Execution terminal shows: command output, test results, build logs
- Benefit: Clear conversation history without clutter from command output
- Benefit: Can review conversation without scrolling through logs
- Implementation: Open second terminal for running commands, keep first for Copilot

### XI. Portable Development (INFRASTRUCTURE PRINCIPLE)
- **No admin privileges required** - Everything runs in user space
- Virtual environment (.venv) isolates dependencies per project
- Python installed via Microsoft Store or user-level installer
- Git portable version or user-level installer
- VS Code user installer with GitHub Copilot extension
- Tesseract OCR portable or user-level install
- All configurations travel with repository (.vscode/, .specify/)
- Environment secrets in .env (gitignored, never committed)
- Quick setup: clone → venv → pip → code (~10 minutes)
- Benefit: Work on any machine (office, home, laptop) without admin
- Benefit: Consistent setup across all machines
- Benefit: New team members productive in 10 minutes
- Documentation: `.specify/memory/portable_setup.md` (comprehensive guide)

## Guiding Philosophy

### KISS Principle (Keep It Simple, Stupid)
- Start with the simplest solution that works
- Add complexity only when necessary and justified
- Refactor complex code into simpler patterns
- Document why complex solutions were chosen

### YAGNI Principle (You Aren't Gonna Need It)
- Build what's needed now, not what might be needed
- No speculative features or abstractions
- Extend when requirements demand it
- Delete unused code aggressively

### DRY with Wisdom (Don't Repeat Yourself - but use judgment)
- Extract common patterns into reusable functions/classes
- But: Don't force premature abstraction
- Some duplication is acceptable if it improves clarity
- Three strikes rule: refactor on third repetition

### Universal Design
- Platform-agnostic where possible
- Standard interfaces and protocols
- Language/framework-neutral APIs
- Support multiple client types (browser, mobile, API)
- Internationalization ready (i18n support)

## Technology Standards

### Required Stack
- **Python 3.13+** - Latest stable Python
- **OpenCV (cv2)** - Camera and video streaming
- **Tesseract OCR** - Text extraction
- **OpenAI / Anthropic SDKs** - AI agent communication
- **FastAPI** - Web service framework (when applicable)
- **Docker** - Containerization (for web deployment)

### Prohibited Patterns
- ❌ **Writing production code before tests** (TDD violation)
- ❌ **Over-engineering solutions** (violates simplicity principle)
- ❌ **Running commands in conversation terminal** (violates terminal separation)
- ❌ **Committing .env files with secrets** (violates portable setup)
- ❌ **Requiring admin privileges** (violates portable development)
- ❌ **Hardcoding paths to system directories** (violates portability)
- ❌ Continuous tkinter PhotoImage updates (causes memory leak)
- ❌ Hardcoded AI agents (must be pluggable)
- ❌ Hardcoded URLs, IPs, or endpoints (use configuration)
- ❌ Camera switching without restart (causes crashes)
- ❌ Processing without user confirmation
- ❌ Monolithic app files (must be modular)
- ❌ Merging code with failing tests
- ❌ Skipping test phase "to save time"
- ❌ Tight coupling between modules (reduces scalability)
- ❌ Stateful services that can't scale horizontally
- ❌ Custom protocols when standard ones exist

### Configuration Management
- Use `.env` for secrets and environment-specific settings
- Use YAML for agent configurations and templates
- Never commit `.env` - provide `.env.example` instead
- Support multiple AI agents via configuration
- Allow template customization for prompts
- All endpoints, URLs, and external services configurable
- Support environment variables for containerized deployment
- Configuration validation on startup (fail fast)

## Development Environment

### Required Setup (Portable - No Admin)

**Python 3.12+**
- Option A: Microsoft Store (recommended, automatic updates)
- Option B: Python.org installer (user-level install only)
- Option C: Portable Python (WinPython)
- Install location: User space (no Program Files)

**Git**
- Option A: Portable Git (extract and use)
- Option B: Git for Windows (user-level install)
- VS Code built-in Git (no separate install needed)

**VS Code**
- User Installer (not System Installer)
- Installs to: `%LOCALAPPDATA%\Programs\Microsoft VS Code`
- Required extensions: GitHub Copilot, Python, Pylance

**Project Setup**
```powershell
# Quick setup (10 minutes)
git clone https://github.com/lizzardkink/AIOCR.git
cd AIOCR
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
copy .env.example .env
code .
```

**Virtual Environment**
- Always use `.venv` in project directory
- Activate before any Python commands
- All dependencies installed in venv (isolated)
- Never install packages globally

**Verification**
```powershell
# Check setup
python --version  # 3.12+
where python      # Should show .venv\Scripts\python.exe
pip list          # Shows project dependencies
git status        # Shows branch
code --version    # Shows VS Code version
```

**See: `.specify/memory/portable_setup.md` for comprehensive guide**

---

## Maintenance Protocols

### Session Start Protocol

Execute at the **beginning** of every development session:

**Automated Script**: `.specify/scripts/powershell/start-session.ps1`

```powershell
.\.specify\scripts\powershell\start-session.ps1
```

**What it does**:
1. Verifies project directory
2. Checks git status and branch
3. Reads and displays Constitution
4. Loads current session state
5. Shows available specifications
6. Validates environment (dependencies, .env, tools)
7. Launches GitHub Copilot CLI (optional)
8. Displays next steps

**Options**:
- `-Quick` - Skip Copilot launch
- `-SkipCopilot` - Show everything except Copilot

### Session End Protocol

Execute **before** ending every development session:

**Step 1: Code Cleanup**
- Remove Python cache (`__pycache__`, `*.pyc`)
- Remove temporary files (`*.tmp`, `*.swp`)
- Remove test artifacts (`.pytest_cache`, `htmlcov`)
- Remove empty directories

**Step 2: Security Check**
- Verify `.env` is not tracked
- Scan for hardcoded secrets in code
- Check for committed credentials

**Step 3: Run Tests** (if applicable)
- Execute test suite
- Fix failing tests before proceeding
- Ensure 100% passing

**Step 4: Update Session State**
- Document work completed
- Note next steps
- Record any blockers or decisions
- Update `.specify/memory/session_state.md`

**Step 5: Git Status Check**
- Review uncommitted changes
- Commit or stash changes
- Write proper commit messages (feat:, fix:, docs:, etc.)

**Automated Script**: `.specify/scripts/powershell/end-session.ps1`

```powershell
.\.specify\scripts\powershell\end-session.ps1
```

### Push to GitHub Protocol

Execute **after** cleanup and **before** logging off:

**Step 1: Sync with Remote**
- Fetch latest from origin
- Check if local is behind remote
- Pull if necessary

**Step 2: Push Changes**
- Push current branch to origin
- Sync to master if applicable
- Verify push successful

**Step 3: Verify on GitHub**
- Confirm changes appear in repository
- Check CI/CD status (if workflows exist)

**Session End Checklist**:
- [ ] Cleanup script executed
- [ ] All tests passing
- [ ] No uncommitted changes
- [ ] Session state updated
- [ ] Changes pushed to GitHub
- [ ] Constitution compliance verified
- [ ] No API keys in code
- [ ] Documentation updated (if needed)

---

## Development Workflow

### Terminal Setup (REQUIRED)

**Two-Terminal Workflow:**

1. **Conversation Terminal** (Primary - GitHub Copilot CLI)
   - Purpose: Interact with Copilot, discuss code, ask questions
   - Clean history: Only conversation, no command output
   - Always visible: Keep this terminal in focus for discussions

2. **Execution Terminal** (Secondary - PowerShell/Bash)
   - Purpose: Run all commands, tests, builds, scripts
   - Shows: Test results, build output, command execution
   - Open separately: Side-by-side or on second monitor

**How to Set Up:**
```powershell
# Terminal 1 (Conversation) - Start here
cd C:\Users\lizzardkink\OneDrive\Documents\Dev\AIOCR
.\.specify\scripts\powershell\start-session.ps1
# This launches GitHub Copilot CLI for conversation

# Terminal 2 (Execution) - Open separately
cd C:\Users\lizzardkink\OneDrive\Documents\Dev\AIOCR
# Run commands here:
pytest tests/
python src/main.py
git status
# etc.
```

**Benefits:**
- ✅ Clean conversation history
- ✅ Easy to review discussions
- ✅ Command output doesn't clutter conversation
- ✅ Can scroll through conversation without logs
- ✅ Better focus on each task

### Feature Development Cycle (TDD)
1. **Spec Creation**: Write spec in `specs/[ID]-[name]/spec.md` with test strategy
2. **Plan Creation**: Write implementation plan with phases, timeline, and test cases
3. **User Approval**: Get explicit approval on spec and test approach
4. **Branch Creation**: `git checkout -b [ID]-[name]`
5. **For Each Module/Feature**:
   - Write tests first (define expected behavior)
   - Run tests → verify they fail (Red)
   - Get user approval on test expectations
   - Implement minimum code to pass tests (Green)
   - Refactor while keeping tests green
   - Commit with tests + implementation together
6. **Integration Testing**: Test module interactions
7. **Manual Testing**: Document and execute manual test procedures
8. **Documentation**: Update README and PROJECT_SUMMARY
9. **Review**: All tests passing before merge
10. **Merge**: Merge to main after all tests pass

### Commit Message Format
- `feat:` - New feature
- `fix:` - Bug fix
- `refactor:` - Code restructuring
- `docs:` - Documentation updates
- `chore:` - Maintenance tasks
- `test:` - Test additions/changes

### Testing Requirements (TDD Workflow)
1. **Write test first** - Define expected behavior
2. **Run test** - Verify it fails (Red)
3. **Get user approval** - Review test expectations
4. **Implement minimum code** - Make test pass (Green)
5. **Refactor** - Improve without breaking tests
6. **Repeat** - For each new feature/module

#### Test Coverage Requirements
- **Unit Tests**: Every module class and function
- **Integration Tests**: Module interactions and workflows
- **Manual Tests**: Camera/UI components (document procedure)
- **Stability Tests**: Long-running sessions (>30 minutes)
- **Hardware Tests**: Real USB webcam required

#### Test Organization
```
tests/
├── unit/
│   ├── test_camera.py
│   ├── test_stream.py
│   ├── test_capture.py
│   ├── test_ocr.py
│   ├── test_prompt.py
│   └── test_agent.py
├── integration/
│   ├── test_capture_to_ocr.py
│   ├── test_ocr_to_prompt.py
│   └── test_full_workflow.py
└── manual/
    └── camera_ui_test_plan.md
```

## Quality Standards

### Code Organization
```
src/
├── modules/      # Functional modules (camera, stream, capture, ocr, prompt, agent)
├── ui/          # User interface components
├── core/        # Application controller and state
└── utils/       # Shared utilities

specs/           # Feature specifications
config/          # Configuration files (YAML)
tests/           # Unit and integration tests
```

### Documentation Requirements
- Every module must have docstrings
- README must be kept up-to-date
- Specs must be complete before implementation
- API changes must be documented
- Complex algorithms require inline comments

### Performance Standards
- OCR processing: <2 seconds per frame
- Camera feed: 30 FPS (native resolution)
- AI response: <5 seconds (network dependent)
- Memory stable over 1 hour runtime
- No memory leaks in video streaming

### Scalability Standards
- Support 100+ concurrent users (initial target)
- Horizontal scaling capability (add containers/servers)
- Stateless design where possible
- Database queries optimized (indexes, connection pooling)
- Caching strategy for repeated requests
- Queue system for async processing
- Health check endpoints for load balancers
- Graceful degradation under load

## Security & Privacy

### Secrets Management (CRITICAL - SECURITY PRINCIPLE)

**What Are Secrets?**
- API keys (OpenAI, Anthropic, Azure, etc.)
- GitHub tokens (personal access tokens, workflow tokens, PATs)
- Database credentials (username, password, connection strings)
- Cloud provider credentials (Azure, AWS, GCP)
- OAuth client secrets
- Encryption keys
- Service account tokens
- Webhook secrets and signing keys
- SSH keys and deploy keys
- Any credential that grants access to resources

**Golden Rules (NON-NEGOTIABLE):**
1. ❌ **NEVER commit secrets to git** - No exceptions, ever
2. ✅ **Always use `.env` for local secrets** - Gitignored by default
3. ✅ **Use GitHub Secrets for CI/CD** - Never in workflow files
4. ✅ **Provide `.env.example`** - Template without real values
5. ✅ **Rotate secrets if exposed** - Immediately invalidate and regenerate
6. ✅ **Document required secrets** - List all needed secrets in README
7. ✅ **Validate secrets on startup** - Fail fast with clear error messages
8. ✅ **Use secret scanners** - Pre-commit hooks to catch accidental commits

**Local Development - `.env` File:**
```bash
# .env (NEVER COMMIT THIS FILE)
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GITHUB_TOKEN=ghp_...
AZURE_CONNECTION_STRING=...
```

**Environment Template - `.env.example`:**
```bash
# .env.example (SAFE TO COMMIT)
OPENAI_API_KEY=your_openai_api_key_here
ANTHROPIC_API_KEY=your_anthropic_api_key_here
GITHUB_TOKEN=your_github_token_here
AZURE_CONNECTION_STRING=your_azure_connection_string_here
```

**GitHub Actions - Use Repository Secrets:**
```yaml
# .github/workflows/deploy.yml
env:
  OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}  # ✅ Correct
  # OPENAI_API_KEY: sk-abc123  # ❌ NEVER hardcode
```

**Loading Secrets in Code:**
```python
# ✅ Correct - Load from environment
import os
from dotenv import load_dotenv

load_dotenv()  # Loads .env file
api_key = os.getenv('OPENAI_API_KEY')

if not api_key:
    raise ValueError("OPENAI_API_KEY not found in environment")
```

**Container Deployment:**
- Pass secrets as environment variables (Docker, Kubernetes)
- Use secret management services (Azure Key Vault, AWS Secrets Manager)
- Never bake secrets into container images
- Mount secrets as files or inject as env vars at runtime

**Secret Rotation Policy:**
- Rotate API keys every 90 days (or provider recommendation)
- Immediately rotate if:
  - Accidentally committed to git (even if deleted)
  - Shared in chat, email, or logs
  - Employee leaves project
  - Suspected compromise
- Document rotation procedure for each secret type

**If You Accidentally Commit a Secret:**
1. **Immediately revoke/rotate** the secret (GitHub, OpenAI, Azure, etc.)
2. Generate new secret and update `.env`
3. Remove from git history: `git filter-branch` or BFG Repo-Cleaner
4. Force push to overwrite history: `git push --force`
5. Notify team members to re-clone repository
6. Check if secret was pushed to any forks or clones
7. Review git hosting provider's security alerts
8. Document incident and lessons learned

**GitHub Token Management:**
- Use fine-grained Personal Access Tokens (PATs) with minimal scopes
- Set expiration dates (90 days maximum recommended)
- Use different tokens for different purposes (CI/CD vs local dev)
- Store in `.env` file, never in code or workflow files
- For GitHub Actions: Use repository secrets (`${{ secrets.GITHUB_TOKEN }}`)
- Revoke immediately if compromised or no longer needed

**Verification Before Commit:**
```powershell
# Always check before pushing
git status
git diff --cached  # Review staged changes
grep -r "sk-" .    # Search for API key patterns
grep -r "ghp_" .   # Search for GitHub tokens

# Check .gitignore includes .env
cat .gitignore | Select-String ".env"
```

**Prohibited Actions:**
- ❌ Committing `.env` file
- ❌ Hardcoding secrets in source code
- ❌ Storing secrets in plain text files tracked by git
- ❌ Logging secrets to console or files
- ❌ Sharing secrets via chat, email, or screenshots
- ❌ Using same secret across multiple projects/environments
- ❌ Storing secrets in CI/CD logs or artifacts

**Required Actions:**
- ✅ Add `.env` to `.gitignore` (verify it's listed)
- ✅ Provide `.env.example` template for new developers
- ✅ Use environment variables for all secrets
- ✅ Validate secrets exist on startup (fail fast)
- ✅ Use GitHub repository secrets for workflows
- ✅ Document which secrets are required in README
- ✅ Implement graceful error messages if secrets missing

### API Key Management
- Store API keys in `.env` only
- Never commit API keys to git
- Support multiple AI providers
- Graceful degradation if keys missing
- Validate keys on startup
- Clear error messages for missing/invalid keys

### Data Handling
- Captured images saved locally only (desktop) or processed in-memory (web)
- User controls when to submit to AI
- No automatic cloud uploads
- Clear data retention policy
- GDPR/privacy considerations for web service
- No PII storage without explicit consent
- OCR text never logged or persisted without consent

### API & Integration Standards
- RESTful API design (follow HTTP standards)
- OpenAPI/Swagger documentation auto-generated
- Versioned APIs (v1, v2, etc.)
- Rate limiting to prevent abuse
- API authentication (API keys, OAuth2)
- Webhook support for async operations
- CORS properly configured for web clients
- Standard error responses (JSON with error codes)

## Governance

### Constitution Authority
- This constitution supersedes all other development practices
- Changes require documentation in git commit
- Major changes require user approval
- Track amendments in version history

### Decision Making
- Technical decisions favor stability over features
- User experience trumps implementation convenience
- Modular design is non-negotiable
- Explicit approval required before AI submissions

### Conflict Resolution
- Constitution principles take precedence
- When in doubt, favor simplicity and modularity
- User control and confirmation cannot be compromised
- Stability issues block new feature development

**Version**: 1.7.0 | **Ratified**: 2025-12-03 | **Last Amended**: 2025-12-03

## Amendment History

### v1.7.0 (2025-12-03)
- **ENHANCED SECURITY**: Expanded Secrets Management section
  - Added webhook secrets, SSH keys, and deploy keys to secret types
  - Added 3 new golden rules: Document secrets, validate on startup, use scanners
  - Enhanced GitHub token management: Fine-grained PATs, expiration, minimal scopes
  - Expanded incident response: Check forks, review security alerts
  - Added pre-commit hook recommendations for secret scanning
  - Benefits: Comprehensive secret protection, automated detection, incident preparedness
  
### v1.6.0 (2025-12-03)
- **CONSOLIDATION UPDATE**: Integrated Maintenance Protocols into constitution
  - Session Start Protocol: Automated script (.specify/scripts/powershell/start-session.ps1)
  - Session End Protocol: Cleanup, tests, security checks, state updates
  - Push to GitHub Protocol: Sync, push, verify workflow
  - Session End Checklist: 8-point verification
- Consolidated maintenance_protocols.md into universal principles
- Merged session management workflows into Development Workflow section
- Removed redundant documentation files (now part of constitution)
- Constitution remains universal and project-agnostic template
- Benefits: Single source of truth, consistent workflow, easier onboarding

### v1.5.0 (2025-12-03)
- **CRITICAL SECURITY ADDITION**: Secrets Management (SECURITY PRINCIPLE)
  - Comprehensive guide on handling all types of secrets
  - Golden rules: Never commit, always use .env, rotate if exposed
  - Detailed procedures for local dev, CI/CD, and container deployment
  - Secret rotation policy and incident response
  - Verification checklist before commits
  - Prohibited and required actions clearly defined
- Enhanced API Key Management section
- Enhanced Data Handling with privacy safeguards
- Added prohibited actions: Committing .env, hardcoding secrets, logging secrets
- Benefits: Prevent security breaches, safe collaboration, compliance ready

### v1.4.0 (2025-12-03)
- **MAJOR ADDITION**: Principle XI - Portable Development (INFRASTRUCTURE PRINCIPLE)
  - No admin privileges required for entire development stack
  - Virtual environment isolates dependencies
  - Python, Git, VS Code all user-level installs
  - Quick setup: 10 minutes from clone to productive
  - Comprehensive portable setup guide included
- Added Development Environment section with setup instructions
- Enhanced Configuration Management Standards for portability
- Added prohibited patterns: Committing .env, requiring admin, hardcoding paths
- Benefits: Work anywhere, consistent setup, fast onboarding
- Documentation: `.specify/memory/portable_setup.md` (12KB guide)

### v1.3.0 (2025-12-03)
- **MAJOR ADDITION**: Principle X - Terminal Separation (WORKFLOW PRINCIPLE)
  - Separate conversation terminal from execution terminal
  - GitHub Copilot CLI in dedicated terminal (conversation only)
  - All commands/scripts run in separate terminal (execution only)
  - Keeps conversation history clean and reviewable
- Added Terminal Setup section to Development Workflow
- Added prohibition: Running commands in conversation terminal
- Benefits: Clean history, better focus, easier review

### v1.2.0 (2025-12-03)
- **MAJOR ADDITIONS**: Three new guiding principles
  - **VII. Simplicity & Pragmatism** - Simple, straightforward solutions
  - **VIII. Scalability by Design** - Design for growth from day one
  - **IX. Universal Connectivity** - Integration-first architecture
- Added Guiding Philosophy section (KISS, YAGNI, DRY, Universal Design)
- Added Scalability Standards (horizontal scaling, stateless design, queuing)
- Added API & Integration Standards (REST, OpenAPI, webhooks, OAuth2)
- Enhanced prohibited patterns (over-engineering, tight coupling, custom protocols)
- Enhanced configuration management (all endpoints configurable, validation)

### v1.1.0 (2025-12-03)
- **MAJOR CHANGE**: Added Principle III - Test-First Development (NON-NEGOTIABLE)
- Added detailed TDD workflow to Feature Development Cycle
- Added Test Coverage Requirements and test organization structure
- Added prohibition on writing production code before tests
- Renumbered subsequent principles (IV → Specification-Driven, V → Multiple Deployment, VI → Stability)
