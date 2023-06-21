replaced () {
    echo "$1 was replaced. Use: \n$2 ${@:3}"
    $(exit 1)
}
alias gacm="replaced gacm gcam"
alias gs="git status -s"
alias gcm="git commit -m"
alias gamend="echo 'use gc! or gca!' && git commit --amend"
alias gammend="echo 'use gc! or gca!' && git commit --amend"
alias gmm='git fetch origin $(git_main_branch) && git merge origin/"$(git_main_branch)" --no-edit'
alias gbg='git branch | grep'
alias gpo='git push --set-upstream origin $(git_current_branch)'
alias gl='git log --oneline'
alias gmc='git merge --continue'
alias gcob='git checkout -b'
alias gcog='replaced gcog gswg'
alias gbl='git branch --list'

### functions

# switch grepped branch
gswg () {
    gsw $(gbg $1)
}

# merge current into
gmi () {
    SOURCE_BRANCH=$(git_current_branch)
    git pull
    gco $1
    git merge --no-edit $SOURCE_BRANCH
    if [ $? -neq 0 ]; then
        git status --short
        echo "There are merge conflicts between $(git_current_branch) and $SOURCE_BRANCH"
    fi
}

# force delete branches that have been removed from remote
gbclean () {
    git fetch --prune
    # using force delete -D because we use squash commits, which don't work with -d
    git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -D
}