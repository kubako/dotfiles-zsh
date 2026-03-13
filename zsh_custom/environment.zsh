# docker-sync executable into the path
if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

export PATH="$HOME/Documents/apps/shell:$PATH"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode auto      # update automatically without asking

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# add ssh keys
ssh-add --apple-use-keychain  ~/.ssh/id_rsa
ssh-add --apple-use-keychain  ~/.ssh/solidpixels

#source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Enable iTerm TMUX shell integration
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
# Enable iTerm shell integration
source ~/.iterm2_shell_integration.zsh
# Enable direnv (for solidpixels devstack, installation https://direnv.net/docs/installation.html )
eval "$(direnv hook zsh)"
