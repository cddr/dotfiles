
;; standard packages
(when (fboundp 'package-initialize)
  (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			   ("melpa" . "http://melpa.milkbox.net/packages/")))
  (package-initialize)

  (dolist (p '(better-defaults solarized-theme company

               magit

               clojure-mode))
    (package-install p)))

;; local customization
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-hook 'after-init-hook 'global-company-mode)

(require 'better-defaults)
(require 'web-shortcuts)
(require 'git)
(require 'ruby)
(require 'clojure)

(progn
  (setq custom-file "~/.emacs.d/custom-file.el")
  (load custom-file))

(progn
  (when (file-exists-p "~/.emacs.d/private.el")
    (load "~/.emacs.d/private.el")))

;; initialization
(server-start)
(eshell)

