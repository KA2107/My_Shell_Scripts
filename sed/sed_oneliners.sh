#!/usr/bin/env bash

sed 's|#!/bin/zsh|#!/usr/bin/env zsh|g' -i $(find "${PWD}" | grep '\.sh')
sed 's|#!/bin/bash|#!/usr/bin/env bash|g' -i $(find "${PWD}" | grep '\.sh')
sed 's|#!/bin/sh|#!/usr/bin/env sh|g' -i $(find "${PWD}" | grep '\.sh')
