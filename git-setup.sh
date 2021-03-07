#!/bin/sh

git config --global user.name 'Alex Henrie'
git config --global core.editor nano
git config --global fetch.prune true
git config --global format.pretty fuller
git config --global pull.rebase true
git config --global rebase.autoStash true
git config --global rebase.autoSquash true
git config --global alias.graph 'log --graph --abbrev-commit --pretty=oneline'
git config --global alias.pull-reset '!git fetch && git reset --hard @{u}'
git config --global alias.recommit 'commit -a --amend --reset-author'
git config --global alias.redate 'rebase -i -x "git commit --amend --date=now --no-edit"'
git config --global alias.send-slow 'send-email --cc-cmd "sh -c \"sleep 20\""'
git config --global sendemail.smtpencryption tls
git config --global sendemail.smtpserver smtp.gmail.com
git config --global sendemail.smtpuser alexhenrie24@gmail.com
git config --global sendemail.smtpserverport 587
