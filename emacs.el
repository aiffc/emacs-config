(add-to-list 'load-path "d:/lisp/emacs-plug/slime")
(add-to-list 'load-path "d:/lisp/emacs-plug/company-mode")
(add-to-list 'load-path "d:/lisp/emacs-plug/slime-company")
(add-to-list 'load-path "d:/lisp/emacs-plug/paredit")

(setq custom-file "~/.emacs.d/custom.el")

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; common lisp config
;; setup slime
(setq inferior-lisp-program "d:/lisp/sbcl/sbcl.exe")
(require 'slime)

;; setup slime company
(use-package slime-company
  :after (slime company)
  :config (setq slime-company-completion 'fuzzy
                slime-company-after-completion 'slime-company-just-one-space))

(slime-setup '(slime-fancy slime-company))

(define-key company-active-map (kbd "\C-n") 'company-select-next)
(define-key company-active-map (kbd "\C-p") 'company-select-previous)
(define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)
(define-key company-active-map (kbd "M-.") 'company-show-location)

;; ;; setup
(use-package paredit
  :after (require 'paredit)
  :ensure t
  ;; :hook ((emacs-lisp-mode-hook                   .   enable-paredit-mode)
  ;; 	 (eval-expression-minibuffer-setup-hook  .   enable-paredit-mode)
  ;; 	 (ielm-mode-hook		         .   enable-paredit-mode)
  ;; 	 (lisp-mode-hook			 .   enable-paredit-mode)
  ;; 	 (lisp-interaction-mode-hook		 .   enable-paredit-mode)
  ;; 	 (scheme-mode-hook			 .   enable-paredit-mode)
  ;; 	 (eldoc-mode-hook                        .   enable-paredit-mode))
  )
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'eldoc-mode-hook #'enable-paredit-mode)

;; comon config
(setq make-backup-files nil)
(defalias 'yes-or-no-p 'y-or-n-p)
(global-display-line-numbers-mode 1)

;; clang config
;; (add-to-list 'load-path "d:/.emacs/helm")


(use-package company
  :ensure t
  :init (global-company-mode)
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t)
  (setq company-idle-delay 0.0)
  (setq company-show-numbers t) 
  (setq company-selection-wrap-around t)
  (setq company-transformers '(company-sort-by-occurrence)))

;; (use-package company-box
;;   :ensure t
;;   :if window-system
;;   :hook (company-mode . company-box-mode))

(use-package yasnippet
  :ensure t
  :hook
  (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all)
  ;; add company-yasnippet to company-backends
  (defun company-mode/backend-with-yas (backend)
    (if (and (listp backend) (member 'company-yasnippet backend))
	backend
      (append (if (consp backend) backend (list backend))
              '(:with company-yasnippet))))
  (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
  ;; unbind <TAB> completion
  (define-key yas-minor-mode-map [(tab)]        nil)
  (define-key yas-minor-mode-map (kbd "TAB")    nil)
  (define-key yas-minor-mode-map (kbd "<tab>")  nil)
  :bind
  (:map yas-minor-mode-map ("S-<tab>" . yas-expand)))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

(use-package flycheck
  :ensure t
  :config
  (setq truncate-lines nil)
  :hook
  (prog-mode . flycheck-mode))

(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l"
	lsp-file-watch-threshold 500)
  :hook 
  (lsp-mode . lsp-enable-which-key-integration)
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-completion-provider :none)
  (setq lsp-headerline-breadcrumb-enable t)
  :bind
  ("C-c l s" . lsp-ivy-workspace-symbol))

(use-package lsp-ui
  :ensure t
  :config
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
  (setq lsp-ui-doc-position 'top))

(use-package lsp-ivy
  :ensure t
  :after (lsp-mode))

(use-package c++-mode
  :functions 			; suppress warnings
  c-toggle-hungry-state
  :hook
  (c-mode . lsp-deferred)
  (c++-mode . lsp-deferred)
  (c++-mode . c-toggle-hungry-state))

(use-package projectile
  :ensure t
  :bind (("C-c p" . projectile-command-map))
  :config
  (setq projectile-mode-line "Projectile")
  (setq projectile-track-known-projects-automatically nil))

(use-package counsel-projectile
  :ensure t
  :after (projectile)
  :init (counsel-projectile-mode))