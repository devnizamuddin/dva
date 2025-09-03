#!/bin/bash


function show_commit_history() {
  echo "Showing the commit history..."
  # git log --pretty=oneline
  git log --oneline --graph --decorate \
  --pretty=format:"%C(yellow)%ad%Creset %C(cyan)$(git branch --contains | grep -v 'HEAD' | sed 's/^[[:space:]]*//')%Creset %C(green)* %an%n%n%Creset%s%n%n" --date=format:'%Y-%m-%d %I:%M %p'
}