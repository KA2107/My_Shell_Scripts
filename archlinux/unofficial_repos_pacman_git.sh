#!/usr/bin/env bash

set -x -e

sudo rm "/var/lib/pacman/sync"/*.part || true

echo

sudo rm "/var/lib/pacman/sync/nightly.db" || true

echo

set +x +e
