#!/bin/bash

# Function to detect if the package is installed
function npm_package_is_installed {
    if npm list --depth 0 --parseable true | grep "${1}$"; then
        return 1
    else
        return 0
    fi
}

# First make sure typings is installed
if ! type typings &> /dev/null ; then
    # Check if it is in repo
    if ! npm_package_is_installed typings ; then
        info "typings not installed, trying to install it through npm"

        sudo npm install -g --silent typings
        typings_command="typings"
    else
        info "typings is available locally"
        debug "typings version: $(node ./node_modules/.bin/typings --version)"
        typings_command="node ./node_modules/.bin/typings"
    fi
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
