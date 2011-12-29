#   Copyright
#
#       Copyright (C) 2011-2012 Jari Aalto <jari.aalto@cante.net>
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
#   Depends
#
#	Debian packages: posh, devscripts (for checkbashisms)
#
#   Description
#
#	This file is used by maintainer. Nothing for the regular user.

ifneq (,)
This makefile requires GNU Make.
endif

SRCS	= get.sh get-http.sh
SRCTEST	= $(SRCS:.sh=.xsh) $(SRCS:.sh=.xposh) $(SRCS:.sh=.xdash)

SRCS1	= epackage.shellrc
SRCTEST	+= $(SRCS1:.shellrc=.xsh) $(SRCS1:.shellrc=.xposh) $(SRCS1:.shellrc=.xdash)

.SUFFIXES:
.SUFFIXES: .sh .shellrc .xsh .xposh .xdash

.sh.xsh:
	sh -nx $< > $@
.sh.xposh:
	posh -nx $< > $@
.sh.xdash:
	dash -nx $< > $@

.shellrc.xsh:
	sh -nx $< > $@
.shellrc.xposh:
	posh -nx $< > $@
.shellrc.xdash:
	dash -nx $< > $@

all:
	@echo "Nothing to do. Run: make help"

help:
	@egrep "^#.* - " Makefile | sed "s/^# Rule - //" | sort

# Rule - clean: Delete files that can be generated
clean:
	rm -f *.x*

# Rule - test: Run tests to check for errors.
test: $(SRCTEST)

# End of file
