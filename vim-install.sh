rm -rf ~/.vim.*
rm -rf ~/.vimrc*
cp vimrc.before.local ~/.vimrc.before.local
cp vimrc.local ~/.vimrc.local
cp vimrc.bundles.local ~/.vimrc.bundles.local
curl https://raw.githubusercontent.com/spf13/spf13-vim/3.0/bootstrap.sh | bash
~/.vim/bundle/YouCompleteMe/install.py --clang-completer --gocode-completer --racer-completer --tern-completer

cp ycm_extra_conf.py ~/.ycm_extra_conf.py
chown $USER:$USER ~/.ycm_extra_conf.py
cp tern.config ~/.tern.config
chown $USER:$USER ~/.tern.config
