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

vim:
	ln -s $(CWD)/vimrc.local $(HOME)/.vimrc

tmux:
	ln -s $(CWD)/tmux.conf $(HOME)/.tmux.conf
	ln -s $(CWD)/urlview $(HOME)/.urlview

terminfo:
	rm -rf $(HOME)/.terminfo
	ln -s $(CWD)/terminfo $(HOME)/.terminfo

tmp:
	mkdir $(CWD)/tmp

goinstall: tmp
	go get -u code.google.com/p/go.tools/cmd/godoc
	go get -u code.google.com/p/go.tools/cmd/oracle
	go get -u code.google.com/p/go.tools/cmd/goimports
	go get -u github.com/nsf/gocode
	go get -u github.com/golang/lint/golint
	go get -u github.com/kisielk/errcheck
	go get -u code.google.com/p/rog-go/exp/cmd/godef
	rm -rf $(BINDIR)/oracle $(BINDIR)/goimports $(BINDIR)/golint $(BINDIR)/errcheck $(BINDIR)/gocode $(BINDIR)/godef $(BINDIR)/gotags
	ln -s $(GOPATH)/bin/oracle $(BINDIR)
	ln -s $(GOPATH)/bin/goimports $(BINDIR)
	ln -s $(GOPATH)/bin/golint $(BINDIR)
	ln -s $(GOPATH)/bin/errcheck $(BINDIR)
	ln -s $(GOPATH)/bin/gocode $(BINDIR)
	ln -s $(GOPATH)/bin/godef $(BINDIR)

st: terminfo tmp
	mkdir -p $(CWD)/tmp/
	test -x $(CWD)/tmp/st || git clone http://git.suckless.org/st $(CWD)/tmp/st
	cd $(CWD)/tmp/st && git stash && git pull && git stash pop
	cp $(CWD)/st/config.h $(CWD)/tmp/st
	cd $(CWD)/tmp/st && git apply $(CWD)/st/st-c-no_bold_colors.patch
	$(MAKE) -C $(CWD)/tmp/st clean all
	test -x $(HOME)/bin/st || ln -s $(CWD)/tmp/st/st $(HOME)/bin/st
	test -x $(HOME)/.dir_colors || ln -s $(CWD)/dircolors.256dark $(HOME)/.dir_colors

.PHONY: xmonad vim tmux st terminfo
