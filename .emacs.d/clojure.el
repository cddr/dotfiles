;;; -*- lexical-binding: t; -*-


(use-package clojure-mode :straight t
	;; Claude skills are Clojure source in SKILL.md. Do this here, not with a
	;; .dir-locals.el `mode' entry: that also hits the Dired buffer for the directory.
	:mode ("/SKILL\\.md\\'" . clojure-mode)
	:bind (("C-c r" . cider-switch-to-repl-buffer)
				 ("C-c t" . add-type))
	:custom (cider-clojure-cli-global-options "-J-XX:-OmitStackTraceInFastThrow"
           cider-print-options '(("length" 10)
																 ("right-margin" 70))))

(use-package cider :straight t
	:hook ((cider-mode . (lambda ()
												 (cider-eldoc-setup)))
         (after-init . (lambda ()
												 (require 'clojure-mode)
												 (load (expand-file-name "~/.emacs.d/clojure-indentation.el"))))))
