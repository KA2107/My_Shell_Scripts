#!/bin/bash

set -x -e

rsync -a --delete --verbose --stats --progress "rsync://rsync.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git" ".git/"

set +x +e
