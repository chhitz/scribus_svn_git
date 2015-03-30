#!/bin/sh

SVN_GIT_DIR="scribus_svn4"
CONFIG_DIR=$(pwd)

git init $SVN_GIT_DIR
pushd $SVN_GIT_DIR

cat >> .git/config <<EOF
[svn-remote "svn"]
        url = svn://scribus.net
        fetch = trunk/Scribus:refs/heads/master
	branches = branches/*/Scribus:refs/heads/*
	tags = tags/*/Scribus:refs/remotes/svn/tags/*
[svn]
        authorsfile = $CONFIG_DIR/svn_authors.txt
EOF
