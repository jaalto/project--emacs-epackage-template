..  comment: the source is maintained in ReST format.
    Emacs: http://docutils.sourceforge.net/tools/editors/emacs/rst.el
    Manual: http://docutils.sourceforge.net/docs/user/rst/quickref.html

Description
===========

This directory contains template files for the Emacs packaging system
called "Distributed Emacs Lisp Package System (DELPS), or in short
"Epackage". The package format use Git Distributed Version Control
System (DVCS) containers for the original source code plus a separate
``epackage/`` subdirectory. These Git repositories can reside anywhere
publicly available. The repository locations are recorded in a public
**Sources List** file which is used as a master list to available
Epackages. The person who wraps Emacs extension into these Git
repositories is called Epackage *maintainer*. The person who is the
author of the original Emacs extension developer is called *upstream*.
These two can be the same or separate persons.

Template files available here for Epackage maintainers include:

* ``get-http.sh``     - Simple download script (obsolete)
* ``get.sh``          - Generic download script that reads "info" file
* ``info``            - The Epackage information file

In a nutshell, Epackages have the following format ::

    <Emacs extension root dir>
    | *.el
    | <and any other upstream files, directories>
    |
    +- .git/                    [Version control branches: master + upstream]
    |
    +-- epackage/		[Only the most important files listed]
        info                    required: The package control file
        PACKAGE-0loaddefs.el    optional: extracted ###autoload statements
        PACKAGE-autoloads.el    optional: manually written autoload statements (raw)
        PACKAGE-install.el      required: Code to make extension available
        PACKAGE-xactivate.el    optional: Code to activate extension

*NOTE:* This document is just a quick reference. The full details of
concept description of all the files in deteail can be found from the
manual:

* DELPS at Emacs Wiki: http://www.emacswiki.org/emacs/DELPS
* Epackage main project hub: http://freshmeat.net/projects/emacs-epackage
* Epackage extension for Emacs: http://freshmeat.net/project/epackage
* Epackage manual: http://www.nongnu.org/emacs-epackage/manual
* Epackage template files: https://github.com/jaalto/project--emacs-epackage-template
* Epackage Sources List: https://github.com/jaalto/project--emacs-epackage-sources-list
* Emacs Tiny Tools: http://freshmeat.net/projects/emacs-tiny-tools

The Epackage Primer
===================

Hands on example
----------------

