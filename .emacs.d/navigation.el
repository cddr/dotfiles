;;; -*- lexical-binding: t; -*-
;; navigating files, buffers, search, completion etc

(use-package tramp :straight nil
	:config
	(setq tramp-default-method "ssh"))

(use-package projectile :straight t)
