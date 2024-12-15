# added by Webi for pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# start tnr setup
. /Users/avy/.thunder/setup.sh
# end tnr setup
. "$HOME/.cargo/env"
alias config='/usr/bin/git --git-dir=/Users/avy/.cfg/ --work-tree=/Users/avy'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
