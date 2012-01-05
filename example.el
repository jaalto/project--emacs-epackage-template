** This file presents the standardized Emacs Lisp package according to
** best practises. See http://pinboard.in/u:jariaalto/t:emacs/t:dev/t:qa
** Remove this info by placing cursor at very top and pressing C-u C-k

;; example.el --- <description> -*-coding: utf-8 -*-

;; Copyright (C) YYYY-YYYY First Last <address@example.com>

;; Author:      First Last <address@example.com>
;; Maintainer:  First Last <address@example.com>
;; Created:     <YYYY-MM-DD>
;; Version:     <pure numeric: N.N, N.N.N>
;; Keywords:    <M-x finder-list-keywords, separated by commas>
;; URL:         http://example.com/elisp

;; This file is not part of Emacs

;; This program is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 3 of the License, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;; or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
;; for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.
;;
;; Visit <http://www.gnu.org/copyleft/gpl.html> for more information.

;;; Depends:

;; <list of external Emacs Lisp packges, or programs(1)>

;;; Install:

;; Put this file along your Emacs-Lisp `load-path' and add following
;; into your ~/.emacs startup file.
;;
;;      <at standards TAB position explain what lisp code is needed>
;;      (autoload 'example-install "example" "" t)
;;      (autoload 'example-mode    "example" "" t)

;;; Commentary:

;; <Write how the package came to be. What problem it solves.
;; why would it be useful. What are the benfits. Compaed to other
;; similar packages? Give exmaples how to use and what keys
;; user might be interested in binding.
;;
;; In short, this is the manual section of the package>

;;; Change Log:

;; <Change history. If you user version control, this section is empty>

;;; Code:

;; Write code here. defcustom first, then defconst, defvar,
;; defsubst/defmacro and defuns last
;;
;; Remember to add ###autoload stanzas to important variables and functions
;;
;; *ALWAYS* use a PACKAGE-* prefix for variables, functions. This
;; keeps the name space safe.
;;
;; *NEVER* modify user's environment just by loading this file.
;;
;; *NEVER* add any global key bindings unconditionally. For those
;; purposes add PACKAGE-install-keybindings, PACKAGE-install-hooks
;; setup functions and instruct in "Install:" user call to those.
;;
;; See:
;; http://www.gnu.org/software/emacs/manual/html_mono/elisp.html#Library-Headers
;; http://www.gnu.org/software/emacs/manual/html_mono/elisp.html#Autoload
;; http://www.gnu.org/software/emacs/manual/html_mono/elisp.html#Customization

(defgroup example nil
  "<Write a short description of package here; a summary>"
  :group 'extensions)

(defcustom example-flag nil
  "*If non-nil, enable..."
  :type 'boolean
  :group 'example)


;;;###autoload
(defun example-install ()
  "Install hooks etc.")

(provide 'example)

;;; example.el ends here.
