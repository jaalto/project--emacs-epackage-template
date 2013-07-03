.. comment: This FILE is part of project
   https://github.com/jaalto/project--emacs-epackage-template

.. comment: this source is maintained in ReST format.
   Emacs: http://docutils.sourceforge.net/tools/editors/emacs/rst.el
   quick: http://docutils.sourceforge.net/docs/user/rst/quickref.html
   Reference: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html


.. _Debian: http://www.debian.org
.. _Emacs: http://www.gnu.org/s/emacs
.. _epackage.el: http://www.emacswiki.org/emacs/DELPS
.. _DELPS: http://www.emacswiki.org/emacs/DELPS
.. _Emacs Wiki: http://www.emacswiki.org
.. _Tiny Tools: http://www.emacswiki.org/emacs/TinyTools
.. _Sources List: https://github.com/jaalto/project--emacs-epackage-sources-list
.. _autoload: http://www.gnu.org/software/emacs/manual/html_mono/elisp.html#Autoload
.. _License Database: http://pinboard.in/u:jariaalto/t:license/t:database
.. _Public Domain: http://pinboard.in/u:jariaalto/t:license/t:public-domain/t:faq
.. _Pristine Tar: http://kitenet.net/~joey/blog/entry/generating_pristine_tarballs_from_git_repositories/

Description
===========

Epackages are preformatted software packages for `Emacs`_ that provide
easy way to install more features to Emacs. Similar to concept of
Windows MSI or Linux *.rpm (Redhat) and *.deb (`Debian`_) packages.

This directory contains template files for the Emacs packaging system
called "Distributed Emacs Lisp Package System (`DELPS`_), or in short
"Epackage". The package format use Git Distributed Version Control
System (DVCS) repositories for the original source code plus a separate
``epackage/`` sub directory. These Git repositories can reside anywhere
publicly available. The repository locations are recorded in a public
`Sources List`_ file which is used as a master list to available
Epackages. The person who wraps Emacs extension into these Git
repositories is called Epackage *maintainer*. The person who is the
author of the original Emacs extension developer is called *upstream*.
These two can be the same or separate persons.

Utilities and template files available here for Epackage maintainers include:

* ``info``            - The Epackage information file template
* ``get.sh``          - Generic download script that reads "info" file
* ``epackage.shellrc`` - Command line utilities to make Epackages

In a nutshell, Epackages have the following format ::

    <Emacs extension root dir>
    | *.el
    | <and any other upstream files, directories>
    |
    +- .git/                    [Version control branches: master + upstream]
    |
    +-- epackage/               [Only the most important files listed]
        info                    required: The package control file
        PACKAGE-0loaddefs.el    optional: extracted ###autoload statements
        PACKAGE-autoloads.el    optional: manually written autoload statements (raw)
        PACKAGE-install.el      required: Code to make extension available
        PACKAGE-xactivate.el    optional: Code to activate extension

*NOTE:* This document is just a quick reference. Refer to
specification below for details about the ``epackage/`` directory
structure and file formats.

* DELPS at Emacs Wiki: http://www.emacswiki.org/emacs/DELPS
* Epackage main project hub: http://freecode.com/projects/emacs-epackage
* Epackage specification: http://www.nongnu.org/emacs-epackage/manual
* Epackage template files: https://github.com/jaalto/project--emacs-epackage-template
* Epackage Sources List: https://github.com/jaalto/project--emacs-epackage-sources-list

Bookmarks for your browser (always up-to-date):

* All epackage related links:
  http://pinboard.in/u:jariaalto/t:emacs/t:epackage?sort=title
* All Emacs Lisp Software Quality Assurance (QA) related links:
  http://pinboard.in/u:jariaalto/t:emacs/t:elisp/t:qa?sort=title

The Epackage Primer
===================

Hands on example
----------------

