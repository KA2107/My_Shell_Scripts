#!/bin/sh

sudo rm /var/lib/pacman/sync/{radeon,nightly}.db

sudo aria2c --dir=/var/lib/pacman/sync/ --out=radeon.db http://spiralinear.org/perry3d/x86_64/radeon.db.tar.gz

sudo aria2c --dir=/var/lib/pacman/sync/ --out=nightly.db http://nightly.uhuc.de/x86_64/nightly.db.tar.gz
