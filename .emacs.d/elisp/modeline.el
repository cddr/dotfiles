
(progn
  (defun add-mode-line-dirtrack ()
    (add-to-list 'mode-line-buffer-identification 
                 '(:propertize (" " default-directory " ") face mode-line)))
  (add-hook 'shell-mode-hook 'add-mode-line-dirtrack))

(provide 'modeline)
