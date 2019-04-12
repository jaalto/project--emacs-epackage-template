#   Copyright
#
#	Copyright (C) 2011-2015 Jari Aalto <jari.aalto@cante.net>
#
#   License
#
#	This program is free software; you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation; either version 2 of the License, or
#	(at your option) any later version.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with this program. If not, see <http://www.gnu.org/licenses/>.
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

SRCCHECK = $(SRCS:.sh=.xcheck) $(SRCS1:.shellrc=.xcheck)

.SUFFIXES:
.SUFFIXES: .sh .shellrc .xsh .xposh .xdash .xcheck

.sh.xsh:
	sh -nx $< > $@
.sh.xposh:
	posh -nx $< > $@
.sh.xdash:
	dash -nx $< > $@
.sh.xcheck:
	-checkbashisms $< > $@

.shellrc.xsh:
	sh -nx $< > $@
.shellrc.xposh:
	posh -nx $< > $@
.shellrc.xdash:
	dash -nx $< > $@
.shellrc.xcheck:
	-checkbashisms $< > $@

all:
	@echo "Nothing to do. Run: make help"

help:
	@echo "Select make <target>:"
	@echo "---------------------"
	@grep '^# .*-' Makefile | sed 's,# ,,' | sort

# clean - delete files that can be generated
clean:
	rm -f *.x*

# check - run syntax checks
lint:  $(SRCCHECK)

# test - run tests to check files for errors
test: $(SRCTEST) lint

# install - empty target, does nothing
install:
	@echo "There is no install. Use this directory as is for your workflow."

# End of file
