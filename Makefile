CWD=$(shell pwd)
BINDIR=$(HOME)/bin

all: vim zsh tmux st dwm

vim: goinstall rls
	mkdir -p $(HOME)/.config/nvim
	test -L $(HOME)/.vimrc || ln -s $(CWD)/vimrc $(HOME)/.vimrc
	test -L $(HOME)/.config/nvim/init.vim || ln -s $(CWD)/vimrc $(HOME)/.config/nvim/init.vim

rg:
	rm -rf $(CWD)/tmp/ripgrep
	git clone https://github.com/BurntSushi/ripgrep $(CWD)/tmp/ripgrep
	cd $(CWD)/tmp/ripgrep && cargo build --release
	test -L $(HOME)/bin/rg || ln -s $(CWD)/tmp/ripgrep/target/release/rg $(HOME)/bin/rg

rls:
	rustup component add rls-preview rust-analysis rust-src

rust:
	curl https://sh.rustup.rs -sSf | sh

zsh: dircolors
	ln -s $(CWD)/zshrc $(HOME)/.zshrc

tmux:
	ln -s $(CWD)/tmux.conf $(HOME)/.tmux.conf
	ln -s $(CWD)/urlview $(HOME)/.urlview

terminfo:
	rm -rf $(HOME)/.terminfo
	ln -s $(CWD)/terminfo $(HOME)/.terminfo

conky: skb
	rm -rf $(HOME)/.conkyrc
	ln -s $(CWD)/conkyrc $(HOME)/.conkyrc

git: 
	rm -rf $(HOME)/.gitconfig
	ln -s $(CWD)/gitconfig $(HOME)/.gitconfig

tmp:
	mkdir $(CWD)/tmp

PACKAGES = golang.org/x/tools/cmd/goimports \
	github.com/mdempsky/gocode \
	github.com/rogpeppe/godef \
	golang.org/x/tools/cmd/gorename \
	github.com/google/pprof \
	golang.org/x/tools/cmd/guru


goinstall:
	$(foreach pkg,$(PACKAGES),go get -u $(pkg);)
	$(foreach pkg,$(notdir $(PACKAGES)),rm -rf $(BINDIR)/$(pkg) && ln -s $(shell go env GOPATH)/bin/$(pkg) $(BINDIR)/$(pkg);)

dircolors:
	test -L $(HOME)/.dir_colors || ln -s $(CWD)/dircolors.256dark $(HOME)/.dir_colors

st: terminfo tmp dircolors
	rm -rf $(CWD)/tmp/st
	git clone http://git.suckless.org/st $(CWD)/tmp/st
	cp $(CWD)/st/config.h $(CWD)/tmp/st
	cd $(CWD)/tmp/st && git apply --ignore-space-change --ignore-whitespace $(CWD)/st/no_bold.patch
	cd $(CWD)/tmp/st && git apply --ignore-space-change --ignore-whitespace $(CWD)/st/extpipe.patch
	$(MAKE) -C $(CWD)/tmp/st all
	test -L $(HOME)/bin/st || ln -s $(CWD)/tmp/st/st $(HOME)/bin/st

dwm: tmp conky
	rm -rf $(CWD)/tmp/dwm
	git clone http://git.suckless.org/dwm $(CWD)/tmp/dwm
	cp $(CWD)/dwm/config.h $(CWD)/tmp/dwm
	cd $(CWD)/tmp/dwm && git apply --ignore-space-change --ignore-whitespace $(CWD)/dwm/dwm-systray.diff
	$(MAKE) -C $(CWD)/tmp/dwm all
	test -L $(HOME)/bin/dwm || ln -s $(CWD)/tmp/dwm/dwm $(HOME)/bin/dwm
	test -L $(HOME)/.xserverrc || ln -s $(CWD)/xserverrc $(HOME)/.xserverrc
	test -L $(HOME)/.xinitrc || ln -s $(CWD)/xinitrc $(HOME)/.xinitrc

skb:
	rm -rf $(CWD)/tmp/skb
	git clone https://github.com/polachok/skb.git $(CWD)/tmp/skb
	cd $(CWD)/tmp/skb
	$(MAKE) -C $(CWD)/tmp/skb
	test -L $(HOME)/bin/skb || ln -s $(CWD)/tmp/skb/skb $(HOME)/bin/skb

.PHONY: st terminfo dwm
