#!/bin/sh

SVN_SERVER=svn://scribus.net

# check whether whiptail or dialog is installed
read dialog <<< "$(which whiptail dialog 2> /dev/null)"

# exit if none found
[[ "$dialog" ]] || {
  echo 'neither whiptail nor dialog found' >&2
  exit 1
}

function show_list {
    title=$1
    shift
    checklist=""
    n=1
    for branch in $@
    do
	checklist="$checklist ${branch%/} $n"
	git config --get svn-remote.svn.fetch "(branches|tags)/${branch%/}" 2> /dev/null
	if [ $? -eq 0 ]
	then
	    checklist="$checklist on"
	else
	    checklist="$checklist off"
	fi
	n=$[n+1]
    done

    exec 3>&1
    choices=$($dialog --checklist "$title" 0 0 0 $checklist 2>&1 1>&3)
    exitcode=$?
    exec 3>&-
}

svn_branches=$(svn ls $SVN_SERVER/branches 2> /dev/null)
show_list "Select branches to import" $svn_branches
branch_choices=$choices
if [ $exitcode -ne 0 ]
then
    exit 1
fi

svn_tags=$(svn ls $SVN_SERVER/tags 2> /dev/null)
show_list "Select tags to import" $svn_tags
tag_choices=$choices
if [ $exitcode -ne 0 ]
then
    exit 1
fi

#create backup of .git/config
cp .git/config .git/config.bak

git config svn.authorsfile $(dirname $0)/svn_authors.txt
git config svn-remote.svn.url $SVN_SERVER
git config --unset-all svn-remote.svn.fetch
git config svn-remote.svn.fetch trunk/Scribus:refs/heads/master

for choice in $branch_choices
do
    git config --add svn-remote.svn.fetch "branches/$choice/Scribus:refs/heads/$choice"
done

for choice in $tag_choices
do
    git config --add svn-remote.svn.fetch "tags/$choice/Scribus:refs/remotes/svn/tags/$choice"
done