Before the full script, here is outline of the packaging procedure: ::

    #  Remember to clone the "engine" first from project page
    #  https://github.com/jaalto/project--emacs-epackage
    #
    #  Tell where the epackage.el "engine" is located to that helper
    #  functions can call it.

    export EPACKAGE_ROOT=<path to>/project--emacs-epackage

    #  read additional shell commands

    . /path/to/this-repository/epackage.shellrc

    #  Egit can download code from various sources.
    #  If you already have source code in current directory, just call "Egit"
    #  without parameters.

    cd /path/to/place/where-sources-will-be-downloaded

    Egit http://example.com/file.el

    #  Follow then displayed instructions by the above command after it finishes.
    #  After committing and tagging "upstream", continue in "master"
    #  branch This command will instrument epackage/ directory

    Edir

    # Run QA tests and report findings to upstream

    Elint *.el
    Ecomp *.el

    #  Done. Edit file epackage/info.
    #  Delete unneeded files. Commit and push to Github
    #  Notify "Sources List" about new package.

    ... edit epackage/ directory contents
    git push <your Github account>

    # ... Later, if upstream releases new code, run these

    Ever
    Edef

If you want to get your hands dirty immediately and read the
documentation later, here is real example. Follow this exercise to
create your first epackage: ::

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
        ;; Copyright (C) 2006-2013 by Ryan Davis
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
        git tag upstream/2011-12-29--VERSION
        git checkout -b master


    # (1) Tag, according to displayed information. We were lucky. Not
    # all Lisp Files present date and version information this
    # clearly. Notice, the date is LAST MODIFIED date of code by the
    # original author. If not shown, you could check "ls -l *.el"

    git tag upstream/2008-09-25--1.3.1

    # (2) Upstream code is now archived. Start "epackaging"

    git checkout -b master

    # (3) Select PACKAGE NAME. If this were a library, you would use
    # "lib-*" prefix. If this were a minor or major mode, you would
    # have added "*-mode" suffix.
    #
    # Here we simply call it epackage "toggle":

    Edir toggle .

        Loading vc-git...
        Wrote toggle-epackage-autoloads.el
        Wrote toggle-epackage-install.el
        Generating autoloads for toggle.el...
        Generating autoloads for toggle.el...done
        Wrote toggle-epackage-compile.el
        Wrote toggle-epackage-examples.el
        Wrote toggle-epackage-uninstall.el

    # (4) Templates are ready. Clean up as needed.

    cd epackage/
    ls -1

        info				# required
        toggle-epackage-autoloads.el	# required
        toggle-epackage-compile.el
        toggle-epackage-examples.el
        toggle-epackage-install.el	# required
        toggle-epackage-uninstall.el

    # We remove following files:
    #
    # - compile: this is a single file package, not needed
    # - examples: None. The toogle.el docs have no examples.
    # - uninstall: None. We don't need to undo hooks afterwards etc.

    rm *-compile.el *-examples.el *-uninstall.el

    # Edit epackage information control file:

    $EDITOR info

    # Finish the epackage.

    git add .
    git commit -m "epackage/: new"

    # Run QA tests and report findings to upstream

    Elint *.el
    Ecomp *.el

After the exercise, continue reading this README to fill in questions
you may have in mind.

Packaging Best Practises
-----------------------

FOREWORD

Things that live in a drop-in package repository bit-rot at an
alarming rate. In contrast, the `DELPS`_ is based on personal care of
packages, just like the Debian which has package maintainers. Someone
is doing the packaging. Making sure package is taken care of, updated,
released, removed if it no longer works. That someone is taking care
of things for the benefit of others who make use of the service.

That means, if there is no nobody interested in some file.el, it
probably won't get packaged. There are lot of old and dead code e.g.
in `Emacs Wiki`_. Such code might be best left in the place it was
found dusting.

EXAMING FILES

For the package maintainer, it is desirable to keep close contact
with the upstream to get QA issues solved as soon as possible. Well
cared code also has better chance to work in later Emacs versions. It
may also improve changes to be included in core Emacs someday. The
best practises for package maintainer are:

* Is the code alive? If the code was last updated years ago,
  consider labeling package **unmaintained** while it also
  may be labeled **stable** in *epackage/info::Status*.
