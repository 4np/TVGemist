#!/usr/bin/env bash

# iblinter wrapper
iblinter() {
    # check if iblinter is installed
    if [ ! `which iblinter` ]; then
        # lazilly install iblinter
        brew install kateinoigakukun/homebrew-tap/iblinter
    fi

    `which iblinter` $@
}
