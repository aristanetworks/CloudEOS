#!/bin/bash
# Copyright (c) 2020 Arista Networks, Inc.  All rights reserved.
# Arista Networks, Inc. Confidential and Proprietary.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Add our git config for "git push review"
if ! grep -q '\[remote "review"\]' $REPO_ROOT/.git/config
then
   REPO_ORIGIN="$(git config --get remote.origin.url)"
   [[ $REPO_ORIGIN != ssh* ]] && echo "Please clone the project via ssh (read http://go/gerrit)" && exit 1
   sed -e "s!@REPO_ORIGIN@!$REPO_ORIGIN!" $REPO_ROOT/gitconfig-review >> $REPO_ROOT/.git/config
fi

# Add the gerrit hook that adds change IDs
if [ $USER != "arastra" ]
then
   gitdir=$(git rev-parse --git-dir); scp -p -P 29418 gerrit:hooks/commit-msg ${gitdir}/hooks/
fi
