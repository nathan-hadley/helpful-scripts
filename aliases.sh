# General aliases
alias edit="cursor ~/.zshrc"
alias save="source ~/.zshrc"

# Git helpers
commitpush(){
  git add .
  git commit -m "$1"
  git push
}

commit(){
  git commit -m "$1"
}

alias gs="git status"
alias add="git add -p"
alias co="git checkout"
alias cr="git !sh -c 'git checkout -b CR origin/$1' -"
alias br="git branch"
alias pull="git pull"
alias push="git push"
alias stash="git stash"
alias unstash="git stash apply"
alias delete="git branch --delete"
alias clean="git branch --merged | grep -v "^\*\\|main" | xargs -n 1 git branch -d"

# GitHub review & weekly report helpers
alias weekly="~/dev/helpful-scripts/gh-weekly-prs.sh"
alias reviews='gh search prs --review-requested=@me --state=open --json author,url --jq ".[] | \"\\(.author.login): \\(.url)\""'

# Docker
alias prune-docker="docker system prune -a -f --volumes"
alias dc="docker compose"

# Node / JS
alias rmrf='rm -rf .parcel-cache dist node_modules'

# Android
alias scrcpy='scrcpy --serial R5CX81AD2CP' 