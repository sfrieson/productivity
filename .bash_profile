publicip () {
  for i in $( ifconfig | grep broadcast ); do
    if echo $i | grep -e "\d"
    then
      break
    fi
  done
}

# ============
# Git
# ============

alias current_branch='git rev-parse --abbrev-ref HEAD'
alias gs='git status'
alias gco='git checkout'
# https://stackoverflow.com/questions/9869227/git-autocomplete-in-bash-aliases#24665529
__git_complete gco _git_checkout
alias ga='git add'
alias gd='git diff'
alias gcm='git commit -m'
alias gamend='git commit --amend'
alias gammend='git commit --amend'
# git merge master
alias gmm='git fetch origin master && git merge origin/master -m "  Merges master"'
alias gbg='git branch | grep'
# git checkout grepped branch
gcog () {
  gco $(gbg $1)
}
gpo () {
  git push --set-upstream origin "$(current_branch)"
}
# git merge into
gmi () {
  SOURCE_BRANCH=$(current_branch)
  gco $1
  git pull $SOURCE_BRANCH
  git merge --no-edit $SOURCE_BRANCH
  if [ $? != "0" ];
  then
    git status
    echo "There are merge conflicts between $(current_branch) and $SOURCE_BRANCH"
  fi
}
# git add and commit with message
gacm () {
  let "slice_to = ${#@} - 1"
  git add "${@:1:$slice_to}" && git commit -m "${@: -1}"
}
