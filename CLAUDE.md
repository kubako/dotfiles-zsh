# Shell - ZSH customization for macOS

Oh My Zsh (`omz`) customization project for macOS. Contains custom ZSH configuration files, plugins, aliases, helper scripts, and Docker tooling.

## Project structure

- `zsh_custom/` — OMZ custom directory (sourced via `$ZSH_CUSTOM`)
  - `aliases.zsh` — shell aliases (SSH, project shortcuts, Claude Code)
  - `environment.zsh` — env vars, PATH, theme, ssh-agent, integrations (iTerm, direnv)
  - `plugins.zsh` — OMZ plugin list
  - `claude-tmux.zsh` — `cct`/`cctlist` helpers for Claude Code tmux sessions in iTerm2
  - `claude-docker.zsh` — `ccd` helper to run Claude Code in Docker
  - `plugins/` — third-party plugins (e.g. zsh-autosuggestions, cloned repos)
- `docs/` — project documentation (conventions, guides)
- `docker/claude-code/` — Dockerfile for containerized Claude Code
- `gateway`, `idea` — JetBrains Toolbox launcher scripts (auto-generated)
- `direnv` — direnv binary
- `setLocalDevIp.sh` — loopback alias for Docker/Xdebug

## Git

- Never include `Co-Authored-By` or any Claude Code mentions in commit messages

## Conventions

- Shell scripts use `zsh` unless portability requires `bash`
- ZSH custom files use `.zsh` extension and are auto-sourced by OMZ
- Helper functions are prefixed with `_` (e.g. `_cct`, `_ccd`)
- Aliases use camelCase (e.g. `ssTriumphBoardProd`, `spcddev`)
- Keep each concern in a separate `.zsh` file in `zsh_custom/`

## Language

- All CLAUDE.md content, code comments, and descriptions must be in English

## Post-plan workflow

After completing a plan implementation, always follow these steps:

1. **Test** — Evaluate how to test the changes (terminal/subagent, claude-in-chrome, MCP tools, etc.). Consider side-effects (cwd changes, disk writes, network calls). Use AskUserQuestion to propose testing methods and get approval before running any tests. Testing is a mandatory part of every plan — always include it in the verification section.

2. **Commit & push** — Use AskUserQuestion to ask whether to commit and push. Include the proposed commit message in the question so the user can approve or modify it.
