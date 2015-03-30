#!/bin/sh

# pull changes from SVN
git svn fetch

# create git tags from SVN tags
git for-each-ref refs/remotes/svn/tags | cut -d / -f 4- | while read ref
do
    git tag "$ref" "refs/remotes/svn/tags/$ref"
done

# push changes to Git server
git push origin --all
git push origin --tags
