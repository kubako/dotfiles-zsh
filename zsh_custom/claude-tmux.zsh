# Claude Code tmux helper
# Creates numbered sessions: CCT🤖, CCT🤖-2, CCT🤖-3, ...
_cct() {
  local base="CCT🤖"
  local name="$base"
  local i=1

  while tmux has-session -t "$name" 2>/dev/null; do
    i=$((i + 1))
    name="${base}-${i}"
  done

  tmux new-session -d -s "$name" "claude"
  osascript <<EOF
tell application "iTerm2"
  set ctrlWin to (create window with default profile)
  tell current session of ctrlWin
    write text "tmux -CC attach -t $name; exit"
  end tell
  delay 2
  set miniaturized of ctrlWin to true
end tell
EOF
  echo "Session '$name' created."
}

# Interactive CCT session switcher with arrow-key TUI menu
_cctlist() {
  local -a sessions
  sessions=("${(@f)$(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep '^CCT🤖')}")
  sessions=(${sessions:#})

  local count=${#sessions[@]}

  if (( count == 0 )); then
    echo "No active CCT sessions."
    return 0
  fi

  if (( count == 1 )); then
    _cctlist_focus "${sessions[1]}"
    return $?
  fi

  local selected=1
  local key

  _cctlist_cleanup() {
    printf '\e[?25h'
    printf '\e[%dB' $(( count - selected ))
    printf '\n'
  }

  trap '_cctlist_cleanup; return 130' INT TERM

  printf '\e[?25l'
  _cctlist_draw "$selected" sessions

  while true; do
    read -rsk 1 key
    case "$key" in
      $'\e')
        read -rsk 1 -t 0.05 key
        if [[ "$key" == "[" ]]; then
          read -rsk 1 -t 0.05 key
          case "$key" in
            A) (( selected > 1 )) && (( selected-- )); _cctlist_redraw "$selected" sessions "$count" ;;
            B) (( selected < count )) && (( selected++ )); _cctlist_redraw "$selected" sessions "$count" ;;
          esac
        else
          _cctlist_cleanup
          trap - INT TERM
          echo "Cancelled."
          return 0
        fi
        ;;
      q)
        _cctlist_cleanup
        trap - INT TERM
        echo "Cancelled."
        return 0
        ;;
      $'\n')
        _cctlist_cleanup
        trap - INT TERM
        _cctlist_focus "${sessions[$selected]}"
        return $?
        ;;
    esac
  done
}

_cctlist_draw() {
  local sel=$1
  local -a items=("${(@P)2}")
  local i

  echo "Select CCT session (↑↓/enter/q):"
  for i in {1..${#items[@]}}; do
    if (( i == sel )); then
      printf '  \e[7m> %s\e[0m\n' "${items[$i]}"
    else
      printf '    %s\n' "${items[$i]}"
    fi
  done
}

_cctlist_redraw() {
  local sel=$1
  local -a items=("${(@P)2}")
  local count=$3
  local i

  printf '\e[%dA' "$count"
  for (( i = 1; i <= count; i++ )); do
    printf '\r\e[K'
    if (( i == sel )); then
      printf '  \e[7m> %s\e[0m\n' "${items[$i]}"
    else
      printf '    %s\n' "${items[$i]}"
    fi
  done
}

_cctlist_focus() {
  local target="$1"
  echo "Focusing session: $target"

  osascript <<EOF
tell application "iTerm2"
  set targetName to "$target"
  set foundWindow to missing value

  repeat with w in windows
    repeat with aTab in tabs of w
      repeat with s in sessions of aTab
        try
          if name of s contains targetName then
            set foundWindow to w
            exit repeat
          end if
        end try
      end repeat
      if foundWindow is not missing value then exit repeat
    end repeat
    if foundWindow is not missing value then exit repeat
  end repeat

  if foundWindow is not missing value then
    if miniaturized of foundWindow then
      set miniaturized of foundWindow to false
    end if
    set index of foundWindow to 1
    activate
  else
    set newWin to (create window with default profile)
    tell current session of newWin
      write text "tmux -CC attach -t " & targetName & "; exit"
    end tell
    delay 2
    set miniaturized of newWin to true
  end if
end tell
EOF
}
