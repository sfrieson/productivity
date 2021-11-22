alias gacm="git add -A && git commit -m"
alias gs="git status -s"
alias gcm="git commit -m"
alias gamend="echo 'use gc! or gca!' && git commit --amend"
alias gammend="echo 'use gc! or gca!' && git commit --amend"
alias gmm='git fetch origin $(git_main_branch) && git merge origin/"$(git_main_branch)" --no-edit'
alias gbg='git branch | grep'
alias gpo='git push --set-upstream origin $(git_current_branch)'
alias gl='git log --oneline'

### functions

# checkout grepped branch
gcog () {
    gco $(gbg $1)
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
