(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq treesit-language-source-alist
      '((astro "https://github.com/virchau13/tree-sitter-astro")
	(svelte "https://github.com/tree-sitter-grammars/tree-sitter-svelte")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
	(typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" nil
                   "typescript/src"))
	(javascript "https://github.com/tree-sitter/tree-sitter-css")
	(json "https://github.com/tree-sitter/tree-sitter-json")
	(toml "https://github.com/tree-sitter-grammars/tree-sitter-toml")
	)
)
(mapc #'treesit-install-language-grammar '(astro css tsx typescript svelte javascript json toml))
(setq global-tree-sitter-mode 1)
;; (setq major-mode-remap-alist
;;       '(
;; 	(python-mode . python-ts-mode)
;; 	(rust-mode . rust-ts-mode)
;; 	(typescript-mode . typescript-ts-mode)
;;       ))
(tool-bar-mode     -1)    ;; Remove toolbar
(scroll-bar-mode   -1)   ;; Remove scollbars
(menu-bar-mode     -1)   ;; Remove menu bar
(setq create-lockfiles nil)

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(use-package gnu-elpa-keyring-update
  :ensure t)


(use-package tree-sitter-langs
  :ensure t)
(use-package rust-mode
  :ensure t
  :init
  (setq rust-mode-treesitter-derive t))

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'"
  )

(use-package format-all
  :ensure t
  :commands format-all-mode
  :hook (prog-mode . format-all-mode))
  
(use-package eglot
  :ensure t
  :defer t
  :config
  (dolist (server '((nix-mode . ("nixd"))
		    ((rust-ts-mode rust-mode) .
		     ("rust-analyzer" :initializationOptions (:check (:command "clippy"))))
		    (svelte-ts-mode . ("svelteserver" "--stdio"))
		    (astro-ts-mode . ("astro-ls" "--stdio"
				      :initializationOptions
				      (:typescript (:tsdk "./node_modules/typescript/lib")))))) 
     (add-to-list 'eglot-server-programs server))
    

  :hook (
	 (python-mode . eglot-ensure)
	 (nix-mode . eglot-ensure)
	 (rust-mode-hook . eglot-ensure)
	 (svelte-ts-mode . eglot-ensure)
	 (astro-ts-mode . eglot-ensure)
	 )
  )
(use-package cape
  :ensure t
  :after eglot
  :config
  (advice-add #'eglot-completion-at-point :around #'cape-wrap-buster))

(setq completion-category-overrides
      '((eglot (styles orderless basic))
        (eglot-capf (styles orderless basic))))

(use-package magit
  :ensure t)

(use-package web-mode
  :ensure t)
; (add-to-list 'project-vc-extra-root-markers "Cargo.toml")


(use-package svelte-ts-mode
  :ensure t
  :vc (:url "https://github.com/leafOfTree/svelte-ts-mode" :branch "emacs-master")


  :mode ("\\.svelte(.*)?\\'")
)

(use-package astro-ts-mode
  :ensure t
  :config
  :mode ("\\.astro\\'"))


(which-key-mode 1)
(which-key-setup-side-window-right-bottom)

(use-package dicom
 :ensure t
  )
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
'(read-only t cursor-intangible t face minibuffer-prompt))
)

;; For ssh prompt matching
(setq tramp-shell-prompt-pattern "\\(?:^\\|\r\\)[^]#$%>\n]*#?[]#$%>].* *\\(^[\\[[0-9;]*[a-zA-Z] *\\)*")



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
  :ensure t
  :vc (:url "https://github.com/bolivier/jj-mode.el"
	    :rev :newest
	    ))

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
  :after org
  :config
  (setq org-roam-directory (file-truename "~/org-notes"))
  (setq org-roam-completion-everywhere t)
  (org-roam-db-autosync-mode)
  (setq org-roam-capture-templates `(("d" "default" plain
				      (file ,(concat org-roam-directory "/templates/default.org"))
				      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
				      :unnarrowed t)
				     ("t" "todo" plain
				      (file ,(concat org-roam-directory "/templates" "/todo.org"))
				      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
				      :unnarrowed t)
	
				     ("F" "fleeting" plain
				      (file ,(concat org-roam-directory "/templates" "/fleeting.org"))
				      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
				      :unnarrowed t)
				     ))

  :bind
  ("C-c c" . org-roam-capture)) 







(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(cape dicom format-all gnu-elpa-keyring-update jj-mode rust-mode
	  web-mode))
 '(package-vc-selected-packages
   '((jj-mode :url "https://github.com/bolivier/jj-mode.el" :branch
	      "main")
     (svelte-ts-mode :url
		     "https://github.com/leafOfTree/svelte-ts-mode"
		     :branch "emacs-master")))
 '(tab-bar-select-tab-modifiers '(meta)))

