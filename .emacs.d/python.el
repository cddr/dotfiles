;;; -*- lexical-binding: t; -*-
;; python utils  -*- lexical-binding: t; -*-

(use-package virtualenvwrapper :straight t
	:config
	(setq venv-location (expand-file-name "~/.virtualenvs")))
