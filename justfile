#!/usr/bin/env just --justfile

default: show_receipts

set shell := ["bash", "-uc"]
set dotenv-load := true

show_receipts:
    just --list

show_system_info:
    @echo "=================================="
    @echo "os : {{ os() }}"
    @echo "arch: {{ arch() }}"
    @echo "justfile dir: {{ justfile_directory() }}"
    @echo "invocation dir: {{ invocation_directory() }}"
    @echo "running dir: `pwd -P`"
    @echo "=================================="

cleanup-tests:
    rm -rf ~/.asdf/installs/asdf-test-python*
    rm -rf ~/.asdf/downloads/asdf-test-python*
    rm -rf ~/.asdf/plugins/asdf-test-python*

test:
    just cleanup-tests
    asdf plugin test python https://github.com/olofvndrhr/asdf-python.git