If you want to get your hands dirty immediately and read documentation
later, follow this exercise to create your first epackage: ::

    # The helper shellrc needs epackage.el installed

    mkdir -p $HOME/emacs.d/packages
    cd $HOME/emacs.d/packages
    git clone git://github.com/jaalto/project--emacs-epackage.git epackage
    cd epackage
    git checkout --track -b devel origin/devel

    # Change to a directory for epackage development

    mkdir -p $HOME/epackage
    cd $HOME/epackage
    git clone git://github.com/jaalto/project--emacs-epackage-template.git template

    # Type dot(.) POSIX source command to read utilities

    . template/epackage.shellrc

    # Import Emacs Lisp package from URL

    mkdir -p $HOME/epackage/toggle
    cd $HOME/epackage/toggle
    Egit [-h] http://www.emacswiki.org/emacs/download/toggle.el

    # Follow the instructions at end of output....

	Initialized empty Git repository in /home/jaalto/vc/epackage/xxx/.git/
	;; Copyright (C) 2006-2007 by Ryan Davis
	;; Author: Ryan Davis <ryand-ruby@zenspider.com>
	;; Version 1.3.1
	;; Created: 2006-03-22
	;; URL(en): http://seattlerb.rubyforge.org/
	;; http://en.wikipedia.org/wiki/MIT_License
	;; There are 4 different mapping styles in this version: zentest,
	;; 1.3.1 2008-09-25 Fixed doco & typo in rspec patterns.
	;; 1.3.0 2007-05-10 Added tab completion to toggle-style. Suggested by TingWang.
	;; 1.2.0 2007-04-06 Interleave bidirectional mappings. Fixed interactive setter.
	;; 1.1.0 2007-03-30 Initial release to emacswiki.org. Added named styles and bidi.
	;; 1.0.0 2006-03-22 Birfday.
	(require 'cl)
        # WHAT YOU NEED TO DO NEXT:
	# Examine dates, version and correct information to commands below.
	git commit -m "Import upstream 2011-12-29 from http://www.emacswiki.org/emacs/download/toggle.el"
	git tag upstream/2011-12-29--VERSION
	git checkout -b master

    # (1) commit upstream code

    git commit -m "Import upstream 2011-12-29 from http://www.emacswiki.org/emacs/download/toggle.el"

    # (2) Tag, according to displayed information. We were lucky. Not
    # all Lisp Files present date and version information this
    # clearly. Notice, the date is LAST MODIFIED date of code by the
    # original author. If not shown, you could check "ls -l *.el"

    git tag upstream/2008-09-25--1.3.1

    # (3) Upstream code is now archived. Start "epackaging"

    git checkout -b master

    # Select PACKAGE NAME. If this would have been a library, you
    # would have used "lib-*" prefix for package name. If this were a
    # minor or major mode, you would have added "*-mode" suffix.

    Edir [-h] toggle toggle.el

	Loading vc-git...
	Wrote toggle-epkg-autoloads.el
	Wrote toggle-epkg-install.el
	Generating autoloads for toggle.el...
	Generating autoloads for toggle.el...done
	Wrote toggle-epkg-compile.el
	Wrote toggle-epkg-examples.el
	Wrote toggle-epkg-uninstall.el

    # (4) templates are ready, go and edit

    cd epackage/
    ls -1

	toggle-epkg-autoloads.el
	toggle-epkg-compile.el
	toggle-epkg-examples.el
	toggle-epkg-install.el
	toggle-epkg-uninstall.el

    # Rqeruired files: info, *-autoloads.el, -*install.el
    # - No need for compile, this is a single file package
    # - No examples this time for this simple package
    # - Nothing to uninstall

    rm *-compile.el *-examples.el *-uninstall.el

    # Edit information and fill in fields

    $EDITOR info

    # Edit done? Finish the epackage.

    git add .
    git commit -m "epackage/: new"

    # ... and continue reading this README to fill in questions
    # you may have in mind. Open account at github and push. Notify
    # Sources List maintainer about your new epackage to make it
    # available for others.

Making an epackage
------------------

1. Prepare an empty directory. If extension more than one file, stay at extension's root directory ans skip (3) ::

    mkdir extension
    cd extension

2. Initialize a Git repository. Start at *upstream* branch directly ::

    git init
    git symbolic-ref HEAD refs/heads/upstream

3. Download Emacs extension code ::

    wget http://example.com/project/some-mode.el

4. Determine version information and import code to Git repository. Use clear commit message ::

    $ egrep 'version|[0-9][0-9][0-9][0-9]' *.el

    Copyright (C) 2010 John Doe <jdoe@example.net>
    Last-Updated: 2010-05-10
    (defvar some-mode-version "1.12")

    $ git add *.el
    $ git commit -m "import upstream 1.12 (2010-05-10) from example.com"

5. Mark the commit with a tag that has format ``upstream/<UPSTREAM-DATE>[--<UPSTREAM-VERSION>]``. In case information about the release date is not available, use year only format YYYY-01-01. Leave out the ``--<UPSTREAM-VERSION>]`` if there is no information about release version. An exmaple ::

    git tag upstream/2010-05-10--1.12

6. Create *master* branch on top of *upstream* branch ::

    git branch -b master upstream

