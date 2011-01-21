#!/bin/sh

set -x

sudo rm /var/lib/pacman/sync/*.part
echo

sudo rm /var/lib/pacman/sync/nightly.db
echo

# sudo aria2c --dir=/var/lib/pacman/sync/ --out=radeon.db http://spiralinear.org/perry3d/x86_64/radeon.db.tar.gz
# echo

sudo aria2c --dir=/var/lib/pacman/sync/ --out=nightly.db http://files.shadowice.org/nightly/x86_64/nightly.db.tar.gz
echo

set +x
