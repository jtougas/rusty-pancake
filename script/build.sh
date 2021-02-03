#!/bin/bash

PATH="$OSXCROSS_HOME/target/bin:$PATH" \
cargo build --target x86_64-apple-darwin
