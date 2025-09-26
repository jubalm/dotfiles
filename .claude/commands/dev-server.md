---
allowed-tools: Bash(npm:*), Bash(yarn:*), Bash(python:*), Bash(cargo:*), Bash(go:*), Bash(php:*), Bash(ruby:*), Bash(lsof:*), Bash(ps:*), Read, Glob
argument-hint: [dev-instructions]
description: Start development server in background with intelligent project detection
---

# Development Server Background Process Management

Start development server in background with intelligent project detection and process monitoring.

## Variables

- **DEV_INSTRUCTIONS**: `$ARGUMENTS` or "start dev server" (default)
  - Accepts natural language instructions for server operations, port preferences, and environment configuration

## Instructions

- **Project Detection**: Identify project type from manifest files (package.json, requirements.txt, Cargo.toml, go.mod, composer.json, Gemfile)
- **Command Mapping**: Map project types to appropriate dev server commands (npm run dev, python manage.py runserver, cargo run, go run, php -S, rails server)
- **Natural Language Parsing**: Extract port preferences ("port 8080"), environment settings ("production mode"), and build configurations ("watch mode")
- **Process Conflict Detection**: Check for existing processes on target ports using lsof before starting
- **Background Execution**: Use run_in_background parameter to prevent blocking Claude's workflow
- **Startup Monitoring**: Monitor initial 3-5 seconds for immediate failures before confirming success
- **Port Resolution**: Default to standard ports per project type (3000 for React, 8000 for Django, 4000 for Rails, etc.)
- **Environment Safety**: Never expose sensitive configuration unless explicitly requested

## Workflow

1. **Project Detection**: Use Glob and Read tools to identify project type from manifest files
2. **Instruction Analysis**: Parse DEV_INSTRUCTIONS for specific server requirements, ports, and configuration
3. **Process Check**: Run lsof commands to detect existing processes on target ports
4. **Server Command Selection**: Choose appropriate dev server command based on project type and instructions
5. **Background Execution**: Start server using run_in_background, monitor initial output for 3-5 seconds
6. **Status Verification**: Confirm server startup success and determine final access URL

## Reporting

Confirm server startup with URL and process ID. Report any port conflicts or startup failures.