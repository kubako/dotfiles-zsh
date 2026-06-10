# Claude Code remote sandbox helper
# iTerm control-mode attach to a cc-runner sandbox on vps-ai. If the sandbox is
# not running, start it first via the host's cc-run; with --rc, also start a
# Remote Control window (visible in claude.ai/code + mobile) and still attach
# locally. TAB-completes the sandboxes currently running on the host.
#
#   ccvps <sandbox>        attach (start it first if it is not running)
#   ccvps                  if exactly one sandbox is running, attach to it
#   ccvps <sandbox> --rc   start/ensure Remote Control, then attach locally
#
# Autostart calls cc-run over a LOGIN shell (`bash -lc`) so it runs the deployed
# cc-run on the dev user's login PATH (/opt/ai-stack/cc-runner/bin), not the
# stale /usr/local/bin/cc-run that shadows it for non-interactive ssh. A cold
# start needs the sandbox short-name to equal a repo under /srv/repos (cc-run
# derives the session name from the repo basename).
#
# A grouped session (-s iterm -t main) gives iTerm its own size/active-window
# while sharing main's windows, so it won't fight other attach clients. Detach
# (gateway tab / `tmux detach`) leaves main - claude and the rc window - running.
#
# Speed: ~/.ssh/config defines ControlMaster/ControlPersist for vps-ai, so the
# attach, the cc-run call and completion's listing share one SSH connection.

# Echo short names (cc- stripped) of cc-* sandboxes running on $1 (host alias).
_ccvps_running() {
  local -a names
  names=(${(f)"$(ssh -o BatchMode=yes -o ConnectTimeout=4 $1 \
    'docker ps --filter name=cc- --format "{{.Names}}"' 2>/dev/null)"})
  (( $#names )) && print -l -- ${names#cc-}
}

ccvps() {
  emulate -L zsh
  local host=vps-ai
  local rc="" name="" a
  for a in "$@"; do
    case $a in
      --rc) rc=1 ;;
      *)    name="${a#cc-}" ;;
    esac
  done

  local -a running
  running=(${(f)"$(_ccvps_running $host)"})

  if [[ -z $name ]]; then
    if (( ${#running} == 1 )); then
      name=$running[1]
    else
      print -u2 "usage: ccvps [--rc] <sandbox>"
      (( ${#running} )) && print -u2 "running: ${running}"
      return 1
    fi
  fi

  # Ensure the sandbox (and, with --rc, the Remote Control window) is up.
  if [[ -n $rc ]]; then
    ssh $host "bash -lc 'cc-run ${name} --rc'" || {
      print -u2 "ccvps: 'cc-run ${name} --rc' failed on ${host}"; return 1
    }
  elif (( ! ${running[(Ie)$name]} )); then
    # Not running: start it. cc-run builds the container + main session (claude)
    # synchronously; its final interactive attach then aborts here (no TTY),
    # leaving the stack up. Swallow that expected noise unless the start failed.
    local out
    out=$(ssh $host "bash -lc 'cc-run ${name}'" 2>&1 </dev/null)
    running=(${(f)"$(_ccvps_running $host)"})
    if (( ! ${running[(Ie)$name]} )); then
      print -u2 "ccvps: failed to start '${name}' on ${host}"
      print -u2 -- "$out"
      return 1
    fi
  fi

  ssh -t $host \
    "docker exec -it -e TERM=${TERM:-xterm-256color} cc-${name} tmux -CC new-session -A -s iterm -t main"
}

# TAB completion: short names of cc-* containers running on vps-ai.
_ccvps_complete() { compadd -- ${(f)"$(_ccvps_running vps-ai)"} }
(( $+functions[compdef] )) && compdef _ccvps_complete ccvps