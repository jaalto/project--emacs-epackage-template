Description
===========

This directory contains template files for the Emacs packaging system
called "Epackage" or "Distributed Emacs Lisp Package System (DELPS).
The packages use Git Version Control System (DVCS) containers for
distribution of the original extension code plus a subdirectory named
``epackage/``. These epackage repositories, containers, can reside
anywhere publicly available. Their location is recorded in a separate
**yellow pages** to make them available for users. The person who wraps
Emacs extensions into containers is called epackage *maintainer*. The
person who is he author of the extension is called *upstream*. These
two can be the same or two separate people.

Template files available here for maintainers include:

* ``get-http.sh``     - Simple download script (obsolete)
* ``get.sh``          - Generic download script that reads "info" file
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
        PACKAGE-0loaddefs.el    optional: extracted ###autoload statements
        PACKAGE-autoloads.el    optional: manually written autoload statements (raw)
        PACKAGE-compile.el      optional: Code to byte compile extension
        PACKAGE-examples.el     optional: Custmization examples
        PACKAGE-install.el      required: Code to make extension available
        PACKAGE-uninstall.el    optional: Code to remove extension
        PACKAGE-xactivate.el    optional: Code to activate extension

*NOTE:* This document is just a quick reference. The gory details of
epackage format and description of all the files can be found from the
manual (see REFERENCES at the bottom).

The Epackage Primer
===================

Making an epackage
------------------

1. Prepare an empty directory. If extension more than one file, stay at extension's root directory ans skip (3)::

     mkdir extension
     cd extension

2. Initialize a Git repository. Start at *upstream* branch directly::

     git init
     git branch -m upstream

3. Download Emacs extension code::

    wget http://example.com/project/some-mode.el

4. Determine version information and import code to Git repository. Use clear commit message::

    $ egrep 'version|[0-9][0-9][0-9][0-9]' *.el

    Copyright (C) 2010 John Doe <jdoe@example.net>
    Last-Updated: 2010-05-10
    (defvar some-mode-version "1.12")

    $ git add *.el
    $ git commit -m "import upstream 1.12 (2010-05-10) from example.com"

5. Mark the commit with a tag that has format ``upstream/<UPSTREAM-DATE>[--<UPSTREAM-VERSION>]``. In case information about the release date is not available, use year only format YYYY-01-01. Leave out the ``--<UPSTREAM-VERSION>]`` if there is no information about release version. An exmaple::

    git tag upstream/2010-05-10--1.12

6. Create *master* branch on top of *upstream* branch::

    git branch -b master upstream

7. Copy the template files (which are available here, in this repo you're reading)::

    mkdir epackage/
    cp <path>/{info,get.sh} epackage/

8. Edit the information file. You need to search http://emacswiki.org, Google and study the extension's comments to fill in the details::

    $EDITOR epackage/info

9. Last, a little hard part. You have to write at least two files that will be used for installation: one of the *autoload* files and the *install* file. Third file, xactivate, is optional but recommended. Refer to <http://www.nongnu.org/emacs-epackage/manual>.::

    # Generated automatically from ##autoload tags.
    #
    # Use some utility. E.g. From "Emacs Tiny Tools" distribution tinylisp.el
    # provides M-x tinylisp-autoload-quick-build-interactive-from-file

    epackage/PACKAGE-0loaddefs.el

    # Alternatively, write this by hand: '(autoload ....)' statements.
    # Only needed if the code didn't have ###autoload definitions.

    epackage/PACKAGE-autoloads.el

    # By hand: Figure out by reading the commentary how the extension
    # is activated for immediate use. Add autoloads and Write Emacs
    # lisp code. Try not to load any other packages with 'require' (slows
    # emacs startup).

    epackage/PACKAGE-install.el

#. Commit files to *master* branch::

    git status			# Verify that you're in branch "master"
    git add epackage/
    git commit -m "epackage/: new"

#. Upload the Git repository somewhere publicly available, e.g. to <http://github.com>.

   git remote add github <your URL>	# See "Addnemum" at bottom
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

Epackage Git repository management
==================================

At the beginning the Git repository tree looks like::

                1.12
    upstream:   o
                 \
    master:       o (the epackage/)

After updating to next upstream release (1.13), these two run in
parallel. The *upstream* is periodically merged to *master* branch::

                1.12 1.13
    upstream:   o -- o
                 \    \ (merge upstream changes)
    master:       o -- o -- =>

If you may need to fix code, make all fixes in a separate *patches*
branch and merge those to *master*::

    patches:           o - o
		      /    |
    upstream:   o -- o     |
                 \    \    \/ (merge)
    master:       o -- o - o =>


References
==========

* DELPS at Emacs Wiki: http://www.emacswiki.org/emacs/DELPS
* Epackage main project hub: http://freshmeat.net/projects/emacs-epackage
* Epackage extension for Emacs: http://freshmeat.net/project/epackage
* Epackage manual: http://www.nongnu.org/emacs-epackage/manual
* Epackage template files: https://github.com/jaalto/project--emacs-epackage-template
* Epackage Yellow Pages: https://github.com/jaalto/project--emacs-epackage-sources-list
* Emacs Tiny Tools: http://freshmeat.net/projects/emacs-tiny-tools


Addenum
=======

How to set up project at Github
-------------------------------

1. Generate the SSH keys, if you don't have those already

- Generating SSH keys (Linux) http://help.github.com/linux-key-setup/

2. Register an account

- [top right corner] select *Signup* https://github.com

3. Log into account

- [top right] select *login* https://github.com/
- [(own page) at top right] *account settings / SSH public keys*
  followed by **button:Submit (Copy/paste) your SSH keys (*.pub)**

4. Create a project, say "xxx"

- [back to main page] ``https://github.com/<login>``. At top click
  **button:dashboard**. In new page to the right click **button:New
  repository**. In new page type in project name, say "xxx". Write down
  the ``git://`` repository URL.

5. In shell prompt, type::

    cd ~/dir/xxx                        # Source code of project "xxx"
    git init                            # Initialize
    git add .                           # add all files
    git commit -m "Initial import"      # Put into version control

    # Let Git know about Github
    git remote add github git@github.com:<your github login>/xxx.git

    # Publish "master" branch to Github
    git push github master

That should be all. For more information about Git, see:

- http://www.kernel.org/pub/software/scm/git/docs
- http://git-scm.com
- http://gitref.org
- http://gitcasts.com

Copyright and License
=====================

Copyright (C) 2010 Jari Aalto <jari.aalto@cante.net>

The material is free; you can redistribute and/or modify it under
the terms of GNU General Public license either version 2 of the
License, or (at your option) any later version.

End of file

