(require 'whitespace)
(require 'grep)

;;;###autoload
(dolist (pattern '("Capfile\\'" "Gemfile\\'" "Rakefile\\'" "Vagrantfile\\'"
                     "\\.rake\\'" "\\.rb\\'" "\\.ru\\'"))
  (add-to-list 'auto-mode-alist (cons pattern 'ruby-mode)))

(defun webteam-standards ()
  (setq indent-tabs-mode nil
        ruby-indent-level 2
        ruby-deep-arglist 0
        whitespace-line-column 115
        whitespace-style '(face empty tabs lines-trail trailing))
  (whitespace-mode))

(add-hook 'ruby-mode-hook 'webteam-standards)

(provide 'ruby)
