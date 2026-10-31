;;; -*- lexical-binding: t; -*-

;; (use-package shell :straight nil
;; 	:bind (("C-c s" . shell)))

(use-package mise :straight t
	:hook (after-init . global-mise-mode))

(use-package exec-path-from-shell :straight t
	;; A daemon starts with no window-system, so test (daemonp) too.
	:if (or (memq window-system '(mac ns x)) (daemonp))
	:config
	(setq exec-path-from-shell-variables
				'("PATH" "MANPATH" "NOTES_DIR"
					"AWS_SESSION_TOKEN" "AWS_SECRET_ACCESS_KEY" "AWS_ACCESS_KEY_ID" "AWS_REGION"))
	(exec-path-from-shell-initialize))

(use-package eshell :straight nil
	:after (virtualenvwrapper)
	:config
	(venv-initialize-eshell)
	(setenv "PAGER" "cat"))

(use-package eat
  :straight t)

(defun my/claude-at-point (&optional arg)
  "Launch Claude CLI with alias expansion in Ghostel at context directory."
  (interactive "P")
  (let* ((target-dir (if arg
                         (read-directory-name "Run Claude in: " default-directory)
                       (if (and (fboundp 'project-current) (project-current))
                           (project-root (project-current))
                         default-directory)))
         (buf-name (format "*claude: %s*" (file-name-nondirectory (directory-file-name target-dir))))
         (buf (get-buffer-create buf-name))
         (shell-binary (or (getenv "SHELL") "/bin/sh")))

    (pop-to-buffer buf)

    (unless (and (bound-and-true-p ghostel-mode)
                 (get-buffer-process buf)
                 (process-live-p (get-buffer-process buf)))
      (setq default-directory target-dir)
      ;; -i forces loading aliases and functions from interactive rc files
      (ghostel-exec buf shell-binary (list "-i" "-c" "claude")))))

(use-package ghostel
  :straight (ghostel :type git :host github :repo "dakra/ghostel"
                     :files (:defaults
                             ("etc/terminfo/78/xterm-ghostty" . "etc/terminfo/78/xterm-ghostty")
                             ("etc/terminfo/x/xterm-ghostty" . "etc/terminfo/x/xterm-ghostty")
                             ("etc/terminfo/67/ghostty" . "etc/terminfo/67/ghostty")
                             ("etc/terminfo/g/ghostty" . "etc/terminfo/g/ghostty")))
  ;; Keep the native module outside straight's build dir: straight
  ;; regenerates that dir from :files on rebuild, which silently
  ;; deletes the .dylib since it isn't a declared package file.
	:bind (("C-c s" . ghostel)
				 ("C-c p" . my/claude-at-point))
  :custom
  (ghostel-module-directory (no-littering-expand-var-file-name "ghostel/")))
