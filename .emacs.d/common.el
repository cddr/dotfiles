;;; -*- lexical-binding: t; -*-

;; Speed up startup by temporarily increasing GC threshold
(setq gc-cons-threshold (* 50 1024 1024))
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold (* 2 1024 1024))))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; Core Utilities & Modern UI
(use-package no-littering)

(use-package solarized-theme
  :config
  (load-theme 'solarized-dark t)
  :custom
  (solarized-use-variable-pitch nil)
  (solarized-scale-org-headlines nil))

;; The theme's ANSI blue (#4695f7) is hard to read on the dark background.
;; Set it on the `user' theme so it survives `load-theme'/`customize-themes'.
;; ghostel, eshell and compilation buffers all inherit from this face.
(custom-theme-set-faces 'user
 '(ansi-color-blue ((t (:foreground "#7aa7dd" :background "#7aa7dd")))))

(use-package mermaid-mode
  :straight t
  :mode "\\.mmd\\'"
  :config
  ;; Path to the mmdc executable if it's not detected automatically
  ;; (setq mermaid-mmdc-location "mmdc")

  ;; Set preferred default export format (png, svg, or pdf)
  (setq mermaid-output-format "png"))

(defun my/mermaid-export-to-browser ()
  "Extract current Mermaid block and open in browser with extra large, highly readable text."
  (interactive)
  (let* ((case-fold-search t)
         (bound-start (save-excursion
                        (if (re-search-backward "\\(#\\+BEGIN_SRC[ \t]+mermaid\\|```[ \t]*mermaid\\)" nil t)
                            (match-end 0)
                          (error "No Mermaid block start found above point"))))
         (bound-end (save-excursion
                      (goto-char bound-start)
                      (if (re-search-forward "\\(#\\+END_SRC\\|```\\)" nil t)
                          (match-beginning 0)
                        (error "No Mermaid block end found below point")))))
    (if (and (>= (point) bound-start)
             (<= (point) bound-end))
        (let* ((code (string-trim (buffer-substring-no-properties bound-start bound-end)))
               (out-dir (file-name-as-directory (make-temp-file "mermaid-web-" t)))
               (index-file (concat out-dir "index.html"))
               (html-template
                "<!DOCTYPE html>
<html>
<head>
  <meta charset=\"utf-8\">
  <title>Mermaid Preview</title>
  <style>
    body {
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      margin: 0;
      padding: 40px;
      background-color: #f8fafc;
      font-family: system-ui, -apple-system, sans-serif;
      box-sizing: border-box;
    }
    .diagram-card {
      background: #ffffff;
      padding: 48px;
      border-radius: 16px;
      border: 1px solid #e2e8f0;
      box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05);
      width: 100%%;
      max-width: 1400px;
      overflow-x: auto;
    }
    /* Scale SVG and force large text rendering across nodes, edges, and subgraphs */
    .mermaid svg {
      width: 100%% !important;
      max-width: 100%% !important;
      height: auto !important;
    }
    .mermaid text,
    .mermaid .nodeText,
    .mermaid .edgeLabel,
    .mermaid .label,
    .mermaid .cluster-label {
      font-size: 22px !important;
      font-weight: 700 !important;
    }
  </style>
  <script type=\"module\">
    import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
    mermaid.initialize({
      startOnLoad: true,
      theme: 'base',
      fontSize: 22,
      flowchart: {
        nodeSpacing: 60,
        rankSpacing: 60,
        padding: 20
      },
      sequence: {
        actorFontSize: 22,
        messageFontSize: 20,
        noteFontSize: 18
      },
      themeVariables: {
        darkMode: false,
        fontSize: '22px',
        fontFamily: 'system-ui, -apple-system, sans-serif',
        background: '#ffffff',
        primaryColor: '#e0e7ff',
        primaryBorderColor: '#4338ca',
        primaryTextColor: '#1e1b4b',
        secondaryColor: '#f3e8ff',
        secondaryBorderColor: '#7e22ce',
        secondaryTextColor: '#3b0764',
        tertiaryColor: '#d1fae5',
        tertiaryBorderColor: '#047857',
        tertiaryTextColor: '#064e3b',
        lineColor: '#2563eb',
        textColor: '#0f172a',
        mainBkg: '#e0e7ff',
        nodeBorder: '#4338ca',
        clusterBkg: '#f1f5f9',
        clusterBorder: '#cbd5e1',
        titleColor: '#0f172a',
        edgeLabelBackground: '#f1f5f9'
      }
    });
  </script>
</head>
<body>
  <div class=\"diagram-card\">
    <pre class=\"mermaid\">
%s
    </pre>
  </div>
</body>
</html>")
               (html-content (format html-template code)))
          ;; Write the index.html file
          (with-temp-file index-file
            (insert html-content))
          ;; Open in browser
          (browse-url-of-file index-file)
          (message "Opened large-text Mermaid preview in browser!"))
      (error "Point is not inside a Mermaid block"))))

;; 4. Custom Functions
(defun reload-dir-locals ()
  "Reload dir locals for the current buffer."
  (interactive)
  (let ((enable-local-variables :all))
    (hack-dir-local-variables-non-file-buffer)))

(defun dos2unix ()
  "Modern replacement for line-ending conversion."
  (interactive)
  (set-buffer-file-coding-system 'unix 't))


;; Completion stack
(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-preselect 'first))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("M-s l" . consult-line)
         ("M-g i" . consult-imenu))
  :init
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5
        xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep :preview-key '(:debounce 0.4 any)))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; 6. Miscellaneous Packages (Deferred for speed)
(use-package e2ansi :defer t)
(use-package git-link :defer t)
(use-package graphviz-dot-mode :mode "\\.dot\\'")
(use-package default-text-scale
  :bind (("C-x C-=" . default-text-scale-increase)
         ("C-x C--" . default-text-scale-decrease)))

;; 7. Load external settings (Read only once)
(let ((settings-file (expand-file-name "settings.el" user-emacs-directory)))
  (when (file-exists-p settings-file)
    (load settings-file)))

;; Machine-local Custom output (untracked): "save for future sessions" writes here,
;; so approvals and other local choices never end up in this repository.
(when (and custom-file (file-exists-p custom-file))
  (load custom-file))
