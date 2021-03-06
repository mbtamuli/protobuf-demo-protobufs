#!/bin/bash

function create_all_branches()
{
    # Keep track of where Travis put us.
    # We are on a detached head, and we need to be able to go back to it.
    local build_head=$(git rev-parse HEAD)

    # Fetch all the remote branches. Travis clones with `--depth`, which
    # implies `--single-branch`, so we need to overwrite remote.origin.fetch to
    # do that.
    git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
    git fetch
    # optionally, we can also fetch the tags
    git fetch --tags

    # create the tacking branches
    for branch in $(git branch -r|grep -v HEAD) ; do
        git checkout -qf ${branch#origin/}
    done

    # finally, go back to where we were at the beginning
    git checkout ${build_head}
}

create_all_branches

git remote set-url origin https://${GITHUB_OAUTH_TOKEN}@github.com/mbtamuli/protobuf-demo-protobufs.git
git checkout ${TRAVIS_PULL_REQUEST_BRANCH}
git status
make regenerate-protobuf-classes
git status
git add .
git commit -m "[skip ci] Add generated protobuf code"
git push origin ${TRAVIS_PULL_REQUEST_BRANCH}