7. Copy the template files (which are available here, in this repo you're reading) ::

    mkdir epackage/
    cp <path>/{info,get.sh} epackage/

8. Edit the information file. You need to search http://emacswiki.org, Google and study the extension's comments to fill in the details ::

    $EDITOR epackage/info

9. Last, write at least two files that will be used for installation. One is the *autoload* file and the other is the *install* file. You can also add optional *xactivate* file. Refer to <http://www.nongnu.org/emacs-epackage/manual>::

    # Generated from ##autoload tags with epackage.el command
    # M-x epackage-devel-generate-loaddefs

    epackage/PACKAGE-0loaddefs.el

    # If the original extension did not have ##autoload tags, these must
    # be extracted manually. Write '(autoload ....)' statements by hand, or
    # call epackage.el command M-x epackage-devel-generate-autoloads

    epackage/PACKAGE-autoloads.el

    # [optional] Figure out by reading the commentary how the
    # extension is activated for immediate use. Add autoloads and
    # write Emacs lisp code. Try not to load any other packages here
    # with 'require' (slows emacs startup).

    epackage/PACKAGE-install.el

#. Commit files to *master* branch ::

    git status			# Verify that you're in branch "master"
    git add epackage/
    git commit -m "epackage/: new"

#. Upload the Git repository somewhere publicly available, e.g. to <http://github.com> ::

    git remote add github <your URL>	# See section "Addenum" at the end
    git push github upstream master
    git push github --tags

#. Add information about this new epackage to the **Sources List** so that others know how to find it. The information needed is ::

    PACKAGE-NAME (from epackage/info::Package field)
    GIT-URL      (the public git repository URL)
    DESCRIPTION  (from epackage/info::Description, the 1st line)

Fork the current **Sources List**, clone it to your local disk, edit
add new information, commit, and send a *Pull request* through github.
See these page:

- http://help.github.com/forking/  (Forking a project)
- http://help.github.com/pull-requests/ (Sending pull requests)
- https://github.com/blog/270-the-fork-queue (Keeping fork in synch)

After your URL has been merged, update your copy of Sources List ::

    git pull

When upstream uses Git repository too
-------------------------------------

It is possible that the upstream is also using Git. In that case, the
steps 1-3 are as follows:

1. Prepare an empty directory ::

    mkdir extension
    cd extension

2. Initialize a Git repository. Start at *upstream* branch directly ::

    git init
    git symbolic-ref HEAD refs/heads/upstream

    # To init branch: Make an empty file, commit
    touch .ignore
    git add .ignore
    git commit -m "Add dummy file to start the branch"

3. Instead of downloading, add remote to track upstream code, pull, and merge ::

    git remote add upstream git://example.com/some-emacs-project
    git fetch upstream
    git checkout --track -b upstream-master upstream/master
    git checkout upstream
    git merge upstream-master

After that proceed as usual by tagging the release and adding
``epackage/`` directory as outlined previously. To follow upstream
development, from time to time pull, merge ::

    git fetch upstream

    git checkout upstream-master
    git pull

    git checkout upstream
    git merge upstream-master
    git tag upstream/$(date "+%Y-%m-%d")--git-$(git rev-parse HEAD | cut -c1-7)

    git checkout master
    git merge upstream

Keeping epackage up to date
---------------------------

Periodically follow new releases of upstream code. Once upstream
releases new code, make an update.

1. Verify that the repository is in a clean state. Commit any changes ::

    git status

2. Download new upstream release ::

    cd epackage/
    sh get.sh

3. Switch to *upstream* branch ::

    git checkout upstream

4. Examine version and release date of upstream code. Commit and tag ::

    git add -A  # Import all changes since.
    git commit -m "import upstream 1.13 (2010-06-10) from example.com"
    git tag upstream/2010-06-10--1.13

5. Switch back to *master* and merge latest upstream ::

    git checkout master
    git merge upstream

6. If needed, update `epackage/` directory information ::

    ... edit epackage/* files
    ... commit
    ... test that all works

7. Push updated epackage for others to download ::

    git push github upstream master
    git push github --tags

Epackage Git repository management
==================================

At the beginning the Git repository tree looks like ::

                1.12
    upstream:   o
                 \
    master:       o (the epackage/)

After updating to next upstream release (1.13), these two run in
parallel. The *upstream* is periodically merged to *master* branch ::

                1.12 1.13
    upstream:   o -- o
                 \    \ (merge upstream changes)
    master:       o -- o -- =>

If you may need to fix code, make all fixes in a separate *patches*
branch and merge those to *master* ::

    patches:           o - o
		      /    |
    upstream:   o -- o     |
                 \    \    \/ (merge)
    master:       o -- o - o =>

Addenum
=======

How to set up project at Github
-------------------------------

1. Generate the SSH keys, if you don't have those already

- See, generating SSH keys for Linux http://help.github.com/linux-key-setup/

2. Register an account

- [top right corner] select *Signup* https://github.com

3. Log into account

- [top right] select *login* https://github.com/
- [(own page) at top right] *account settings / SSH public keys*
  followed by **button:Submit (Copy/paste) your SSH keys (*.pub)**

4. Create a project, say "xxx"

- [back to main page] ``https://github.com/<login>``. At top left, click
  **text:GitHub**. In new page, scroll a little past icons at top, to
  the right click **button:New repository**. In new page type in
  project details. After finishing, Write down the shown``git://``
  repository URL. ::

       Project Name : myproject
       Description  : <fill in>
       homepage     : <fill in>
       [x] anyone can access to this repository

       [lower right] Press button "create repository"

5. In shell prompt, type ::

    cd ~/dir/myproject                  # Source code
    git init                            # Initialize
    git add .                           # add all files
    git commit -m "Initial import"      # Put into version control

    # Let Git know about Github
    git remote add github git@github.com:<your github login>/myproject.git

    # Publish "master" branch to Github
    git push github master

That should be all. For more information about Git, see:

- http://www.kernel.org/pub/software/scm/git/docs
- http://git-scm.com
- http://gitref.org
- http://gitcasts.com

Copyright and License
=====================

Copyright (C) 2010-2012 Jari Aalto <jari.aalto@cante.net>

The material is free; you can redistribute and/or modify it under
the terms of GNU General Public license either version 2 of the
License, or (at your option) any later version.

End of file
