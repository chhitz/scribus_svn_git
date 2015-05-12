# README

This repository contains the meta-data used to convert the Scribus SVN
(svn://scribus.net) repository to Git.

The trunk and all branches and tags are imported from SVN into Git.

The SVN repository contains an additional folder "Scribus" at the
project root. This folder is skipped during conversion, so that the
programm sources appear in the repository root.

The `git_repo_init.sh` script configures an empty Git repository to
receive the SVN commits.

The `update_from_svn.sh` script pulls new commits from SVN, creates Git
tags from SVN tags and pushes the result to the configured "origin"
Git remote repository.


## How to set-up

Each developer who takes care of synchronizing the Scribus Github repository with the Scribus SVN repository has to:

1. Make sure you have git-svn installed (and git, for course).
2. Clone chitz' script's repository:

          git@github.com:chhitz/scribus_svn_git.git

3. Use the provided scripts to initialize and update the repository.

Once you have the scripts you:

1. create empty git repository

          git init <nice_name>

2. move into the git repository

          cd <nice_name>

3. initialize git svn

          ./path/to/git_repo_init.sh

4. configure remote Git server

          git remote add origin git@github.com:scribusproject/scribus.git

5. import svn into git

          ./path/to/update_from_svn.sh

git will start downloading files from the Scribus svn repository. It will take a long while for the first sync.

## How to update

Once you have synchronized the repository once, it's just a matter of running the `update_from_svn.sh` script from inside of the repository.

## Caveat

All SVN commiters need to be listed in `svn_authors.txt`. A missing
author will lead to an error:

    Author: <username> not defined in /path/to/svn_authors.txt file

In this case, add the new commiter to the `svn_authors.txt` file with
the following format:

    username = Full Name <email@address.xzy>

and re-run the import.