* Examine ``require`` commands. Does package depend on other than
  standard Emacs features? If it does, package those dependencies
  first.
* Examine ``require`` commands closer. How many are there? Perhaps the
  author didn't consider library requirements carefully. It may be
  possible to arrange code to load faster and consume less memory
  by utilizing ``autoload`` instead of ``require`` for
  features that are not immediately used. Talk to upstream about this.
* Does every variable and function start with a common ``package-*``
  prefix? If not, label package as **unsafe** in
  *epackage/info::Status* . Explain the reason for the unsafe status
  the end of *epackage/info::Description* field. Use e.g. quick
  ``egrep -ri '^\(def' .`` to see if multiple name spaces are used in
  the code.
* Are there ``defgroup`` and
  ``defcustom`` definitions according to
  `14 Writing Customization Definitions
  <http://www.gnu.org/software/emacs/manual/html_mono/elisp.html#Customization>`_
  in GNU Emacs Lisp Reference Manual? If not, talk to upstream.
* Are there ``;;;###autoload`` stanzas? These are placed above
  suitable interactive functions and variables that help in generating
  `autoload`_ definitions'. If not, consider adding and sending path
  to maintainer.
* Does the code contain ``global-set-key`` commands?
  Contact upstream and suggest him to
  move all non-controllable setup code to a separate function like
  *PACKAGE-install-default-key-bindings*.
* Does the code unconditionally set hooks like ``find-file-hooks``? Not
  good. Package should not change user's settings on load. You need to
  fix this by removing offending code and moving it into
  ``epackage/-*install`` and undo the effect in
  ``epackage/-*uninstall``. Make all your edits in a separate Git
  **patches** branch; see the pictures_ at the end of this document.
  Contact upstream and suggest him to move all setup code to a
  separate functions like *\*-install-{default-key-bindings,hooks}*.
* Is the package well structured and behaving? Run all code quality
  checks. Try also byte compiling. You can use e.g. `epackage.el`_ and
  ``M-x`` ``epackage-lint-file`` which uses standard
  Emacs features lisp-mnt, checkdoc etc. Report problems to upstream
  issue tracker.
* Does the code refer to a known license in `License Database`_? If not,
  contact upstream and suggest him to change (or add missing one). The
  recommended license is GPL, because that is the license of
  Emacs. If someday the extension finds its way to Emacs, the road is
  clear with GPL. *NOTE:* `Public Domain`_ is not an internationally
  viable license.
* Does the code include Emacs Lisp files (\*.el) that do not belong to the
  project? Sometimes other projects are included along with the
  package. This is a problem because then Emacs ``load-path`` would
  contains duplicate copies of the files. There would be no guarantee
  that the latest version from the original author, or standard Emacs,
  were used. In Git **patches** branch, just ``git rm`` any such files
  and merge your deletion to **master** branch. If there is not yet a
  package for those removed files, you need to package them separately from
  the original package and make the current package depend on them.

CONTACTING UPSTREAM

Is upstream still there? Find out his email from files, `Emacs Wiki`_ or
Google and send a mail to notify that his software is being packaged.
Ask what email address he prefers to use for contact. Ask where he
keeps latest code. Ask if he uses public Version Control and possibly
direct him to use Github. You can point him to read the Github_
instructions at the end of this file. It's very important to try to
reach upstream and build contact for future patches and improvement
suggestions.

When you have made contact, record it to field
``epackage/info::X-Development``. If there hasn't been updates for a
year, you can ping to see if the email still exists and he is
maintains the code. An example ::

    ...
    X-Development:
     YYYY-MM-DD upstream email confirmed.
    Description: test package with various functions
     Main command [C-u] M-x test-package runs various tests on
     the current lisp code. With a prefix argument, shows also
     notes and minor details.

If you hear nothing, consider twice packaging software which no longer
is actively developed or whose maintainer has gone with the winds of
time. The users will download the package and in many cases send bug
reports. Do you have the time to deal with those? Especially, if there
is no more upstream to forward requests to. Packaging dead code serves
no one unless you are able to serve as the new upstream.

