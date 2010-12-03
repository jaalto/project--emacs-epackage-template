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
#   Decription
#
#	Download "Vcs-Type: http" pointed by "Vcs-Url: URL"

set -e

pwd=$( cd $(dirname $0); pwd )		#  epackage/ directory
pkg=$( awk '/^Package:/  {print $2}' "$pwd/info" )
url=$( awk '/^Vcs-Url:/  {print $2}' "$pwd/info" )
agent="Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) Gecko/20090913 Firefox/3.5.3";

cd "$pwd/.."
wget --user-agent="$agent" --no-check-certificate --timestamping "$url"

# End of file
