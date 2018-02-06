#!/usr/bin/env bash

# swiftlint wrapper
swiftlint() {
    # check if swiftlint is installed
    if [ ! `which swiftlint` ]; then
      # lazilly install swiftlint
      set -e

      local SWIFTLINT_PKG_PATH="/tmp/SwiftLint.pkg"
      local SWIFTLINT_PKG_URL="https://github.com/realm/SwiftLint/releases/download/0.24.2/SwiftLint.pkg"

      wget --output-document=$SWIFTLINT_PKG_PATH $SWIFTLINT_PKG_URL

      # check if the precompiled .pkg downloaded successfully
      if [ -f $SWIFTLINT_PKG_PATH ]; then
        # install the precompiled .pkg
        sudo installer -pkg $SWIFTLINT_PKG_PATH -target /
      else
        # compile from source
        git clone https://github.com/realm/SwiftLint.git /tmp/SwiftLint &&
        cd /tmp/SwiftLint &&
        git submodule update --init --recursive &&
        sudo make install
      fi
    fi

    # call swiftlint
    `which swiftlint` $@
}