FINISHING

After you've dug into all the previous steps, open account at Github_
and push the package. Notify `Sources List`_ about your new epackage
to make it available for others.

Making an epackage
------------------

1. Prepare an empty directory. If extension more than one file, stay
   at extension's root directory ans skip (3) ::

    mkdir extension
    cd extension

2. Initialize a Git repository. Start at *upstream* branch directly ::

    git init
    git symbolic-ref HEAD refs/heads/upstream

3. Download Emacs extension code ::

    wget http://example.com/project/some-mode.el

4. Determine version information and import code to Git repository.
   Use clear commit message ::

    git add *.el
    git commit -m "import upstream YYYY-MM-MM from http://example.com/path/file.el"

5. Mark the commit with a tag that has format
   ``upstream/<UPSTREAM-DATE>[--<UPSTREAM-VERSION>][-<DVCSINFO>]``. In case
   information about the release date is not available, use year only
   format YYYY-01-01. Leave out the ``--<UPSTREAM-VERSION>]`` if there
   is no information about release version. If the package is from a
   version control directory, it might be a good idea to add
   *-git-abc1234* (7 chars for Git), *hg-abcdef123456* or *-svn-12234*
   DVCSINFO suffix. An example ::

    egrep 'version|[0-9][0-9][0-9][0-9]' *.el

	Copyright (C) 2010 John Doe <jdoe@example.net>
	Last-Updated: 2010-05-10
	(defvar some-mode-version "1.0")

    git tag upstream/2010-05-10--1.0

6. Create *master* branch on top of *upstream* branch ::

    git branch -b master upstream

