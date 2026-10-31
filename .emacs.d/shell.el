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
	:bind (("C-c s" . ghostel))
  :custom
  (ghostel-module-directory (no-littering-expand-var-file-name "ghostel/")))
