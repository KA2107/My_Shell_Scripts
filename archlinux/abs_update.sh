#!/usr/bin/env bash

echo

sudo abs $(find /var/abs -type d | sed 's|/var/abs||g; s|^/||g;' | grep '/')

echo
