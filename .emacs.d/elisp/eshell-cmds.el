(require 'eshell)

(defun eshell/mkd (dir)
  (make-directory dir)
  (cd dir))

(defun eshell/gitio (url)
  (let ((path (shell-command-to-string
               (format "curl -s http://git.io/create -F \"url=%s\""
                       url))))
    (format "https://git.io/%s" path)))

(defun eshell/gg (regexp)
  (vc-git-grep regexp "*" "~/Projects/bilcas")
  (switch-to-buffer-other-window "*grep*"))

(defun eshell/pr (prefix)
  (let* ((current-branch (replace-regexp-in-string "\\\n" ""
                          (shell-command-to-string "git rev-parse --abbrev-ref HEAD")))
         (remote-branch (format "%s/%s" prefix current-branch))
         (cmd (format "git push origin %s:%s"
                      current-branch remote-branch)))
    (insert cmd)))

