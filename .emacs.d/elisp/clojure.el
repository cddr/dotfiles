

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

(add-hook 'cider-mode-hook #'cider-eldoc-mode)

(provide 'clojure)
