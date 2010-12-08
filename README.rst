Description
===========

This directory contains template files for the Emacs packaging system
called "Epackage" or "Distributed Emacs Lisp Package System (DELPS).
The packages use GitVersion Control System (DVCS) containers for
distribution of the original extension code plus a subdirectory named
``epackage/``. These epackage repositories, containers, can reside
anywhere publicly available. Their location is recorded in a aseparate
**yellow pages** to make them availale for userd. The person who wraps
Emacs extensions into containers is called epackage *maintainer*. The
person who is he author of the extension is called *upstream*. These
two can be the same or two separate people.

Template files available here for maintainers include:

* ``get-http.sh``     - Simple download script (obsolete)
* ``get.sh``          - Generic download script that reads 'info' file
* ``info``            - The Epackage information file

In a nutshell, the epackage has the format::

    <Emacs extension root dir>
    | *.el
    | <and any other upstream files, directories>
    |
    +- .git/                    Version control branches: master + upstream
    |
    +-- epackage/
        info                    required: The package control file
        PACKAGE-0loaddefs.el    optional: ###autoload statements
        PACKAGE-autoloads.el    optional: all autoload statements (raw)
        PACKAGE-compile.el      optional: Code to byte compile package
        PACKAGE-install.el      required: Code to make package available
        PACKAGE-uninstall.el    optional: to remove package
        PACKAGE-xactivate.el    optional: Code to activate package

**NOTE:** This document is just a quick reference. The gory details of
epackage format and description of all the files can be found at
<http://www.nongnu.org/emacs-epackage/manual>.

The Epackage Primer
===================

Making an epackage
------------------

1. Prepare empty directory::

     mkdir extension
     cd extension

2. Init Git repository. Start at *upstream* branch directly::

     git init
     git branch -m upstream

3. Download Emacs extension code::

    wget http://example.com/project/some-mode.el

4. Determine version information and import code to Git repository. Use clean commit message::

    $ egrep 'version|[0-9][0-9][0-9][0-9]' *.el

    Copyright (C) 2010 John Doe <jdoe@example.net>
    Last-Updated: 2010-05-10
    (defvar some-mode-version "1.12")

    $ git add *.el
    $ git commit -m "import upstream 1.12 (2010-05-10) from example.com"

5. Mark this commit with a tag that has format ``upstream/<UPSTREAM-DATE>[--<UPSTREAM-VERSION>]``::

    git tag upstream/2010-05-10--1.12

6. Create *master* branch on top of *upstream* branch::

    git branch -b master upstream

7. Copy the template files::

    mkdir epackage/
    cp <path>/{info,get.sh} epackage/
    rm epackage/get-http.sh     # Not needed

8. Edit the information file. You need to search http://emacswiki.org, Google and study the extension's comments to fill in the fields.::

    $EDITOR epackage/info

9. Last, a little hard part. You have to write at least two files that will be used for installation: the *autoload* file and the *install* file. Third file, xactivate, is optional but recommended. Refer to <http://www.nongnu.org/emacs-epackage/manual>.::

    # Generated automatically from ##autoload tags. Use some utility.

    epackage/PACKAGE-0loaddefs.el

    # Afternatively, by hand. Write '(autoload ....)' statements.
    # Only needed if code didn't have ###autoload definitions.

    epackage/PACKAGE-autoloads.el

    # By hand: Figure out by reading the commentary how the extension
    # is activated for immediate use. Add autoloads and Write Emacs
    # lisp code. Try not to load any other packages with 'require' (slows
    # emacs startup).

    epackage/PACKAGE-install.el

#. Commit files to *master* branch::

    git add epackage/
    git commit -m "epackage/: new files"

#. Upload this Git repository somewhere publicly available, e.g. <http://github.com>.

   git remote add github <your URL>
   git push github upstream
   git push github master

#. Add information about this new epackage to the **yellow pages** so that others know find it. The information needed is::

    PACKAGE-NAME (from epackage/info::Package field)
    GIT-URL      (the public git repository URL)
    DESCRIPTION  (from epackage/info::Description, the 1st line)

Fork the current **yellow pages**, clone it to your local disk, edit
add new information, commit, and send a *Pull request* through github.
See these page:

- http://help.github.com/forking/  (Forking a project)
- http://help.github.com/pull-requests/ (Sending pull requests)

After your URL has been merged, update your copy of yellow pages::

    git pull

Keeping epackage up to date
---------------------------

Periodically follow new releases of upstream code. Once a new release is
made available, make an update.

1. Verify that the repository is in a clean state. Commit any changes::

    git status

2. Download new upstream release::

    sh epackage/get.sh

3. Switch to *upstream* branch::

    git checkout upstream

4. Examine version and release date of upstream code. Commit and tag::

    git add <list of files>
    git commit -m "import upstream 1.13 (2010-06-10) from example.com"
    git tag  upstream/2010-06-10--1.13

5. Switch back to *master* and update `epackage/` directory information if needed::

    git checkout master
    ... edit epackage/ and commit
    ... test that all works

6. Merge upstream to your *master*::

    git merge upstream

7. Push new epackage available:

    git push

Epackage Git repository layout
==============================

At the beginning the Git repository tree looks like::

                1.12
    upstream:   o
                 \
    master:       o (the epackage/)

After updating to next upstream release (1.13), these two run in
prallel. The *upstream* is periodically merged to *master* branch.

                1.12 1.13
    upstream:   o -- o
                 \    \ (merge upstream changes)
    master:       o -- o -- =>

If you may need to fix code, make all fixes in a separate *patches*
branch and merge those to *master*:


    patches:           o - o
		      /    |
    upstream:   o -- o     |
                 \    \    \/ (merge)
    master:       o -- o - o =>


End of file
