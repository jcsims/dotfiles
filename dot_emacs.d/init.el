;;; init --- configuration starting point -*- no-byte-compile: t -*-

;;; Commentary:
;; Most of what is found in these files has been pulled from the
;; dotfiles of others.  Take what you want, but be prepared to
;; troubleshoot yourself!

;;; Code:

;; Prefer the newer version of a file, whether it's compiled or not.
(setq load-prefer-newer t)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Seed the PRNG anew, from the system's entropy pool
(random t)

(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("nongnu" . "https://elpa.nongnu.org/nongnu/")
	("melpa" . "https://melpa.org/packages/")
	("org" . "https://orgmode.org/elpa/")))
(package-initialize)

;; Setup use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t
      use-package-compute-statistics t
      use-package-verbose t)
(use-package bind-key)

(use-package gcmh
  :custom (gcmh-verbose t)
  :config (gcmh-mode 1))

;; Some combination of GNU TLS and Emacs fail to retrieve archive
;; contents over https.
;; https://www.reddit.com/r/emacs/comments/cdei4p/failed_to_download_gnu_archive_bad_request/etw48ux
;; https://debbugs.gnu.org/cgi/bugreport.cgi?bug=34341
(if (and (version< emacs-version "28.3") (>= libgnutls-version 30600))
    (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

;; TODO: fix me
(setq source-directory (concat "~/code/emacs-" emacs-version))

;; Sentences can end with a single space.
(setq sentence-end-double-space nil)

(use-package no-littering
  :config
  (require 'files)
  (setq auto-save-file-name-transforms
	`((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

(use-package auth-source
  :ensure f
  :custom (auth-sources '("~/.authinfo.gpg")))

;;; Personal info
(setq user-full-name "Chris Sims"
      user-mail-address "chris@jcsi.ms")

;; Always use UTF-8
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(setq locale-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; Blank scratch buffer
(setq initial-scratch-message nil)

;; y/n keypresses instead of typing out yes or no
(defalias 'yes-or-no-p 'y-or-n-p)

(put 'erase-buffer 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; Get rid of the insert key. I never use it, and I turn it on
;; accidentally all the time
(global-set-key (kbd "<insert>") nil)

(when (featurep 'ns)
  (defun ns-raise-emacs ()
    "Raise Emacs."
    (ns-do-applescript "tell application \"Emacs\" to activate"))

  (defun ns-raise-emacs-with-frame (frame)
    "Raise Emacs and select the provided frame."
    (with-selected-frame frame
      (when (display-graphic-p)
	(ns-raise-emacs))))

  (add-hook 'after-make-frame-functions 'ns-raise-emacs-with-frame))

(setq isearch-allow-scroll t)
(global-set-key (kbd "C-S") 'isearch-forward-regexp)
(global-set-key (kbd "C-R") 'isearch-backward-regexp)
;; (global-set-key (kbd "C-M-s") 'isearch-forward)
;; (global-set-key (kbd "C-M-r") 'isearch-backward)

;; Turn off the toolbar, menu bar, and scroll bar
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

;; Font
(if (eq system-type 'gnu/linux)
    ;; provided in the AUR by `nerd-font-hack`
    (set-frame-font "Hack Nerd Font 9")
  (set-frame-font "Hack Nerd Font 12"))

;;; Themes
(defvar jcs-active-theme)
(defvar jcs-light-theme)
(defvar jcs-dark-theme)

;;; Themes

(use-package smart-mode-line
  :custom (sml/theme 'dark)
  :config (sml/setup))

(use-package color-theme-sanityinc-tomorrow
  :config
  (setq jcs-active-theme 'sanityinc-tomorrow-eighties
	jcs-light-theme 'sanityinc-tomorrow-day
	jcs-dark-theme 'sanityinc-tomorrow-eighties)
  (load-theme jcs-active-theme t)
  (defun toggle-dark-light-theme ()
    "Toggle the current theme between light and dark."
    (interactive)
    (if (eq jcs-active-theme jcs-light-theme)
	(progn (setq jcs-active-theme jcs-dark-theme)
	       (sml/apply-theme 'dark))
      (progn (setq jcs-active-theme jcs-light-theme)
	     (sml/apply-theme 'light)))
    (load-theme jcs-active-theme t)))

;; Allow for seamless gpg interaction
(use-package epa-file
  :ensure f
  :config (epa-file-enable))

(use-package prog-mode
  :ensure f
  :config
  (defun indicate-buffer-boundaries-left ()
    (setq indicate-buffer-boundaries 'left))
  (add-hook 'prog-mode-hook #'indicate-buffer-boundaries-left))

(use-package windmove
  :config (windmove-default-keybindings '(super meta)))

(use-package vulpea)

;; Quick access to a few files
(defvar org-dir "~/org/")
(defvar jcs/org-roam-dir (file-truename "~/org-roam"))

(use-package org
  :custom
  (org-priority-default ?C)
  (org-priority-lowest ?D)
  (org-tag-alist (quote (("@alex" . ?a)
			 ("@stacey" . ?s)
			 ("@uma" . ?u)
			 ("@ed" . ?e)
			 ("@tega" . ?t)
			 (:newline)
			 ("important" . ?i)
			 ("urgent" . ?r)
			 ("to_delegate" . ?d))))

  :config
  (setq org-hide-leading-stars t
	org-hide-emphasis-markers t ;; Hide things like `*` for bold, etc.
	org-directory org-dir
	org-log-done 'time
	org-log-into-drawer t
	org-startup-indented t
	org-startup-folded t
	org-src-fontify-natively t
	org-use-fast-todo-selection t
	org-outline-path-complete-in-steps nil
	;; Don't ask every time before evaluating an org source block
	org-confirm-babel-evaluate nil
	;; Try to keep image widths in emacs to a sane value (measured in pixels)
	org-image-actual-width 1000)
  (setq org-todo-keywords
	(quote ((sequence "TODO(t)" "DOING(o)" "|" "DONE(d)")
		(sequence "DELEGATED(e@/!)" "WAITING(w@/!)" "BLOCKED(b@/!)" "HAMMOCK(h@/!)" "|" "CANCELLED(c@/!)"))))

  ;; These tend to modify files, so save after doing it
  (advice-add 'org-refile :after 'org-save-all-org-buffers)
  (advice-add 'org-archive-subtree-default :after 'org-save-all-org-buffers)
  (advice-add 'org-agenda-archive-default-with-confirmation :after 'org-save-all-org-buffers)
  (advice-add 'org-agenda-todo :after 'org-save-all-org-buffers)

  ;; Modified from https://stackoverflow.com/a/31868530
  (defun jcs/org-screenshot ()
    "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
    (interactive)
    (setq filename
          (concat
           (make-temp-name
            (concat (file-name-nondirectory (buffer-file-name))
                    "_imgs/"
                    (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
    (unless (file-exists-p (file-name-directory filename))
      (make-directory (file-name-directory filename)))
					; take screenshot
    (if (eq system-type 'darwin)
	(call-process "screencapture" nil nil nil "-i" filename))
    (if (eq system-type 'gnu/linux)
	(call-process "import" nil nil nil filename))
					; insert into file if correctly taken
    (if (file-exists-p filename)
	(insert (concat "[[file:" filename "]]")))
    (org-display-inline-images))

  :bind (("C-c l" . org-store-link)
	 ("C-c a" . org-agenda)))

(use-package org-tempo :ensure org)

(use-package ox-md :ensure org)

(use-package org-roam
  :after org
  :init (setq org-roam-v2-ack t)
  :custom (org-roam-directory jcs/org-roam-dir)
  :bind (("C-c o l" . org-roam-buffer-toggle)
	 ("C-c o f" . org-roam-node-find)
	 ("C-c o g" . org-roam-graph)
	 ("C-c o i" . org-roam-node-insert)
	 ("C-c o c" . org-roam-capture)
	 ("C-c o r" . org-roam-refile)
	 ;; Dailies
	 ("C-c o d" . org-roam-dailies-goto-today)
	 ("C-c o p" . org-roam-dailies-goto-previous-note)
	 ("C-c o n" . org-roam-dailies-goto-next-note)
	 ("C-c o j" . org-roam-dailies-capture-today))
  :hook ((find-file . vulpea-project-update-tag)
	 (before-save . vulpea-project-update-tag))
  :config
  (org-roam-db-autosync-mode)
  (advice-add 'org-roam-refile :after 'org-save-all-org-buffers)

  ;; Help make agenda loading faster by only including org-roam files
  ;; with todo headers in the agenda files
  ;; Stolen from
  ;; https://d12frosted.io/posts/2021-01-16-task-management-with-roam-vol5.html
  (add-to-list 'org-tags-exclude-from-inheritance "project")

  (defun vulpea-project-p ()
    "Return non-nil if current buffer has any todo entry.

TODO entries marked as done are ignored, meaning this function
returns nil if current buffer contains only completed or
canceled tasks."
    (org-element-map
	(org-element-parse-buffer 'headline)
	'headline
      (lambda (headline)
	(eq (org-element-property :todo-type headline)
	    'todo))
      nil
      'first-match))

  ;; Update org-roam node tags with a special tag to help filter
  ;; org-agenda buffers.

  (defun vulpea-project-update-tag ()
    "Update PROJECT tag in the current buffer."
    (when (and (not (active-minibuffer-window))
	       (org-roam-buffer-p))
      (save-excursion
	(goto-char (point-min))
	(let* ((tags (vulpea-buffer-tags-get))
	       (original-tags tags))
	  (if (vulpea-project-p)
	      (setq tags (cons "project" tags))
	    (setq tags (remove "project" tags)))

	  ;; Remove duplicates
	  (setq tags (seq-uniq tags))

	  ;; Update tags in the buffer if they've changed
	  (when (or (seq-difference tags original-tags)
		    (seq-difference original-tags tags))
	    (apply #'vulpea-buffer-tags-set tags))))))

  (defun org-roam-buffer-p ()
    "Return non-nil of the currently visited buffer is an org-roam buffer."
    (and buffer-file-name
	 (string-prefix-p
	  (expand-file-name (file-name-as-directory org-roam-directory))
	  (file-name-as-directory buffer-file-name)))))

(use-package restclient)
(use-package ob-restclient)

;; Use es-mode for ElasticSearch buffers
(use-package es-mode)
(use-package ob-elasticsearch
  :ensure es-mode
  :config (add-to-list 'org-babel-load-languages '(elasticsearch . t)))

;; org-babel
(use-package ob
  :ensure org
  :config
  (org-babel-do-load-languages 'org-babel-load-languages
			       '((clojure . t)
				 (shell . t)
				 (sql . t)
				 (emacs-lisp . t)
				 (elasticsearch . t)
				 (restclient . t))))

(use-package org-agenda
  :ensure org
  :after org
  :config
  ;; TODO: Use a `let*` binding here and turn on lexical scoping for
  ;; this file.
  ;; Use the current window to open the agenda
  (setq org-agenda-window-setup 'current-window
	org-agenda-block-separator nil
	org-agenda-tags-column -80
	org-agenda-show-future-repeats nil)

  ;; Stolen from
  ;; https://d12frosted.io/posts/2020-06-24-task-management-with-roam-vol2.html
  ;; This ensures that the label prior to the TODO in the agenda is
  ;; readable and sane. This is especially useful using org-roam,
  ;; since the filenames are prefixed with a timestamp, making the
  ;; usual pattern (the filename) useless.
  (setq org-agenda-prefix-format
	'((agenda . " %i %(vulpea-agenda-category 12)%?-12t% s")
	  (todo . " %i %(vulpea-agenda-category 12) ")
	  (tags . " %i %(vulpea-agenda-category 12) ")
	  (search . " %i %(vulpea-agenda-category 12) ")))

  (defun vulpea-agenda-category (&optional len)
    "Get category of item at point for agenda.

     Category is defined by one of the following items:

     - CATEGORY property
     - TITLE keyword
     - TITLE property
     - filename without directory and extension

     When LEN is a number, resulting string is padded right with
     spaces and then truncated with ... on the right if result is
     longer than LEN.

     Usage example:

       (setq org-agenda-prefix-format
	     '((agenda . \" %(vulpea-agenda-category) %?-12t %12s\")))

     Refer to `org-agenda-prefix-format' for more information."
    (let* ((file-name (when buffer-file-name
			(file-name-sans-extension
			 (file-name-nondirectory buffer-file-name))))
	   (title (vulpea-buffer-prop-get "title"))
	   (category (org-get-category))
	   (result
	    (or (if (and
		     title
		     (string-equal category file-name))
		    title
		  category)
		"")))
      (if (numberp len)
	  (s-truncate len (s-pad-right len " " result))
	result)))

  (defun vulpea-project-files ()
    "Return a list of org-roam files containing the 'project' tag."
    (seq-uniq
     (seq-map
      #'car
      (org-roam-db-query
       [:select [nodes:file]
		:from tags
		:left-join nodes
		:on (= tags:node-id nodes:id)
		:where (like tag (quote "%\"project\"%"))]))))

  (defun vulpea-agenda-files-update (&rest _)
    "Update the value of `org-agenda-files' based on 'project' tag."
    (setq org-agenda-files (vulpea-project-files)))

  (advice-add 'org-agenda :before #'vulpea-agenda-files-update)
  (advice-add 'org-todo-list :before #'vulpea-agenda-files-update)

  (setq org-agenda-custom-commands
	'(("c" "Agenda and tasks"
	   ((agenda ""
		    ((org-agenda-skip-function
		      '(org-agenda-skip-if nil '(todo done)))))
	    (todo "BLOCKED"
		  ((org-agenda-overriding-header "Blocked")
		   (org-agenda-skip-function
		    '(org-agenda-skip-if nil '(scheduled)))))
	    (todo "DOING"
		  ((org-agenda-overriding-header "In Progress")))
	    (todo "TODO"
		  ((org-agenda-overriding-header "Todo")
		   (org-agenda-skip-function
		    '(org-agenda-skip-if nil '(scheduled deadline)))))
	    (todo "WAITING"
		  ((org-agenda-overriding-header "Waiting")
		   (org-agenda-skip-function
		    '(org-agenda-skip-if nil '(scheduled)))))
	    (todo "DELEGATED"
		  ((org-agenda-overriding-header "Delegated")
		   (org-agenda-skip-function
		    '(org-agenda-skip-if nil '(scheduled)))))
	    (todo "HAMMOCK"
		  ((org-agenda-overriding-header "Hammock")
		   (org-agenda-skip-function
		    '(org-agenda-skip-if nil '(scheduled))))))))))

