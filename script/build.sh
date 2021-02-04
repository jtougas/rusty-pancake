#!/bin/bash

set -e

this_dir=$(dirname "$(readlink -f "$0")")
dist="$this_dir/../dist/"

copy_from_image_to_dist() {

    image_name=$1
    source_path=$2
    dest_path="$dist/$3"
    mkdir -p "$dist"

    container_id=$(docker create "$image_name")
    docker cp "$container_id":"$source_path" "$dest_path"
    docker rm "$container_id" > /dev/null
}

build() {

    image=$1
    dockerfile=$2
    image_binary_path=$3
    dist_binary_name=$4

    docker build -f "$this_dir/$dockerfile" -t "$image" "$this_dir/.."
    copy_from_image_to_dist "$image" "$image_binary_path" "$dist_binary_name"
}

build \
    "rusty-pancake/build-macos" \
    "Dockerfile.macos" \
    "/build/target/x86_64-apple-darwin/release/rusty-pancake" \
    "rusty-pancake-x86_64-apple-darwin"

build \
    "rusty-pancake/build-win" \
    "Dockerfile.win" \
    "/build/target/x86_64-pc-windows-gnu/release/rusty-pancake.exe" \
    "rusty-pancake-x86_64-pc-windows-gnu.exe"

build \
    "rusty-pancake/build-linux" \
    "Dockerfile.linux" \
    "/build/target/release/rusty-pancake" \
    "rusty-pancake-x86_64-unknown-linux-gnu"
