#!/bin/sh
#
#   Copyright
#
#       Copyright (C) 2010-2011 Jari Aalto <jari.aalto@cante.net>
#
#   License
#
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#       GNU General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#       along with this program. If not, see <http://www.gnu.org/licenses/>.

set -e

pwd=$( cd $(dirname $0); pwd )		# The epackeg/ path
vcsdir=upstream				# The VCS download directory
agent="Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) Gecko/20090913 Firefox/3.5.3";

Help ()
{
    echo "\
SYNOPSIS
    [TEST=1] $0

DESCRIPTION

    epackage directory: $pwd

    Generic POSIX shell download script for Emacs epackages. Typically
    located under name epackage/get.sh. Reads information from
    epackage/info file. If the Field 'Vcs-Type' is \"http\", download
    single file to \"epackage/..\" directory. If type is anything
    else, download repository pointed by field 'Vcs-Url' into
    subdirectory \"epackage/$vcsdir\" and copy all file recursively under
    it to epackage/.."

    exit 0
}

Initialize ()
{
    # Define global variables

    pkg=$( awk '/^Package:/    {print $2}' "$pwd/info" )
    vcs=$( awk '/^Vcs-Type:/   {print $2}' "$pwd/info" )
    url=$( awk '/^Vcs-Url:/    {print $2}' "$pwd/info" )
    args=$( awk '/^Vcs-Args:/  {sub("Vcs-Args:",""); print }' "$pwd/info" )
}

Run ()
{
    ${TEST:+echo} "$@"
}

UpdateLispFiles ()
{
    dir="$1"

    if [ "$vcs" = "http" ]; then
	return 0			# Skip
    fi

    cd "$vcsdir" &&
    Run tar -cf - \
      $(find . -type d \( -name .$vcs \) -prune  \
	-a ! -name .$vcs \
	-o \( -type f -a ! -name .${vcs}ignore \)
       ) |
    Run tar -C "$pwd/.." -xvf -
}

CVS ()
{
    url=$@

    if [ ! -d "$vcsdir" ]; then
	echo "# When asked, Press ENTER at login password..."
	Run cvs -d "$url" login
	Run cvs -d "$url" co -d "$vcsdir" $args

    else
	( Run cd "$vcsdir" && Run cvs update -d -I\! )
    fi
}

Vcs ()
{
    vcs=$1
    url=$@

    if [ ! -d "$vcsdir" ]; then
	$vcs clone "$url" "$vcsdir"
    else
	( Run cd "$vcsdir" && Run $vcs update )
    fi
}

Main ()
{
    Initialize

    case "$*" in
	-h | --help) Help ;;
    esac

    case "$vcs" in
	http )
	    Run cd $pwd/..
	    Run wget --user-agent="$agent" \
		 --no-check-certificate \
		 --timestamping \
		"$url" \
		"$args"
	    ;;
	[a-z]* )
	    Run cd "$pwd"
	    if [ "$vcs" = "cvs" ]; then
		CVS "$url"
	    else
		Vcs "$vcs" "$url"
	    fi
	    ;;
	*)  echo "Unknown Vcs-Type: $vcs Vcs-Url: $url" >&2
	    return 1
	    ;;
    esac &&
    UpdateLispFiles "$vcs" "$vcsdir"
}

Main "$@"

# End of file
