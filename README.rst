Description
===========

This directory contains template files for the Emacs packaging system
called "Epackage". The epackages for Emacs are Git Distributed Version
Control System (DVCS) containers that contains the original extenstion
code plus subdirectory named ``epackage/``. The containers can reside
anywhere publicly available and in distributed fashion, any Emacs user
can download and install those. The person who is doing the epackage
work is called *maintainer* and the person who is writing the
extenstion is called *upstream*.

Template files available for maintainers in this directory:

* ``get-http.sh``     - Simple downloader (obsolete)
* ``get.sh``          - Generic downloader that reads 'info' file
* ``info``            - The Epackage information file

In a nutshell, the epackages have the format::

    <Emacs extension root dir>
    | *.el
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

**NOTE:** This document is just a quickref. The Gory details of
epackage format and it's use, as well as detailed description fo all
the files can be found from <TODO:URL>.

The Epackage Primer
===================

Making an epackage
------------------

The steps to convert existing Emacs extension into **epackage** format goes
like this.

1. Prepare empty directory::

     mkdir extension
     cd extension

2. Init Git repository. Name it *upstream* branch::

     git init
     git branch -m upstream

3. Download Emacs extension code::

    wget http://example.com/project/some-mode.el

4. Examine the version and import the code to version control repository::

    egrep 'version|[0-9][0-9][0-9][0-9]' *.el

    Copyright (C) 2010 John Doe <jdoe@example.net>
    Last-Updated: 2010-05-10
    (defvar some-mode-version "1.12")

    git add *.el
    git commit -m "import upstream 1.12 (2010-05-10) from example.com"

5. Mark this commit with a tag that has format "upstream/<UPSTREAM-DATE>[--<UPSTREAM-VERSION>]"::

    git tag upstream/2010-05-10--1.12

6. Create *master* branch on top of *upstream* branch::

    git branch -b master upstream

7. Copy the template files::

    mkdir epackage/
    cp <path>/{info,get.sh} epackage/
    rm epackage/get-http.sh     # Not needed

8. Edit the epackage information file. You need to search http://emacswiki.org, Google and study the extenstion's comments to fill in the fields.::

    $EDITOR epackage/info

9. Last, a little hard part. You have to write at least two files that will be used for epackage installation: the *autoload* file and the *install* file. Third file, xactivate, is optional but recommended.::

    # Generated automatically from ##autoload tags. Use some utility

    epackage/PACKAGE-0loaddefs.el

    # By hand, write '(autoload ....)' statements.
    # Only needed if code didn't have ###autoload definitions.

    epackage/PACKAGE-autoloads.el

    # By hand: Figure out reading the code how it is activated for
    # immediate use: add autoloads and erite Emacs lisp code. Try not to
    # load any package with 'require' (slows emacs startup).

    epackage/PACKAGE-xinstall.el

#. Commit files to *master* branch::

    git add epackage/
    git commit -m "epackage/: new files"

#. Upload this Git repository somewhere publicly available, e.g.  <http://github.com>.

#. Add information about new epackage to the **yellow pages** so that others know find it. The information needed is::

    PACKAGE-NAME (from epackage/info::Package field)
    GIT-URL      (the public git repository URL)
    DESCRIPTION  (from epackage/info::Description, the 1st line)

The **yellow pages** list can be updated at: <TODO>

Updating an epackage
--------------------

Periodically follow new releases of upstream code. Once new release is
available, make updates to Emacs extension's epackage.

1. Verify that the repository is in a clean state::

    git status

2. Switch to *upstream* branch::

    git checkout upstream

3. Download new upstream release::

    sh epackage/get.sh

4. Examine version and release date of upstream code. Commit and tag::

    git add *.el
    git commit -m "import upstream 1.13 (2010-06-10) from example.com"
    git tag  upstream/2010-06-10--1.13

5. Switch back to *master* and update `epackage/` directory information if needed::

    git checkout master
    ... edit epackage/ and commit
    ... test that all works

6. Rebase your work in top of *upstream*::

    git rebase upstream

7. Push your chnages to public repository that you have defined::

    git push

Epackage Git repository layout
==============================

At first import the Git repository tree looks like this::

                1.12
    upstream:   o
                 \
    master:       o (the epackage/)

After updating to 1.13 the developement tree chnages shape.
Notice how *master* branch has moved forward as a result of
``git rebase``::

                1.12 1.13
    upstream:   o -- o
                      \
    master:            o (the epackage/)


End of file
