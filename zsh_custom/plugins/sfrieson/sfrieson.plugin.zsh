alias src='source ~/.zshrc'

# Go back one directory
alias b='cd ..'

# History lists your previously entered commands
alias h='history'

# Execute verbosely
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias mkdir='mkdir -pv'

# =================
# Change System Settings
# =================

# Hide/show all desktop icons (useful when presenting)
alias hide_desktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias show_desktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Hide/show hidden files in Finder
alias hide_files="defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder"
alias show_files="defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder"

# ===================
# Application Aliases
# ===================

alias chrome='open -a "Google Chrome"'
alias firefox='/Applications/Firefox.app/Contents/MacOS/firefox'

# =========
# Functions
# =========

publicip () {
    for i in $( ifconfig | grep broadcast ); do
        if echo $i | grep -e "\d"
        then
            break
        fi
    done
}
