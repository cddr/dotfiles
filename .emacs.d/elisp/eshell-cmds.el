(require 'eshell)

(defun eshell/mkd (dir)
  (make-directory dir)
  (cd dir))

(defun eshell/gitio (url)
  (let ((path (shell-command-to-string
               (format "curl -s http://git.io/create -F \"url=%s\""
                       url))))
    (format "https://git.io/%s" path)))