7. Copy the template files (which are available here, in this repository
   you're reading) ::

    mkdir epackage/
    cp <path>/info epackage/

8. Edit the information file. You need to search http://emacswiki.org,
   Google and study the extension's comments to fill in the details ::

    $EDITOR epackage/info

9. Last, write at least two files that will be used for installation.
   One is the *autoload* file and the other is the *install* file. You
   can also add optional *xactivate* file. Refer to
   <http://www.nongnu.org/emacs-epackage/manual>::

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
    # with 'require' (slows emacs start up).

    epackage/PACKAGE-install.el

#. Commit files to *master* branch ::

    git status                  # Verify that you're in branch "master"
    git add epackage/
    git commit -m "epackage/: new"

#. Upload the Git repository somewhere publicly available, e.g. to
   Github; see Addenum_ ::

    git remote add github <your URL>    # See section "Addenum"
    git push github upstream master
    git push github $(git tag -l "upstream/*")

#. Add information about this new epackage to the `Sources List`_ so
   that others know how to find it. The information needed is ::

    PACKAGE-NAME (from epackage/info::Package field)
    GIT-URL      (the public git repository URL)
    DESCRIPTION  (from epackage/info::Description, the 1st line)

Fork the `Sources List`_, clone it to your local disk, edit
add new information, commit, and send a *Pull request* through github.
See these page:

- http://help.github.com/forking/  (Forking a project)
- http://help.github.com/pull-requests/ (Sending pull requests)
- https://github.com/blog/270-the-fork-queue (Keeping fork in sync)

After your URL has been merged, update your copy of `Sources List`_ ::

    git pull

When upstream uses Git repository too
-------------------------------------

It is possible that the upstream is also using Git. In that case, the
steps 1-3 are as follows:

1. Prepare an empty directory ::

    mkdir extension
    cd extension

2. Instead of downloading, add a remote to track upstream code, pull,
   and merge ::

    git remote add upstream git://example.com/some-emacs-project
    git fetch upstream
    git checkout --track -b upstream upstream/master

3. Tag the commit you intend to package ::

    git checkout upstream

    git tag upstream/$(date "+%Y-%m-%d")--git-$(git rev-parse HEAD | cut -c1-7)

4. Switch to master and merge ::

    git checkout master
    git merge upstream/<tag name from previous step>

After that proceed as usual by adding ``epackage/`` directory as
outlined previously; see previous topic and number (7) onward.

To follow upstream development, from time to time pull and merge ::

    git checkout upstream
    git pull

    # tag it
    git tag upstream/$(date "+%Y-%m-%d")--git-$(git rev-parse HEAD | cut -c1-7)

    # Merge it
    git checkout master
    git merge <the tag name below>

When upstream IS also the packager (Git)
----------------------------------------

Say you are the upstream. You would like to put your Emacs extensions
available as epackages. All your code is in Git repositories. The
setup is easy:

* Create ``epackage/`` directory with necessary *info* and other
  install files.
* Create file ``epackage/format`` and add word "upstream" on its
  own line.

Essentially ::

    cd /to/your/project/

    # Install tools
    . /path/to/this-repository/epackage.shellrc

    # Install epackage/ directory
    Edir <package name> .

    # Mark this repository as "upstream"
    echo upstream > epackage/format

    # ... Now edit and remove files as needed in epackage/ directory
    # ... commit, push to Github

Notify `Sources List`_ maintainer about your repository.
More information can be found elsewhere in this document.

When upstream IS also the packager (Non-Git)
--------------------------------------------

Say you are the upstream. You would like to put your Emacs extensions
available as epackages. **You use version control system
other than Git to manage your code**. No problem. Continue to use what
you have. Only layer Git on top of it. This means that you initialize
Git on top of your current sources. The Git and your existing VCS
won't conflict. You switch to Git, when you commit your changes and
make them available as an epackage.

An example. Say you use Mercurial, or "Hg" for short ::

    cd /your/hg/project

    # commit any changes
    hg status

    # initialize Git on top of Hg
    git init
    echo ".hg" > .gitignore

    # Initial import, done only once
    git add .
    git commit -m "Initial import"

    # Install tools
    . /path/to/this-repository/epackage.shellrc

    # Examine commit date and revision. Tag accordingly.
    hg log --limit 1
    git tag epackage/YYYY-MM-DD--hg-abcdef12345

    # Install epackage/ directory
    Edir <package name> .

    # Mark this repository as "upstream"
    echo upstream > epackage/format

    # ... Now edit and remove files as needed in epackage/ directory
    # ... commit, push to Github

That's it. Notify `Sources List`_ maintainer about your repository.
More information can be found elsewhere in this document.

Keeping up to date with the upstream
------------------------------------

Periodically follow new releases of upstream code. Once upstream
releases new code, make an update.

1. Verify that the repository is in a clean state. Commit any changes ::

    git status

2. Download new upstream release ::

    /path/to/get.sh epackage/info	# utility from this template directory

    ... IF UPSTREAM USES VCS: the update will appear in directory
    ... epacakge/upstream and files are copied over the current sources. Be
    ... careful to note all removed or new files.
    ...
    ... IF UPSTREAM DOES NOT USE VCS: the new version of files are simply
    ... downloaded and old files are overwritten.

3. Switch to *upstream* branch ::

    git checkout upstream

4. Examine version and release date of upstream code. Commit and tag ::

    git add -A  # Import all changes since.
    git add ...
    git rm ...

    ... If upstream uses VCS: The date is the last commit date
    ... See e.g. "git log --max-count=1" or "{bzr,hg,svn] log --limit 1"

    git commit -m "import upstream YYYY-MM-DD <VCS revision if any> from http://example.com/path/file.el"

    ... Examine what are current dates and version
    egrep -i 'version|date|modified' *.el
    Ever

    ... If there is no VERSION announced in files, omit it and use the
    ... VCS details in the tag \"upstream/YYYY-MM-DD--svn-12345\".
    ... Notice the use of double dash to make it stand out from the date.

    git tag upstream/2010-06-10--1.13

5. Merge to epackage

    git checkout master
    git merge upstream

6. Update `epackage/` directory information ::

    Edef			# Regenerate epackage/*loaddef.el
    ... edit epackage/* files if needed
    ... commit
    ... test that all works

7. Push updated epackage for others to download ::

    git push upstream master
    git push --tags

.. _pictures:

Epackage Git repository management
==================================

At the beginning the Git repository tree looks like ::

    master:       o (the epackage/ added)
                 /
    upstream:   o
                1.0

After updating to the next upstream release, these two run in
parallel. The *upstream* is periodically merged to *master* branch ::

                  (merge: upstream)
    master:       o -- o -- =>
                 /    /
    upstream:   o -- o
                1.0  1.1

If you need to fix upstream code, make changes in separate *patches*
branch and merge those to *master*. Send patches to upstream so that you
don't need to maintain different code base. ::


                  (merge: upstream, patches)
    master:       o -- o -- o =>
                 /    /     ^
    upstream:   o -- o      |
                1.0  1.1    |
                      \     |
    patches:           o -- o


For big packages, use program called *pristine-tar(1)* to import
original archives in a separate, disconnected, **pristine-tar branch**.
This branch will be unrelated to the rest of the project history; it's
sole purpose is to store archives. The `Pristine Tar`_ intelligently
stores only deltas between the archives so it's very space efficient.
::

                  (merge: upstream, patches)
    master:       o -- o -- o =>
                 /    /     ^
    upstream:   o -- o      |
                1.0  1.1    |
                      \     |
    patches:           o -- o

    pristine-tar: package-1.0.tar.gz ...

The pristine-tar(1) workflow: ::

    # Do work in branch "upstream"

    git checkout upstream

    # Unpack sources

    tar -xf ../package-1.0.tar.gz
    mv package-1.0/* .
    rmdir package-1.0

    # Import and tag

    git add [--all] ...    (but don't include archice; *.tar.gz)
    git commit ...
    git tag upstream/YYYY-MM-DD--1.0

    # The utility will create the branch as needed. Output:
    #
    # pristine-tar: committed package-1.0.tar.gz.delta to branch pristine-tar

    pristine-tar commit ../package-1.0.tar.gz

    # List archives

    pristine-tar list

    # Retrive a archive

    pristine-tar checkout package-1.0.tar.gz

For more reading about Git branching work flows, study:

* `Debian Git upstream management <http://wiki.debian.org/ThomasKoch/GitPackagingWorkflow>`_
* `A successful Git branching model <http://nvie.com/posts/a-successful-git-branching-model/>`_

.. _addenum:
.. _github:

Addenum
=======

How to set up project at Github
-------------------------------

If you use Windows, install <http://cygwin.com> environment which
contains everything from Emacs, Git, SSH and so on. The instructions
below are for Cygwin, Linux Mac terminal:

1. Generate the SSH keys.

If you don't have SSH key pair (private, public) already, refer to
generating SSH keys for Linux at
https://help.github.com/articles/generating-ssh-keys

2. Register a Github account

Visit front page at https://github.com

3. After sign up, log in to your account

[top right] select icon *account settings* and from new page
[left menu] *SSH keys*. Select [button] **Add SSH key**

4. Create a project repository

[top right icon, back to your main page] ``https://github.com/<login>``.
At top left, click icon **Create a new Git repo**.
After finishing, Write down the shown``git://`` repository URL.

5. Type in command line: ::

    # Tell who you are
    git config --global user.name "FirstName LastName"
    git config --global user.email "me@example.com"

    cd ~/dir/project                    # Your source code
    git init                            # Initialize
    git add .                           # add ALL files
    git commit -m "Initial import"      # Save into version control

    # Let Git know about Github
    # This the "git://" URL that you wrote down in step 4

    git remote add github git@github.com:<your github>/project.git

    # Push your changes to Github

    git push github master

That should be all. For more information about Git, see:

- http://www.kernel.org/pub/software/scm/git/docs
- http://git-scm.com
- http://gitref.org
- http://gitcasts.com

Copyright and License
=====================

Copyright (C) 2010-2013 Jari Aalto <jari.aalto@cante.net>

The material is free; you can redistribute and/or modify it under
the terms of GNU General Public license either version 2 of the
License, or (at your option) any later version.

End of file
