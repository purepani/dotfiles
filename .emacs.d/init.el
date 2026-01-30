
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(setq major-mode-remap-alist
      '(
	(python-mode . python-ts-mode)
	(rust-mode . rust-ts-mode)
	)
      )
(tool-bar-mode     -1)    ;; Remove toolbar
(scroll-bar-mode   -1)   ;; Remove scollbars
(menu-bar-mode     -1)   ;; Remove menu bar
(setq create-lockfiles nil)
(use-package tree-sitter-langs
  :ensure t
  )
(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'"
)
(use-package eglot
  :ensure t
  :defer t
  :config
  (add-to-list 'eglot-server-programs
	       '(nix-mode . ("nixd"))
	       '((rust-ts-mode rust-mode) .
               ("rust-analyzer" :initializationOptions (:check (:command "clippy"))))
	       )
  :hook (
	 (python-mode . eglot-ensure)
	 (nix-mode . eglot-ensure)
	 (rust-mode-hook . eglot-ensure)
	 )
  )

(which-key-mode 1)
(which-key-setup-side-window-right-bottom)

(use-package vterm
    :ensure nil)
(use-package eglot-python-preset
  :ensure t
  :after eglot
  :custom
  (eglot-python-preset-lsp-server 'ty) ; or 'basedpyright
  :config
  (eglot-python-preset-setup))

(use-package envrc
  :hook (after-init . envrc-global-mode))
(use-package majutsu
  :ensure t
  :vc (:url "https://github.com/0WD0/majutsu"))
(use-package corfu
  :ensure t
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match 'insert) ;; Configure handling of exact matches

  ;; Enable Corfu only for certain modes. See also `global-corfu-modes'.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  :init

  ;; Recommended: Enable Corfu globally.  Recommended since many modes provide
  ;; Capfs and Dabbrev can be used globally (M-/).  See also the customization
  ;; variable `global-corfu-modes' to exclude certain modes.
  (global-corfu-mode)

  ;; Enable optional extension modes:
  ;; (corfu-history-mode)
  ;; (corfu-popupinfo-mode)
  )


;; Enable Vertico.
(use-package vertico
  :ensure t
  :custom
  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure t
  :init
  (savehist-mode))

;; Emacs minibuffer configurations.
(use-package emacs
  :ensure nil
  :init
  (load-theme 'wombat)
  :custom
  (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
   (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
 (minibuffer-prompt-properties
'(read-only t cursor-intangible t face minibuffer-prompt)
)
 )

;; Optionally use the `orderless' completion style.
(use-package orderless
  :ensure t
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring
(use-package envrc
  :ensure t
  :hook (after-init . envrc-global-mode))

(use-package vc-jj
  :ensure t)

(use-package jj-mode
  :vc (:url "https://github.com/bolivier/jj-mode.el"))

(setq auto-save-list-file-prefix "~/.emacs.d/autosave/")

(setq auto-save-file-name-transforms
      '((".*" "~/.emacs.d/autosave/" t)))


(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t
  version-control t  
  delete-old-versions t
  kept-new-versions 20 
  kept-old-versions 5  
  )



(setq project-mode-line t)
;;set up org mode


(use-package org
  :ensure t)
(use-package org-roam
  :ensure t
  :config
  (setq org-roam-directory (file-truename "~/org-notes"))
  (setq org-roam-completion-everywhere t)
  (org-roam-db-autosync-mode)
  )
