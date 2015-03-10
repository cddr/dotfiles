(require 'whitespace)
(require 'grep)

;;;###autoload
(dolist (pattern '("Capfile\\'" "Gemfile\\'" "Rakefile\\'" "Vagrantfile\\'"
                     "\\.rake\\'" "\\.rb\\'" "\\.ru\\'"))
  (add-to-list 'auto-mode-alist (cons pattern 'ruby-mode)))

(defun webteam-standards ()
  (whitespace-mode)
  (setq indent-tabs-mode nil
        ruby-indent-level 2
        ruby-deep-arglist 0
        whitespace-line-column 115
        whitespace-style '(face empty tabs lines-tail trailing)))

(add-hook 'ruby-mode-hook 'webteam-standards)

(provide 'ruby)
