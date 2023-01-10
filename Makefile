SHELL = /bin/bash

prefix ?= /usr/local
bindir ?= $(prefix)/bin
libdir ?= $(prefix)/lib

REPODIR = $(shell pwd)
BUILDDIR = $(REPODIR)/.build
EXECUTABLE = scrscr

.PHONY: build
build:
	swift build --configuration release --disable-sandbox --scratch-path "$(BUILDDIR)"

.PHONY: install
install: build
	install -d "$(bindir)"
	install "$(BUILDDIR)/release/$(EXECUTABLE)" "$(bindir)"

.PHONY: uninstall
uninstall:
	rm -rf "$(bindir)/$(EXECUTABLE)"

.PHONY: clean
clean:
	rm -rf $(BUILDDIR)
