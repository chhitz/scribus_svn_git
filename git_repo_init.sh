#!/bin/sh

if [ ! -e ".git/config" ]
then
    echo "$0 must be run at the root of an empty git repository."
    exit 1
fi

git svn status 2> /dev/null
if [ $(grep -c "svn-remote" .git/config) -eq 0 ]
then
    cat >> .git/config <<EOF
[svn-remote "svn"]
        url = svn://scribus.net
        fetch = trunk/Scribus:refs/heads/master
	branches = branches/*/Scribus:refs/heads/*
	tags = tags/*/Scribus:refs/remotes/svn/tags/*
[svn]
        authorsfile = $(dirname $0)/svn_authors.txt
EOF
else
    echo "Repository already contains a git svn configuration. Not changing anything."
fi
