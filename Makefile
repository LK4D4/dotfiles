CWD=$(shell pwd)
BINDIR=$(HOME)/bin
export GOPATH=$(CWD)/tmp

all: vim zsh tmux st dwm

vim: goinstall
	ln -s $(CWD)/vimrc.local $(HOME)/.vimrc

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

tmp:
	mkdir $(CWD)/tmp

PACKAGES = golang.org/x/tools/cmd/goimports \
	github.com/mdempsky/gocode \
	github.com/rogpeppe/godef \
	github.com/LK4D4/gistit \
	golang.org/x/tools/cmd/gorename \
	github.com/monochromegane/the_platinum_searcher/cmd/pt \
	github.com/josharian/impl \
	golang.org/x/tools/cmd/guru \
	github.com/gordonklaus/ineffassign \
	github.com/golang/lint/golint \
	github.com/kisielk/errcheck \
	github.com/mdempsky/unconvert \
	honnef.co/go/staticcheck/cmd/staticcheck \
	honnef.co/go/unused/cmd/unused \
	honnef.co/go/simple/cmd/gosimple


goinstall: tmp
	$(foreach pkg,$(PACKAGES),go get -u $(pkg);)
	$(foreach pkg,$(notdir $(PACKAGES)),rm -rf $(BINDIR)/$(pkg) && ln -s $(GOPATH)/bin/$(pkg) $(BINDIR)/$(pkg);)

dircolors:
	test -x $(HOME)/.dir_colors || ln -s $(CWD)/dircolors.256dark $(HOME)/.dir_colors

st: terminfo tmp dircolors
	rm -rf $(CWD)/tmp/st
	git clone http://git.suckless.org/st $(CWD)/tmp/st
	cp $(CWD)/st/config.h $(CWD)/tmp/st
	cd $(CWD)/tmp/st && git apply --ignore-space-change --ignore-whitespace $(CWD)/st/no_bold.patch
	$(MAKE) -C $(CWD)/tmp/st all
	test -L $(HOME)/bin/st || ln -s $(CWD)/tmp/st/st $(HOME)/bin/st

dwm: tmp conky
	rm -rf $(CWD)/tmp/dwm
	git clone http://git.suckless.org/dwm $(CWD)/tmp/dwm
	cp $(CWD)/dwm/config.h $(CWD)/tmp/dwm
	cd $(CWD)/tmp/dwm
	$(MAKE) -C $(CWD)/tmp/dwm all
	test -L $(HOME)/bin/dwm || ln -s $(CWD)/tmp/dwm/dwm $(HOME)/bin/dwm
	test -L $(HOME)/.xserverrc || ln -s $(CWD)/xserverrc $(HOME)/.xserverrc
	test -L $(HOME)/.xinitrc || ln -s $(CWD)/xinitrc $(HOME)/.xinitrc

skb:
	rm -rf $(CWD)/tmp/skb
	git clone https://github.com/polachok/skb.git $(CWD)/tmp/skb
	cp $(CWD)/skb/config.h $(CWD)/tmp/skb
	cd $(CWD)/tmp/skb
	$(MAKE) -C $(CWD)/tmp/skb
	test -L $(HOME)/bin/skb || ln -s $(CWD)/tmp/skb/skb $(HOME)/bin/skb

.PHONY: st terminfo dwm
