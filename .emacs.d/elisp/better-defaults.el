;;; better-defaults.el --- Fixing weird quirks and poor defaults

;; Copyright © 2013 Phil Hagelberg

;; Author: Phil Hagelberg
;; URL: https://github.com/technomancy/better-defaults
;; Version: 0.1.2
;; Created: 2013-04-16
;; Keywords: convenience

;; This file is NOT part of GNU Emacs.

;;; Commentary:

;; There are a number of unfortunate facts about the way Emacs works
;; out of the box. While all users will eventually need to learn their
;; way around in order to customize it to their particular tastes,
;; this package attempts to address the most obvious of deficiencies
;; in uncontroversial ways that nearly everyone can agree upon.

;; Obviously there are many further tweaks you could do to improve
;; Emacs, (like those the Starter Kit and similar packages) but this
;; package focuses only on those that have near-universal appeal.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

;;;###autoload
(progn
  (ido-mode t)
  (setq ido-enable-flex-matching t)

  (menu-bar-mode 1)
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
  (when (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

  (require 'uniquify)
  (setq uniquify-buffer-name-style 'forward)

  (require 'saveplace)
  (setq-default save-place t)

  (defmacro global-defkey (key def)
    `(global-set-key (read-kbd-macro ,key) ,def))

  (global-defkey "M-/" 'hippie-expand)
  (global-defkey "C-x C-b" 'ibuffer)

  (global-defkey "C-s" 'isearch-forward-regexp)
  (global-defkey "C-r" 'isearch-backward-regexp)
  (global-defkey "C-M-s" 'isearch-forward)
  (global-defkey "C-M-r" 'isearch-backward)

  (global-defkey "C-c o" 'browse-url)

  (show-paren-mode 1)
  (setq-default indent-tabs-mode nil)
  (setq x-select-enable-clipboard t
        x-select-enable-primary t
        save-interprogram-paste-before-kill t
        apropos-do-all t
        mouse-yank-at-point t
        save-place-file (concat user-emacs-directory "places")
        backup-directory-alist `(("." . ,(concat user-emacs-directory
                                                 "backups"))))

  ; http://emacs.1067599.n5.nabble.com/bug-12183-24-1-50-Unrecognized-pasteboard-formats-quit-yank-in-Emacs-app-td261226.html
  (when (eq system-type 'darwin)
    (defun ns-get-pasteboard ()
      "Returns the value of the pasteboard, or nil for unsupported formats."
      (condition-case nil
          (ns-get-selection-internal 'CLIPBOARD)
        (quit nil))))

  )

(provide 'better-defaults)
;;; better-defaults.el ends here
