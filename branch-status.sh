#!/bin/bash

folder=""
if [ ! -z $1 ]; then
    cd $1
    folder=`basename $1`
fi

git for-each-ref --format="%(refname) %(refname:short) %(upstream:short)" refs/ | \
while read name local remote
do
    if [[ $name == refs/tags* ]]; then
        continue
    fi

    if [[ $local == origin* ]]; then
        continue
    fi

    if [ -x $remote ]; then
        branches=("$local")
    else
        branches=("$local" "$remote")
    fi

    git update-index -q --refresh
    CHANGED=$(git diff-index --name-only HEAD --)

    mods=""
    if ! git diff-index --quiet HEAD --; then
        mods=" MODIFICATIONS"
    fi

    for branch in ${branches[@]}; do
        master="origin/master"
        if [ $branch == $master ]; then
            continue
        fi
        git rev-list --left-right ${branch}...${master} -- 2>/dev/null >/tmp/git_upstream_status_delta || continue
        LEFT_AHEAD=$(grep -c '^<' /tmp/git_upstream_status_delta)
        RIGHT_AHEAD=$(grep -c '^>' /tmp/git_upstream_status_delta)
        printf "%s (ahead %s) | (behind %s) %s %-16s%s\n" $branch $LEFT_AHEAD $RIGHT_AHEAD $master $folder $mods
    done
done
