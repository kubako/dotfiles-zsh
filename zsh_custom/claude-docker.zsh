# Claude Code Docker helper
# Builds/rebuilds image only when local claude version changes
_ccd() {
  local current_version
  current_version=$(claude --version 2>/dev/null | head -1)
  if [ -z "$current_version" ]; then
    echo "Error: claude not found on host"
    return 1
  fi

  local image_name="claude-code:local"
  local stored_version
  stored_version=$(docker inspect --format '{{index .Config.Labels "claude.version"}}' "$image_name" 2>/dev/null)

  if [ "$current_version" != "$stored_version" ]; then
    echo "Building claude-code image (version: $current_version)..."
    docker build --build-arg CLAUDE_VERSION="$current_version" \
      -t "$image_name" \
      /Users/jakub.konas/Documents/apps/shell/docker/claude-code/
  fi

  docker run --rm -it \
    -e ANTHROPIC_API_KEY \
    -v "$(pwd)":/workspace \
    -v "$HOME/.claude":/home/claude/.claude \
    -v "$HOME/.claude.json":/home/claude/.claude.json \
    -w /workspace \
    "$image_name"
}
