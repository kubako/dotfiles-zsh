alias zshconfig='idea ~/.zshrc'
alias zshreload='source ~/.zshrc'

TMUX_NEW_SESSION='"tmux -CC new-session -A -s jk"'

alias ssJakubKonasEu="ssh -A jakub.konas@jakubkonas.eu"
alias sstJakubKonasEu="ssJakubKonasEu -t $TMUX_NEW_SESSION"

alias ssTriumphBoardStage="ssh -A jakub.konas@dev1.triumphboard.com"
alias sstTriumphBoardStage="ssTriumphBoardStage -t $TMUX_NEW_SESSION"
alias ssTriumphBoardProd="ssh -A jakub.konas@web1.triumphboard.com"
alias sstTriumphBoardProd="ssTriumphBoardProd -t $TMUX_NEW_SESSION"

alias ssVsemProd="ssh -A vsem-elearning-prod@novyelearning.vsem.cz"
alias sstVsemProd="ssVsemProd -t $TMUX_NEW_SESSION"
alias ssVsemStage="ssh -A vsem-elearning-stage@stage.vsem-elearning.dev.imatic.cz"
alias sstVsemStage="ssVsemStage -t $TMUX_NEW_SESSION"

# SolidPixels - cd
alias spcddev="cd ~/jobs/solidpixels/devstack/solidpixels/"
alias spcdsites="cd ~/jobs/solidpixels/devstack/solidpixels/htdocs/projects/solidapp/document_root/sites/"

# SolidPixels - git ssh helpers
alias spgitfix="dce -u 0 php bash -c 'chown $CURRENT_UID /ssh-auth.sock && ls -l /ssh-auth.sock'; spgittest"
alias spgittest="dce php bash -c 'id && ssh git@projects.breezy.cz|head -n 1'"

# SolidPixels - dev stack manipulation
alias spdevup="spcddev && (docker-sync start || (echo 'Retrying docker-sync' && sleep 2 && docker-sync start)) && dcupd && sleep 2 && spgitfix"
alias spdevdn="spcddev && (dcdn && docker-sync stop)"
alias spdevrestart="spdevdn;spdevup"

# Claude Code
alias cc="claude"
alias cct='_cct'
alias cctlist='_cctlist'
alias ccx="claude --dangerously-skip-permissions"
alias ccd='_ccd'