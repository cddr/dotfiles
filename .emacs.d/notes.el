;;; -*- lexical-binding: t; -*-
(use-package denote
  :straight t
  :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c n n" . denote)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired)
   ("C-c n g" . denote-grep))
  :config
  ;; Where notes live is machine-specific: NOTES_DIR comes from the shell (the
  ;; private overlay sets it to the work Drive). Read it here, not from work.el,
  ;; because denote loads lazily and this :config can run after the overlay.
  (setq denote-directory (expand-file-name (or (getenv "NOTES_DIR") "~/notes")))

  ;; Automatically rename Denote buffers when opening them so that
  ;; instead of their long file name they have, for example, a literal
  ;; "[D]" followed by the file's title.  Read the doc string of
  ;; `denote-rename-buffer-format' for how to modify this.
  (denote-rename-buffer-mode 1))

(use-package denote-org :straight t)
