(require 'whitespace)

(progn
  (dolist (pattern '("Capfile\\'" "Gemfile\\'" "Rakefile\\'" "Vagrantfile\\'"
                     "\\.rake\\'" "\\.rb\\'" "\\.ru\\'"))
    (add-to-list 'auto-mode-alist (cons pattern 'ruby-mode)))

  (defun ruby-insert-breakpoint ()
    (interactive)
    (beginning-of-line)
    (split-line)
    (indent-according-to-mode)
    (insert "byebug"))

  ;; (defun my-ruby-bindings
  ;;   (define-key ruby-mode-map (kbd "C-c b") 'ruby-insert-breakpoint))
  ;; (add-hook 'ruby-mode-hook 'my-ruby-bindings)

  (defun webteam-standards ()
    (whitespace-mode nil)
    (setq indent-tabs-mode nil
          ruby-indent-level 2
          ruby-deep-arglist 0
          whitespace-line-column 115
          whitespace-style '(face empty tabs lines-tail trailing)))

  (add-hook 'ruby-mode-hook 'webteam-standards)
  (add-hook 'ruby-mode-hook (lambda ()
                              (interactive)
                              (add-to-list 'grep-files-aliases '("rb" . "*.rb"))))

  )


(provide 'ruby)
