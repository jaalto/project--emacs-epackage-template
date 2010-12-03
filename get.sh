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
#
#   Descriptions
#
#	Generic POSIX shell download script. Located under name epackage/get.sh
#	and reads information from epackage/info file. If the Vcs-Type is "http",
#	download single file to epackage/.. directory. If the download type is
#	anything else, download the VCS into subdirectory epackage/upstream and
#	copy all files under it recursively to epackage/..

set -e

pwd=$( cd $(dirname $0); pwd )		# The epackeg/ path
vcsdir=upstream				# The VCS download directory
agent="Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) Gecko/20090913 Firefox/3.5.3";

Initialize ()
{
    # Define global variables

    pkg=$( awk '/^Package:/    {print $2}' "$pwd/info" )
    vcs=$( awk '/^Vcs-Type:/   {print $2}' "$pwd/info" )
    url=$( awk '/^Vcs-Url:/    {print $2}' "$pwd/info" )
    args=$( awk '/^Vcs-Args:/  {print $2}' "$pwd/info" )
}

UpdateLispFiles ()
{
    dir="$1"

    if [ "$vcs" = "http" ]; then
	return 0			# Skip
    fi

    cd "$dir" &&
    tar -cf - \
      $(find . -type d \( -name .$vcs \) -prune  \
	-a ! -name .$vcs \
	-o \( -type f -a ! -name .${vcs}ignore \)
       ) |
    tar -C "$pwd/.." -xvf -
}

CVS ()
{
    url=$@

    if [ ! -d "$dir" ]; then
	echo "# When asked, Press ENTER at login password..."
	cvs -d "$url" login
	cvs -d "$url" co -d "$dir" $args

    else
	( cd "$dir" && cvs update -d -I\! )
    fi
}

Vcs ()
{
    vcs=$1
    url=$@

    if [ ! -d "$dir" ]; then
	$vcs clone "$url" "$dir"
    else
	( cd "$dir" && $vcs update )
    fi
}

Main ()
{
    Initialize

    case "$vcs" in
	http )
	    cd $pwd/..
	    wget --user-agent="$agent" \
		 --no-check-certificate \
		 --timestamping \
		"$url"
	    ;;
	[a-z]* )
	    cd "$pwd"
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
    UpdateLispFiles "$vcs" "$dir"
}

Main "$@"

# End of file
