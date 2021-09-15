(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-sources '("~/.authinfo.gpg") nil nil "Customized with use-package auth-source")
 '(custom-safe-themes
   '("c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "70b51a849b665f50a97a028c44cec36b398398357d8f7c19d558fe832b91980f" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default))
 '(org-agenda-files '("/Users/jcsims/org/inbox.org"))
 '(package-selected-packages
   '(whitespace-cleanup-mode gcmh org-superstar orderless vertico consult mlscroll marginalia modus-themes noflet consult-lsp edit-server embark inf-clojure company-prescient ctrlf selectrum-prescient selectrum async gruvbox-theme unicode-fonts lsp-treemacs rustic magit-libgit f dumb-jump paredit forge projectile counsel swiper ivy flycheck company markdown-mode restclient solarized-theme base16-theme nix-mode flycheck-rust jq-mode flycheck-clj-kondo rust-mode lsp-mode json-snatcher yasnippet cider clojure-mode go-mode multiple-cursors deadgrep vlf-setup vlf scpaste lsp-sh idle-highlight-mode color-theme-sanityinc-tomorrow yaml-mode which-key validate use-package systemd super-save sql-indent smex smart-mode-line smart-jump shell-pop rotate rg racer pkgbuild-mode paren-face paredit-everywhere paradox pacfiles-mode org-rich-yank ob-restclient nov no-littering nlinum minions magit macrostep lsp-ui lsp-rust libgit keychain-environment json-mode js2-mode hy-mode hl-todo highlight-symbol helpful groovy-mode go-errcheck go-eldoc git-timemachine git-link ghub flymd flycheck-joker expand-region exec-path-from-shell es-mode elisp-slime-nav doom-themes dockerfile-mode dired-collapse diff-hl define-word csv-mode crux counsel-projectile company-quickhelp company-lsp company-go clj-refactor buffer-move browse-kill-ring atomic-chrome anzu alert ag))
 '(paradox-automatically-star t)
 '(paradox-github-token t)
 '(paren-face-regexp "[][{}()]" nil nil "Customized with use-package paren-face")
 '(safe-local-variable-values
   '((eval with-eval-after-load 'lsp-mode
	   (dolist
	       (item
		(list "[/\\\\]\\assets\\'" "[/\\\\]\\docker\\'" "[/\\\\]\\externs\\'" "[/\\\\]\\resources\\'" "[/\\\\]\\src-cljs\\'" "[/\\\\]\\vendor\\'"))
	     (add-to-list 'lsp-file-watch-ignored-directories item))
	   (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]\\corpus_db.sql\\'")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
