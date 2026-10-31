;;; -*- lexical-binding: t; -*-

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(global-font-lock-mode t)

;; Load Claude Code integration tools
;;(load-file "~/.emacs.d/llms.el")

(load (expand-file-name "~/.emacs.d/common.el"))
(load (expand-file-name "~/.emacs.d/code.el"))
(load (expand-file-name "~/.emacs.d/python.el"))
(load (expand-file-name "~/.emacs.d/clojure.el"))
;; (load (expand-file-name "~/.emacs.d/llms.el"))
(load (expand-file-name "~/.emacs.d/shell.el"))
(load (expand-file-name "~/.emacs.d/navigation.el"))
(load (expand-file-name "~/.emacs.d/notes.el"))
																				;(load (expand-file-name "~/.emacs.d/metrics.el"))

(when (eq 'darwin system-type)
	(load (expand-file-name "~/.emacs.d/osx.el")))

;; Private overlay (work config), from a separate repo; skipped when absent
(load (expand-file-name "~/.config/work/emacs/work.el") t t)

(require 'server)
(unless (server-running-p)
	(server-start))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(global-set-key (kbd "C-x A-3") 'server-edit)

;; (diary)
(put 'narrow-to-region 'disabled nil)