(use-package org-alert
  :disabled
  :config
  (setq alert-default-style 'notifier)
  (org-alert-enable))

(use-package autorevert
  :ensure f
  :config
  (setq global-auto-revert-non-file-buffers t ; Refresh dired buffers
	auto-revert-verbose nil)              ; but do it quietly
  ;; Auto-refresh buffers
  (global-auto-revert-mode))

(use-package dired
  :ensure f
  :config (setq dired-listing-switches "-alhv")
  :custom (dired-kill-when-opening-new-dired-buffer t))

(use-package saveplace
  :ensure f
  :when (version< "25" emacs-version)
  :config (save-place-mode t))

;;; Misc settings
(setq inhibit-splash-screen t  ; Don't show the splash screen
      ring-bell-function 'ignore ; Just ignore error notifications
      indent-tabs-mode nil ; Don't use tabs unless buffer-local
      select-enable-primary t
      save-interprogram-paste-before-kill t
      mouse-yank-at-point t
      ;; When scrolling, make sure to come back to the same spot
      scroll-preserve-screen-position 'always
      scroll-error-top-bottom t ; Scroll similar to vim
      )

;;; Packages
(use-package vc-hooks
  :ensure f
  :config (setq vc-follow-symlinks t ; even when they're in version control
		))

(use-package recentf
  :ensure f
  :config
  (recentf-mode 1)
  (add-to-list 'recentf-exclude "^/\\(?:ssh\\|su\\|sudo\\)?:")
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory))

(use-package files
  :ensure f
  :config
  (auto-save-visited-mode 1)
  (setq backup-directory-alist ; Save backups to a central location
	`(("." . ,(no-littering-expand-var-file-name "backup/")))
	auto-save-file-name-transforms
	`((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

;; Handles ssh-agent and gpg-agent configuration from `keychain`
(use-package keychain-environment
  :if (eq system-type 'gnu/linux)
  :config (keychain-refresh-environment))

;; Used for async package updating in paradox
(use-package async)
(use-package paradox
  :after (auth-source epa-file epg exec-path-from-shell)
  :commands (paradox-list-packages)
  :config
  (setq paradox-execute-asynchronously t
	paradox-github-token (cadr (auth-source-user-and-password
				    "api.github.com" "jcsims^paradox")))
  (paradox-enable))

(use-package macrostep
  :bind ("C-c m" . macrostep-expand))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :config (exec-path-from-shell-initialize))

(use-package re-builder
  :ensure f
  :bind (("C-c R" . re-builder))
  :config (setq reb-re-syntax 'string))

;; External user config
(use-package init-funcs
  :demand
  :ensure f
  :bind (("C-c C-f" . goto-next-file)
	 ("C-c f" . goto-next-file)
	 ("C-c n". cleanup-buffer))
  :load-path "lisp")

(use-package whitespace
  :config
  (setq-default fill-column 80)
  (setq whitespace-style '(face empty trailing))
  :hook
  (prog-mode . whitespace-mode)
  (text-mode . whitespace-mode))

(use-package whitespace-cleanup-mode
  :config (global-whitespace-cleanup-mode))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :config (setq markdown-fontify-code-blocks-natively t))

(use-package minions
  :config
  (setq minions-direct '(flycheck-mode
			 vlf-mode
			 lsp-mode
			 whitespace-cleanup-mode))
  (minions-mode))

(defun find-init-file ()
  "Open the init file for editing."
  (interactive)
  (find-file (string-trim
	      (shell-command-to-string "chezmoi source-path ~/.emacs.d/init.el"))))

(defun find-home-nix ()
  "Open home.nix for editing."
  (interactive)
  (find-file "~/.config/nixpkgs/home.nix"))

(use-package simple
  :ensure f
  :after org
  :hook (org-mode . visual-line-mode)
  :config
  (column-number-mode)
  (setq-default what-cursor-show-names t)
  :bind
  ("M-SPC" . cycle-spacing)
  ("C-c e e" . find-init-file)
  ("C-c e h" . find-home-nix)
  :hook ((text-mode org-mode markdown-mode) . turn-on-auto-fill))

(use-package text-mode
  :ensure f
  :hook (text-mode-hook . indicate-buffer-boundaries-left))

(use-package tramp
  :ensure f
  :defer t
  :config
  (add-to-list 'tramp-default-proxies-alist '(nil "\\`root\\'" "/ssh:%h:"))
  (add-to-list 'tramp-default-proxies-alist '("localhost" nil nil))
  (add-to-list 'tramp-default-proxies-alist
	       (list (regexp-quote (system-name)) nil nil)))

;; Ensure that when we go to a new line, it's indented properly
(use-package electric
  :config (electric-indent-mode))

;; Highlight matching parens
(use-package paren
  :config (show-paren-mode))

;; Ensure that a server is running for quicker start times
(use-package server
  :if (display-graphic-p)
  :config (unless (server-running-p)
	    (server-start)))

(use-package atomic-chrome
  :if (display-graphic-p)
  :config
  (setq atomic-chrome-url-major-mode-alist
	'(("github\\.com" . gfm-mode)
	  ("github\\.threatbuild\\.com" . gfm-mode)))
  (atomic-chrome-start-server))

;; Work-specific code - should be encrypted!
(defvar work-init (concat user-emacs-directory "lisp/init-work.el.gpg"))
(if (file-exists-p work-init)
    (load work-init))

;; Flyspell mode
(use-package flyspell
  :hook ((text-mode . flyspell-mode)
	 (prog-mode . flyspell-prog-mode)))

(use-package company
  :config
  (setq company-idle-delay .3)                          ; decrease delay before autocompletion popup shows
  (setq company-echo-delay 0)                           ; remove annoying blinking
  (global-company-mode))

(use-package company-quickhelp
  :config (company-quickhelp-mode))

(use-package elisp-slime-nav
  :config
  ;; Enable M-. and M-, along with C-c C-d {c,C-d} for elisp
  :hook ((emacs-lisp-mode ielm-mode) . elisp-slime-nav-mode))

(use-package symbol-overlay
  :bind (:map mode-specific-map
	      ("h h" . symbol-overlay-put)
	      ("h r" . symbol-overlay-remove-all)
	      ("h m" . symbol-overlay-mode)
	      ("h n" . symbol-overlay-switch-forward)
	      ("h p" . symbol-overlay-switch-backward)))

(use-package flycheck
  :config (global-flycheck-mode)
  :bind (:map flycheck-mode-map
	      ("M-n" . flycheck-next-error)
	      ("M-p" . flycheck-previous-error))
  :custom (flycheck-global-modes '(not org-mode
				       cider-repl-mode)))

;; Borrowed from https://github.com/daviwil/dotfiles/commit/58eff6723515e438443b9feb87735624acd23c73
(defun jcs/minibuffer-backward-kill (arg)
  "When completing a filename in the minibuffer, kill according to path.
Passes ARG onto `zap-to-char` or `backward-kill-word` if used."
  (interactive "p")
  (if minibuffer-completing-file-name
      ;; Borrowed from https://github.com/raxod502/selectrum/issues/498#issuecomment-803283608
      (if (string-match-p "/." (minibuffer-contents))
	  (zap-up-to-char (- arg) ?/)
	(delete-minibuffer-contents))
    (backward-kill-word arg)))

(use-package vertico
  ;; :disabled
  :init (vertico-mode)
  :custom (vertico-cycle t)
  :bind (:map vertico-map
	      ("M-<backspace>" . jcs/minibuffer-backward-kill)))

;; (use-package icomplete
;;   :ensure f
;;   :demand
;;   :config
;;   (fido-mode 1)
;;   (fido-vertical-mode)
;;   (setq  icomplete-scroll t
;;          icomplete-show-matches-on-no-input t))

(use-package orderless
  :init
  (setq completion-styles '(orderless)
	completion-category-defaults nil
	completion-category-overrides '((file (styles . (partial-completion))))))

(use-package consult
  :demand ;; never want to lazy-load this package
  :bind (("M-y" . consult-yank-from-kill-ring)
	 ([remap isearch-forward-regexp] . consult-line)))

(use-package projectile
  :demand ;; never want to lazy-load this package
  :after consult
  :init
  (setq projectile-project-search-path '("~/code" "~/dev"))
  (projectile-mode +1)
  :bind (("C-c p" . projectile-command-map)
	 :map projectile-mode-map
	 ("C-c p" . projectile-command-map)
	 ;; This is handy on macOS
	 ("s-p" . projectile-command-map)
	 :map projectile-command-map
	 ;; I'm used to this binding, and ripgrep is faster
	 ("s s" . projectile-ripgrep)))

(use-package marginalia
  :init (marginalia-mode))

(use-package embark
  :demand
  :bind ("C-o" . embark-act))

(use-package magit
  :demand
  :bind (("C-c g"   . magit-status)
	 ("C-c M-g" . magit-dispatch))
  :custom
  (magit-branch-prefer-remote-upstream t)
  (magit-branch-adjust-remote-upstream-alist '(("upstream/master" . "issue-")))
  (magit-save-repository-buffers 'dontask)
  :config
  (magit-add-section-hook 'magit-status-sections-hook
			  'magit-insert-modules
			  'magit-insert-stashes
			  'append))

(use-package git-modes)

(use-package magit-libgit :after magit)

(use-package git-timemachine)

(use-package paredit
  :hook (emacs-lisp-mode . paredit-mode))

(use-package paredit-everywhere
  :hook (prog-mode . paredit-everywhere-mode))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package dockerfile-mode
  :mode "Dockerfile")
(use-package yaml-mode
  :mode (("\\.yml\\'" . yaml-mode)
	 ("\\.sls\\'" . yaml-mode)))

(use-package which-key
  :config (which-key-mode))

;; Some keybinds for this mode:
;; `diff-hl-diff-goto-hunk'  C-x v =
;; `diff-hl-revert-hunk'     C-x v n
;; `diff-hl-previous-hunk'   C-x v [
;; `diff-hl-next-hunk'       C-x v ]
(use-package diff-hl
  :config
  ;;(setq diff-hl-draw-borders nil)
  (global-diff-hl-mode)
  (diff-hl-dired-mode)
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package anzu
  :config
  (global-anzu-mode)
  (global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)
  (global-set-key [remap query-replace] 'anzu-query-replace))

(use-package display-line-numbers
  :ensure f
  :config
  (setq display-line-numbers-width-start t)
  (global-display-line-numbers-mode))

(use-package multiple-cursors
  :bind
  (("C->"     . mc/mark-next-like-this)
   ("C-<"     . mc/mark-previous-like-this)
   ("C-c C->" . mc/mark-all-like-this)))

(use-package clojure-mode
  :hook
  (clojure-mode . paredit-mode)
  :mode (("\\.edn\\'" . clojure-mode))
  :config
  (define-clojure-indent
    (prop/for-all 1)))

(use-package cider
  :hook
  ((clojure-mode . cider-mode)
   (cider-repl-mode . paredit-mode)
   (cider-repl-mode . cider-company-enable-fuzzy-completion)
   (cider-mode . cider-company-enable-fuzzy-completion))
  :bind (:map clojure-mode-map
	      ("C-c i" . cider-inspect-last-result)
	      ("M-s-." . cider-find-var))
  :custom
  ;; TODO: update these paths
  (cider-jdk-src-paths '("~/code/clojure-sources"
			 "/usr/local/opt/java11/libexec/openjdk.jdk/Contents/Home/lib/src.zip"))
  ;; This should put it after e.g. lsp
  (cider-xref-fn-depth 90)
  (cider-save-file-on-load t)
  (cider-repl-use-pretty-printing t)
  (nrepl-use-ssh-fallback-for-remote-hosts t)
  (cider-repl-print-length nil)
  (cider-auto-jump-to-error 'errors-only)
  ;; Remove 'deprecated since LSP does that as well
  (cider-font-lock-dynamically '(macro core))
  (cider-eldoc-display-context-dependent-info t)
  (cider-enrich-classpath t)
  :config
  ;; kill REPL buffers for a project as well
  (add-to-list 'project-kill-buffer-conditions
	       '(derived-mode . cider-repl-mode)
	       t)
  (setq cider-prompt-for-symbol nil ; Don't prompt for a symbol with `M-.`
	cider-repl-display-help-banner nil
	nrepl-log-messages t
	cider-known-endpoints '(("Face" "localhost" "4242")
				("Remote" "localhost" "8842")
				("Threatbrain Server" "localhost" "4243")
				("Integration Service" "localhost" "4244")
				("GUNDAM" "localhost" "4245"))))


(use-package systemd :if (eq system-type 'gnu/linux))

(use-package browse-url
  :ensure f
  ;; browse-url decides not to use xdg-open if you don't use one of a
  ;; handful of desktop environments...
  :config (when (eq system-type 'gnu/linux)
	    (setq browse-url-browser-function 'browse-url-xdg-open)))

(use-package wgrep)

(use-package json-snatcher
  :config (setq jsons-path-printer 'jsons-print-path-jq))

(use-package jq-mode)

;; LSP
(use-package lsp-mode
  :hook ((rust-mode . lsp)
	 (clojure-mode . lsp)
	 (go-mode . lsp))
  :config
  (setq read-process-output-max (* 1024 1024))
  (setq lsp-enable-indentation nil)
  ;; Using a locally-built version
  ;;:custom (lsp-clojure-custom-server-command
  ;;"/Users/jcsims/code/clojure-lsp/clojure-lsp")
  :custom (lsp-rust-analyzer-cargo-watch-command "clippy")
  :commands lsp)

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :bind (:map lsp-ui-mode-map
	      ("C-M-." . xref-find-references)
	      ([remap xref-find-references] . lsp-ui-peek-find-references))
  :custom
  (lsp-ui-sideline-show-code-actions nil)
  (lsp-ui-sideline-show-diagnostics nil)
  (lsp-ui-doc-use-webkit t))

(use-package lsp-treemacs
  :after lsp-mode
  :config (setq treemacs-space-between-root-nodes nil))

(use-package rustic
  :hook (rustic-mode . (lambda ()
			 (setq indent-tabs-mode nil)))
  :custom
  (rustic-lsp-format t))

(use-package flycheck-rust
  :after rust-mode
  :hook (flycheck-mode . flycheck-rust-setup))

(use-package yasnippet
  :config (yas-global-mode 1))

(use-package savehist
  :ensure f
  :config (savehist-mode))

(use-package crux
  :bind (("C-x 4 t" . crux-transpose-windows)
	 ("C-a" . crux-move-beginning-of-line)))

(use-package help
  :ensure f
  :config (temp-buffer-resize-mode))

(use-package helpful
  :bind (("C-h f" . helpful-callable)
	 ("C-h v" . helpful-variable)
	 ("C-h k" . helpful-key)
	 :map emacs-lisp-mode-map
	 ("C-c C-d" . helpful-at-point)))

(use-package git-link
  :config
  (add-to-list 'git-link-remote-alist
	       '("github\\.threatbuild\\.com" git-link-github)))

(use-package buffer-move
  :bind (("C-S-<up>" . buf-move-up)
	 ("C-S-<down>" . buf-move-down)
	 ("C-S-<right>" . buf-move-right)
	 ("C-S-<left>" . buf-move-left)))

(use-package groovy-mode
  :hook (groovy-mode . (lambda ()
			 (setq indent-tabs-mode nil)
			 (setq tab-width 2)))
  :custom (groovy-indent-offset 2))

(use-package hl-todo
  :config (global-hl-todo-mode))

(use-package pkgbuild-mode
  :custom (pkgbuild-update-sums-on-save nil)
  :if (eq system-type 'gnu/linux))

(use-package vlf
  :config (require 'vlf-setup))

(use-package newcomment
  :ensure f
  :config (global-set-key [remap comment-dwim] #'comment-line))

(use-package xref
  :ensure f
  :custom (xref-search-program 'ripgrep))

(use-package nix-mode)
(use-package nixpkgs-fmt
  :after nix-mode
  :bind (:map nix-mode-map
	      ("C-c C-f" . nixpkgs-fmt-buffer)))

(use-package sql-indent
  :hook (sql-mode . sqlind-minor-mode))

(use-package hideshow
  :ensure f
  :hook (prog-mode . hs-minor-mode))

(use-package winner
  :ensure f)

(use-package go-mode
  :hook (go-mode . (lambda ()
		     (setq tab-width 2))))

;; Local personalization
(let ((file (expand-file-name (concat (user-real-login-name) ".el")
			      user-emacs-directory)))
  (when (file-exists-p file)
    (load file)))

;;; init.el ends here
