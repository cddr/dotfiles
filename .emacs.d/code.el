;;; -*- lexical-binding: t; -*-

;; utilities applicable to editing code in any language

(use-package direnv :straight t
	:config
	(direnv-mode))

(use-package web-mode :straight t
	:config
	(setq web-mode-markup-indent-offset 2))

(use-package whitespace
  :diminish
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook #'whitespace-mode))
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  :config
  (setq whitespace-style '(face trailing lines-tail)
        whitespace-global-modes '(not erc-mode)
        whitespace-line-column 80))

(use-package saveplace
  :straight nil
  :init (setq save-place-file (expand-file-name ".places" user-emacs-directory))
  :config
  (save-place-mode 1))

(use-package transient :straight t)
(use-package magit :straight t)

(use-package gist :straight t
  :bind (("C-c G" . gist-region-or-buffer)))


(defun unfill-region (beg end)
  "Unfill the region, joining text paragraphs into a single
    logical line.  This is useful, e.g., for use with
    `visual-line-mode'."
  (interactive "*r")
  (let ((fill-column (point-max)))
    (fill-region beg end)))
