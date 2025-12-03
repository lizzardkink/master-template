# Project Memory

This folder contains the core project documentation that GitHub Copilot and AI assistants use to understand the project context.

## 📋 Core Documents (Master Template Structure)

### constitution.md ⭐ UNIVERSAL TEMPLATE
**Purpose**: Universal project template - Core principles, workflows, and development standards that apply to ANY project.

**Why Universal**: This file contains NO project-specific information. It can be copied to any new project as-is.

**Contents**:
- 11 Core Principles (Non-negotiable)
- Guiding Philosophy (KISS, YAGNI, DRY, Universal Design)
- Technology Standards (adaptable)
- Development Environment (Portable setup - no admin)
- Terminal Separation Workflow
- Maintenance Protocols (Session start/end scripts)
- TDD Workflow (Test-Driven Development)
- Security & Secrets Management (comprehensive)
- Quality Standards
- Governance & Amendment Process

**Update Frequency**: Only when principles change across all projects
**Template Status**: ✅ Ready to copy to new projects

---

### vision.md 📍 PROJECT-SPECIFIC
**Purpose**: Complete vision, architecture, and roadmap for THIS specific project only.

**Why Separate**: Contains all project-specific details that make this project unique.

**Contents**:
- Executive Summary (what THIS project does)
- Core Value Proposition (why THIS project exists)
- Technical Architecture (THIS project's tech stack)
- Deployment Model (how THIS project deploys)
- User Experience Workflow (THIS project's UX)
- Success Criteria (metrics for THIS project)
- Development Phases (THIS project's roadmap)
- Risk Mitigation (THIS project's risks)

**Update Frequency**: On major direction changes
**Template Status**: ❌ Replace entirely for each new project

---

### session_state.md 🔄 SESSION TRACKER
**Purpose**: Current project status - Tracks progress, current phase, next steps, and session notes.

**Why Dynamic**: Changes every session as work progresses.

**Contents**:
- Current Status (what phase are we in?)
- Module Progress Tracker (what's done, what's pending)
- Technical Context (current file structure)
- Important Context (active principles)
- Next Steps (immediate actions)
- Session Notes (timestamped log)

**Update Frequency**: Every session end
**Template Status**: 🔄 Template structure, replace content for each project

---

### README.md 📖 THIS FILE
**Purpose**: Documentation about the .specify/memory folder itself.

**Template Status**: ✅ Universal - applies to any project

---

## 🎯 Reading Order for New Sessions

1. **constitution.md** - Understand the universal rules
2. **session_state.md** - Know where we are
3. **vision.md** - Understand the goal

## 🔄 Maintenance Protocols

- **Daily**: Update `session_state.md` at end of session
- **Weekly**: Review constitution compliance
- **Per Phase**: Update vision with progress
- **As Needed**: Amend constitution (version bump in Amendment History)

## 📌 Note for New Projects

When starting a new project:

1. **Copy** `constitution.md` AS-IS (universal template)
2. **Replace** `vision.md` with new project's vision
3. **Replace** `session_state.md` content (keep structure)
4. **Copy** this `README.md` AS-IS

## 🔧 For AI Assistants (GitHub Copilot, etc.)

**On session start**, ALWAYS read in this order:
1. `constitution.md` - Learn the rules
2. `session_state.md` - Understand current status
3. `vision.md` - Know the end goal

**On session end**, ALWAYS update:
- `session_state.md` with progress and next steps

---

**Last Updated**: 2025-12-03  
**Constitution Version**: 1.7.0  
**Template Status**: Master Template - Ready for Reuse
