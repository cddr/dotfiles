
;; standard packages
(when (fboundp 'package-initialize)
  (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
													 ("melpa" . "http://melpa.milkbox.net/packages/")))
  (package-initialize)

  (dolist (p '(better-defaults solarized-theme

               magit

               clojure-mode))
    (package-install p)))

;; local customization
(add-to-list 'load-path "~/.emacs.d/elisp")

;; (require 'better-defaults)
;; (require 'exec-path)
(require 'web-shortcuts)
(require 'git)
;; (require 'ruby)
;; (require 'clojure)

(progn
  (setq custom-file "~/.emacs.d/custom-file.el")
  (load custom-file))

;; initialization
(server-start)
(eshell)

