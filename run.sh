#!/bin/bash

if ! type typings &> /dev/null ; then
    sudo npm install -g --silent typings
    typings_command="typings"
else
    # typings is available globally
    info "typings is available"
    debug "typings version: $(typings --version)"
    typings_command="typings"
fi

# Install the typings
set +e
$typings_command install
result="$?"
set -e

# Fail if it is not a success or warning
if [[ $result -ne 0 && $result -ne 6 ]]; then
    warn "$result"
    fail "typings command failed"
else
    success "finished $typings_command"
fi
