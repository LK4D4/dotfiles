CWD=$(shell pwd)
BINDIR=$(HOME)/bin
export GOPATH=$(CWD)/tmp

all: xmonad vim tmux st

.IGNORE:
xmonad:
	mkdir -p $(HOME)/.xmonad
	ln -s $(CWD)/xmonad/xmonad.hs $(HOME)/.xmonad/xmonad.hs
	ln -s $(CWD)/xmonad/xmobarrc $(HOME)/.xmobarrc
	ln -s $(CWD)/xmonad/xserverrc $(HOME)/.xserverrc
	ln -s $(CWD)/xmonad/xinitrc $(HOME)/.xinitrc

docker:
	docker build -t dev .

dockerenv: vim zsh tmux

vim: goinstall
	ln -s $(CWD)/vimrc.local $(HOME)/.vimrc

zsh: dircolors
	ln -s $(CWD)/zshrc $(HOME)/.zshrc
	ln -s $(CWD)/git-flow-completion.zsh $(HOME)/.git-flow-completion.zsh

tmux:
	ln -s $(CWD)/tmux.conf $(HOME)/.tmux.conf
	ln -s $(CWD)/urlview $(HOME)/.urlview

terminfo:
	rm -rf $(HOME)/.terminfo
	ln -s $(CWD)/terminfo $(HOME)/.terminfo

tmp:
	mkdir $(CWD)/tmp

PACKAGES = golang.org/x/tools/cmd/oracle \
	golang.org/x/tools/cmd/goimports \
	github.com/golang/lint/golint \
	github.com/kisielk/errcheck \
	github.com/nsf/gocode \
	github.com/rogpeppe/godef \
	github.com/jstemmer/gotags \
	github.com/LK4D4/gistit \
	golang.org/x/tools/cmd/gorename \
	github.com/monochromegane/the_platinum_searcher/cmd/pt \
	github.com/josharian/impl

goinstall: tmp
	$(foreach pkg,$(PACKAGES),go get -u $(pkg);)
	$(foreach pkg,$(notdir $(PACKAGES)),rm -rf $(BINDIR)/$(pkg) && ln -s $(GOPATH)/bin/$(pkg) $(BINDIR)/$(pkg);)

dircolors:
	test -x $(HOME)/.dir_colors || ln -s $(CWD)/dircolors.256dark $(HOME)/.dir_colors

st: terminfo tmp dircolors
	rm -rf $(CWD)/tmp/st
	git clone http://git.suckless.org/st $(CWD)/tmp/st
	cp $(CWD)/st/config.h $(CWD)/tmp/st
	$(MAKE) -C $(CWD)/tmp/st clean all
	test -x $(HOME)/bin/st || ln -s $(CWD)/tmp/st/st $(HOME)/bin/st

.PHONY: xmonad vim tmux st terminfo
