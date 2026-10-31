;;; -*- lexical-binding: t; -*-

(setq package-enable-at-startup nil)

;; set-local was added in Emacs 31.1; this build (31.0.50) predates it.
;; compat skips defining it because emacs-version >= "31", so we fill the gap.
(unless (fboundp 'set-local)
  (defun set-local (variable value)
    "Make VARIABLE buffer local and set it to VALUE."
    (set (make-local-variable variable) value)))
