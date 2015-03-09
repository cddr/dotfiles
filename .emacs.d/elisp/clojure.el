

(add-to-list 'load-path "~/.emacs.d/vendor/cider")
(require 'cider)
(require 'clojure-mode)

(define-clojure-indent
  (defroutes 'defun)
  (GET 2)
  (POST 2)
  (PUT 2)
  (DELETE 2)
  (HEAD 2)
  (ANY 2)
  (context 2))

(define-clojure-indent
  (form-to 'defun))

(defun my-init-clojure-mode ()
  (cider-turn-on-eldoc-mode)
  (setq cider-repl-print-length 100)        
  (local-set-key (kbd "<f5>") 'run-tests))

(add-hook 'cider-mode-hook 'my-init-clojure-mode)

(defun browser-repl ()
  (interactive)
  (cider-interactive-eval "(cemerick.austin.repls/exec)"))

(defun run-tests ()
  (interactive)
  (cider-interactive-eval "(user/reset-then-test)"))

(provide 'clojure)
