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
- `docker/claude-code/` — Dockerfile for containerized Claude Code
- `gateway`, `idea` — JetBrains Toolbox launcher scripts (auto-generated)
- `direnv` — direnv binary
- `setLocalDevIp.sh` — loopback alias for Docker/Xdebug

## Git

- Nepoužívej v commit messages patičku `Co-Authored-By` ani jiné zmínky o Claude Code

## Conventions

- Shell scripts use `zsh` unless portability requires `bash`
- ZSH custom files use `.zsh` extension and are auto-sourced by OMZ
- Helper functions are prefixed with `_` (e.g. `_cct`, `_ccd`)
- Aliases use camelCase (e.g. `ssTriumphBoardProd`, `spcddev`)
- Keep each concern in a separate `.zsh` file in `zsh_custom/`
