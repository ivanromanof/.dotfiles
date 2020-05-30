(setq inhibit-startup-message t)
(global-linum-mode) ;; show line numbers
(setq show-paren-style 'expression)
(setq-default indent-tabs-mode nil) ;; spaces instead of tabs
(setq-default tab-width 4)
(setq make-backup-files nil)
(setq auto-save-default t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(global-auto-revert-mode t) ;; reverts any buffer associated with a file when the file changes on disk
(setq-default sgml-basic-offset 4)

(if (eq system-type 'darwin)
    (set-face-attribute 'default nil :font "Monaco-17")
    (set-face-attribute 'default nil :font "Ubuntu Mono-13"))

;; Color themes
;; Light:
;; (load-theme 'leuven t)
;; (load-theme 'dichromacy t)
;; (load-theme 'tsdh-light t)
;; (load-theme 'adwaita t) ;; grey
;; (load-theme 'light-blue t) ;; blue
;; (load-theme 'tango t) ;; grey
;; Dark:
;; (load-theme 'tango-dark t)
;; (load-theme 'deeper-blue t)
;; (load-theme 'manoj-dark t)
(load-theme 'misterioso t)
;; (load-theme 'tango-dark t)
;; (load-theme 'wheatgrass t)
;; (load-theme 'wombat t)
;; (load-theme 'tsdh-dark t)



(add-hook 'before-save-hook 'delete-trailing-whitespace)


(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")))
;("melpa" . "http://melpa.milkbox.net/packages/")
(package-initialize)

(setq package-enable-at-startup nil
      tls-checktrust "ask")

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package use-package
  :ensure nil

  :custom
  (use-package-always-ensure t)

  :config
  (put 'use-package 'lisp-indent-function 1))

;; Company
(use-package company
  :ensure t
  :config (add-hook 'prog-mode-hook 'company-mode)
          (global-set-key (kbd "M-i") 'company-complete))
(use-package company-anaconda
  :defer
  :after company
  :config (add-to-list 'company-backends 'company-anaconda))

; Company language package for PHP
(use-package company-php
  :defer
  :after company)

; Just as an example, aso Ruby:
(use-package robe ;; company-robe is a Ruby mode
  :ensure t
  :after company
  :config (add-to-list 'company-backends 'company-robe)
          (add-hook 'ruby-mode-hook 'robe-mode))

;; Python
(use-package python
  :ensure nil

  :mode
  ("\\.py\\'" . python-mode)

  :hook
  (python-mode . smartparens-mode)

  :bind
  (:map
   python-mode-map
   ("C-c C-c" . compile)))

(use-package elpy
  :after (python)

  :hook
  (python-mode . elpy-mode)
  (elpy-mode . flycheck-mode)

  :custom
  (elpy-rpc-virtualenv-path 'current)
  (elpy-modules
   '(elpy-module-company
     elpy-module-eldoc
     elpy-module-highlight-indentation
     elpy-module-django))

  :init
  (elpy-enable)
  (unbind-key "<C-left>" elpy-mode-map)
  (unbind-key "<C-right>" elpy-mode-map))

;;;; Go
(use-package go-mode
  :if (executable-find "go")

  :mode "\\.go\\'"

  :commands (go-mode)

  :hook
  (go-mode . my/go-mode-hook)

  :config
  (defun my/go-mode-hook ()
    (add-hook 'before-save-hook #'gofmt-before-save)
    (flycheck-mode)))

;;;; Web
(use-package web-mode
  :commands (web-mode)

  :init
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))

  :config
  (setq web-mode-code-indent-offset 2
        web-mode-markup-indent-offset 2
        web-mode-script-padding 2
        web-mode-css-indent-offset 2
        web-mode-style-padding 2))

;;;; YAML
(use-package yaml-mode
  :mode "\\.ya?ml\\'"

  :hook
  (yaml-mode . highlight-indentation-mode)
  (yaml-mode . smartparens-mode)

  :bind
  (:map
   yaml-mode-map
   (">" . nil)))

;;;; TOML
(use-package toml-mode
  :mode "\\.toml\\'"

  :hook
  (toml-mode . smartparens-mode))

;;;; CSV
(use-package csv-mode
  :mode "\\.[Cc][Ss][Vv]\\'")

;;;; Nix
(use-package nix-mode
  :mode "\\.nix\\'")

;;;; SQL
(setq-default sql-dialect 'sql-postgres)

;;;; Shell
(use-package sh-script
  :ensure nil

  :mode
  (("\\.ok\\'" . shell-script-mode)
   ("\\.sh\\'" . shell-script-mode)
   ("\\.bash\\'" . shell-script-mode)))

;;;; Markdown
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)

  :mode
  (("README.*\\.md\\'" . gfm-mode)
   ("\\.md\\'" . markdown-mode)
   ("\\.markdown\\'" . markdown-mode))

  :hook
  (markdown-mode . variable-pitch-mode)
  (markdown-mode . yas-minor-mode)
  (markdown-mode . smartparens-mode)

  :custom
  (markdown-command "pandoc")
  (markdown-header-scaling t)

  :config
  (unbind-key "DEL" gfm-mode-map))

;;;; Docker
(use-package docker
  :commands (docker))

(use-package dockerfile-mode
  :mode ("\\^Dockerfile\\'" . dockerfile-mode))

;; neotree
(use-package neotree
  :ensure t
  :config (global-set-key [f8] 'neotree-toggle)
          ; Every time when the neotree window is opened, let it find current file and jump to node.
          (setq neo-smart-open t)
          ; Do not autorefresh directory to show current file
          (setq neo-autorefresh nil))

;; emmet
(use-package emmet-mode
  :ensure t
  :config (add-hook 'css-mode-hook  'emmet-mode)
          (add-hook 'sgml-mode-hook 'emmet-mode)
          (global-set-key (kbd "C-j") 'emmet-expand-line)
          (add-hook 'emmet-mode-hook (lambda () (setbq emmet-indentation 2))))

(use-package electric
  :hook
  (prog-mode . electric-pair-local-mode))

(require 'ido)
(ido-mode t)
(autoload 'ibuffer "ibuffer" "List buffers." t)


;(load-file "~/.emacs.d/erlang.el")
;(load-file "~/.emacs.d/ocaml.el")
;(load-file "~/.emacs.d/yaml.el")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
