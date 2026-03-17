# gt - quick directory navigation
# Usage: gt <alias> (use tab completion to see available targets)

_gt() {
  local websites_base=~/jobs/solidpixels/devstack2/htdocs/projects/solidapp/document_root/sites

  case "$1" in
    s|stack)
      cd ~/jobs/solidpixels/stack
      ;;
    w|websites)
      cd "$websites_base"
      ;;
    d|devstack2)
      cd ~/jobs/solidpixels/devstack2
      ;;
    a|applogs)
      local expanded_base="${websites_base/#\~/$HOME}"
      if [[ "$PWD" != "$expanded_base"/* ]]; then
        echo "Error: Nejsi v podadresáři websites ($websites_base)" >&2
        return 1
      fi
      local relative="${PWD#$expanded_base/}"
      local site_name="${relative%%/*}"
      cd "$expanded_base/$site_name/temp/logs"
      ;;
    *)
      echo "Usage: gt <alias>"
      echo ""
      echo "Available targets:"
      echo "  (s)tack      ~/jobs/solidpixels/stack"
      echo "  (w)ebsites   ~/jobs/solidpixels/devstack2/.../sites"
      echo "  (d)evstack2  ~/jobs/solidpixels/devstack2"
      echo "  (a)pplogs    <current_site>/temp/logs"
      return 1
      ;;
  esac
}

_gt_completion() {
  local -a targets
  targets=(
    'stack:~/jobs/solidpixels/stack'
    'websites:~/jobs/solidpixels/devstack2/.../sites'
    'devstack2:~/jobs/solidpixels/devstack2'
    'applogs:<current_site>/temp/logs'
  )
  _describe 'target' targets
}

compdef _gt_completion _gt

alias gt='_gt'
