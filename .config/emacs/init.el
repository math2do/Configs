;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;; Keep folders clean -------------------------------------------------------------------------------------------------------
;; Save backup files file-name~
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))
;; auto-save-mode doesn't create the path automatically!
(make-directory (expand-file-name "tmp/auto-saves/" user-emacs-directory) t)

;; auto saved files like #Emacs.org#
(setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory)
      auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))
;; files created by packages projectile, lsp, dap
(setq projectile-known-projects-file (expand-file-name "tmp/projectile-bookmarks.eld" user-emacs-directory)
      lsp-session-file (expand-file-name "tmp/.lsp-session-v1" user-emacs-directory)
      dap-breakpoints-file (expand-file-name "tmp/.dap-breakpoints" user-emacs-directory))

(setq default-process-coding-system '(utf-8-unix . utf-8-unix))
(show-paren-mode 1)

(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))

;; first install by M-x package-install RET rainbow-delimiters RET
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; must have configs-------------------------------------------------------------------------------------------------------
(set-default 'truncate-lines t)
(recentf-mode 1)
;; remember commands
(setq history-length 25)
(savehist-mode 1)
;; saves the cursor position
(save-place-mode 1)

;;Revert Buffers when file have changed in disk
(global-auto-revert-mode 1)

(set-frame-parameter (selected-frame) 'alpha '(93 . 90))
(add-to-list 'default-frame-alist '(alpha . (93 . 90)))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))



;; prevent C-backspace to clip into clipboard
(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
       With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))
(global-set-key (kbd "C-<backspace>") 'backward-delete-word)


;; Stop control-backspace to delete too much
(defun my/backward-kill-word ()
  "Remove all whitespace if the character behind the cursor is whitespace, otherwise remove a word."
  (interactive)
  (if (looking-back "[ \n]")
      ;; delete horizontal space before us and then check to see if we
      ;; are looking at a newline
      (progn (delete-horizontal-space 't)
             (while (looking-back "[ \n]")
               (backward-delete-char 1)))
    ;; otherwise, just do the normal kill word.
    (backward-kill-word 1)))


;; cursor type

;; (setq-default cursor-type '(hbar . 4))
;; (setq-default set-cursor-color '"#FFFF00") 
;; (setq-default blink-cursor-interval '0.2)

;; Notes
;; Describe Variable : C-h v
;; Describe Function : C-h f
;; describe Symbol   : C-h o

;; quite mini-buffer : C-g
;; alternatively set ESC for above action

       ;;; Prevent Extraneous Tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)


;; set keybindings
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; select : C-space  then use arrow keys
;; Cut    : C-w
;; Copy   : M-w
;; Paste  : C-y
;; Undo   : C-_        equaivalent to C-S-+
;; Redo   : C-g C-_    C-g is used to reverse the action

;; compile c and c++ files with F4 -----------------------------------------------------------------------

(defun code-compile ()
  (interactive)
  (save-buffer)
  (unless (file-exists-p "Makefile")
    (set (make-local-variable 'compile-command)
         (let ((file (file-name-nondirectory buffer-file-name)))
           (format "%s %s -std=c++17 -O2 -o sol -Wall -Wextra -DLOCAL"
                   (if  (equal (file-name-extension file) "cpp") "g++" "gcc" )
                   file
                   (file-name-sans-extension file))))
    (compile compile-command)))

(add-hook 'c-mode-common-hook
          (lambda ()
            (local-set-key [f4] 'code-compile)))


;; don't show the splash screen
;; C-M-x for evaluating the configuration -- > WORKING
(setq inhibit-startup-message t) ; Comment at end of line
(setq visible-bell t)            ; Flash when the bell rings

;; enabling and  disabling feature
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

(column-number-mode)
(global-display-line-numbers-mode 1)
;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                org-present-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq vc-follow-symlinks t)
;; load theme
;; C-x-e to evaluating the configuration --> WORKING 
;; (load-theme 'tango-dark) --> since doom-theme is loaded somewhere below
;; run a command e.g M-x list-package
;; M-x {command name}

;; initialise package source
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ;; ("org" . "https://orgmode.org/elpa/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
;; initialise use package on non-linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; show the key pressing events
(use-package command-log-mode)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; load font, install all these fonts manually first, the size is 127 without exwm
(set-face-attribute 'default nil
                    :font "Fira Mono"
                    ;;:font "Source Code Pro"
                    :height 145)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil
                    ;;:font "JetBrains Mono"
                    :font "Source Code Pro"
                    :weight 'light
                    :height 145)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil
                    ;; :font "Cantarell"
                    ;;:font "Iosevka Aile"
                    :font "JetBrains Mono"
                    :height 145
                    :weight 'light)

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts

(use-package all-the-icons)

;; doom mode line 
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

;; doom theme
(use-package doom-themes)
;; load theme command M-x ^counsel-load-theme
(use-package doom-themes
  :init (load-theme 'doom-dracula t))
;; other themes = doom-dracula, doom-palenight, doom-acario-light, doom-one, doom-snazzy, doom-solarized-light
;; dracula, modus-vivendi, modus-operandi, doom-one-light, doom-opera-light
;; (load-theme 'atom-one-dark t)

;; press C-h to find the which keys does what
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0))

;; ivy rich-mode shows description of auto suggested
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only))

;; improved documentation about variables/functions
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; restclient---------------------------------------------------------------------------------------------------------
(require 'restclient)

;; magit -----------------------------------------------------------------------------------------------
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))


;; -------------------------------------------------------------------------------------------------------

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Projects/go/src/lynk")
    (setq projectile-project-search-path '("~/Projects/go/src/lynk"
                                           "~/Projects/go/src/practice"
                                           "~/Projects/java/SpringBoot"
                                           "~/Projects/web/ui/lynk"
                                           "~/Projects/web/ui/practice"
                                           "~/Projects/java/Lynk"
                                           "~/Projects/java/practice"
                                           "~/Projects/react/practice")))
  (setq projectile-switch-project-action #'projectile-dired))

;; after C-c p then M-o
(use-package counsel-projectile
  :config (counsel-projectile-mode))

(defun efs/lsp-mode-setup ()	
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((js2-mode web-mode rjsx-mode) . lsp)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package json-mode
  :ensure t)

(defun dw/set-js-indentation ()
  (setq js-indent-level 2)
  (setq evil-shift-width js-indent-level)
  (setq-default tab-width 2))

;; (use-package js2-mode
;; :mode "\\.jsx?\\'"
;; :config
;; ;; Use js2-mode for Node scripts
;; (add-to-list 'magic-mode-alist '("#!/usr/bin/env node" . js2-mode))

;; ;; Don't use built-in syntax checking
;; (setq js2-mode-show-strict-warnings nil)

;; ;; Set up proper indentation in JavaScript and JSON files
;; (add-hook 'js2-mode-hook #'dw/set-js-indentation)
;; (add-hook 'json-mode-hook #'dw/set-js-indentation))

;; (use-package prettier-js
;; ;; :hook ((js2-mode . prettier-js-mode))
;; :config
;; (setq prettier-js-show-errors nil))

(use-package rjsx-mode
  :mode "\\.jsx?\\'"
  :config
  (add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))
  ;; Set up proper indentation in JavaScript and JSON files
  (add-hook 'js2-mode-hook #'dw/set-js-indentation)
  (add-hook 'rjsx-mode-hook #'dw/set-js-indentation)
  (add-hook 'json-mode-hook #'dw/set-js-indentation))


;; (defadvice js-jsx-indent-line (after js-jsx-indent-line-after-hack activate)
;; "Workaround sgml-mode and follow airbnb component style."
;; (save-excursion
;; (beginning-of-line)
;; (if (looking-at-p "^ +\/?> *$")
;; (delete-char sgml-basic-offset))))

(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
(add-hook 'scss-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

(add-hook 'css-mode-hook (lambda () (setq tab-width 2)))
(add-hook 'scss-mode-hook (lambda () (setq tab-width 2)))
(add-hook 'html-mode-hook (lambda () (setq tab-width 2)))
(add-hook 'sgml-mode-hook (lambda () (setq tab-width 2)))

(use-package flycheck
  :defer t
  :hook (lsp-mode . flycheck-mode))

(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'"
  :config
  (setq markdown-command "marked")
  (defun dw/set-markdown-header-font-sizes ()
    (dolist (face '((markdown-header-face-1 . 1.2)
                    (markdown-header-face-2 . 1.1)
                    (markdown-header-face-3 . 1.0)
                    (markdown-header-face-4 . 1.0)
                    (markdown-header-face-5 . 1.0)))
      (set-face-attribute (car face) nil :weight 'normal :height (cdr face))))

  (defun dw/markdown-mode-hook ()
    (dw/set-markdown-header-font-sizes))

  (add-hook 'markdown-mode-hook 'dw/markdown-mode-hook))

(use-package hydra)
(use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))
(use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))
(use-package dap-java :ensure nil)

;; spring boot support is experimental
(require 'lsp-java-boot)

;; to enable the lenses
(add-hook 'lsp-mode-hook #'lsp-lens-mode)
(add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)

(add-hook 'java-mode-hook (lambda () (setq tab-width 2)))

(use-package org-roam
  :ensure t
  :demand t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Notes/Roam")
  :config
  (org-roam-db-autosync-mode))

;; Turn on indentation and auto-fill mode for Org files
(defun dw/org-mode-setup ()
  (org-indent-mode)
  (auto-fill-mode 0))

;; symbol ▼  ⤵
(use-package org
  :defer t
  :hook (org-mode . dw/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t
        org-src-fontify-natively t
        org-fontify-quote-and-verse-blocks t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 2
        org-hide-block-startup nil
        org-src-preserve-indentation nil
        org-startup-folded 'content
        org-cycle-separator-lines 2
        org-adapt-indentation t
        org-agenda-start-with-log-mode t
        org-log-done 'time
        org-log-into-drawer t)
  (setq org-agenda-files
        '("~/Projects/notes/emacs/Tasks.org"
          "~/Projects/notes/emacs/Habits.org"
          "~/Projects/notes/emacs/Notes.org"
          "~/Projects/notes/emacs/Birthdays.org"))

  (setq org-modules
        '(org-crypt
          org-habit
          org-bookmark
          org-eshell
          org-irc))

  (setq org-refile-targets '((nil :maxlevel . 1)
                             (org-agenda-files :maxlevel . 1)))

  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-use-outline-path t)

  (setq org-todo-keywords
        '((sequence "BACKLOG(b)" "TODO(t)" "WIP(w)" "CODE-REVIEW(c)" "DEV-DONE(d)" "IN-QA(q)" "NEEDS-INFO(n)" "|" "DONE(d)" "INVALID(i)"))))

;; Replace list hyphen with dot
;; (font-lock-add-keywords 'org-mode
;;                         '(("^ *\\([-]\\) "
;;                            (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(require 'org-faces)
;; Make sure org-indent face is available
(require 'org-indent)

;;(set-face-attribute 'org-document-title nil :font "Iosevka Aile" :weight 'bold :height 1.3)
;;(set-face-attribute 'org-document-title nil :font "JetBrains Mono" :weight 'bold :height 1.3)
(set-face-attribute 'org-document-title nil :font "Source Code Pro" :weight 'bold :height 1.2)
(set-face-attribute 'org-document-info nil :font "Source Code Pro" :weight 'bold :height 1.1)

;; set the size of nested headings
(dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.1)
                (org-level-3 . 1.0)
                (org-level-4 . 1.0)
                (org-level-5 . 1.0)
                (org-level-6 . 1.0)
                (org-level-7 . 1.0)
                (org-level-8 . 1.0)))
  (set-face-attribute (car face) nil :font "Iosevka Aile" :weight 'extra-bold :height (cdr face)))
;; (set-face-attribute (car face) nil :font "Iosevka Aile" :weight 'bold :height (cdr face)))


;; check other faces - https://github.com/tkf/org-mode/blob/master/lisp/org-faces.el

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-table nil  :inherit 'fixed-pitch)
(set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow variable-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow variable-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

;; Get rid of the background on column views
(set-face-attribute 'org-column nil :background nil)
(set-face-attribute 'org-column-title nil :background nil)

;;use bullet list mode for heading
;; (use-package org-bullets
;;   :after org
;;   :hook (org-mode . org-bullets-mode)
;;   :custom
;;   (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(use-package org-superstar
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-remove-leading-stars t)
  (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 130
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1)
  (visual-line-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

;; Org babels
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (C . t)
   (shell . t)
   (sql . t)
   (js . t)
   (plantuml . t)
   (restclient . t)
   (go . t)))

;; this disables the evaluation prompt inside org file
(setq org-confirm-babel-evaluate nil)

;; tab width is as if the language is indented in its major mode
(setq org-src-tab-acts-natively t)

(defun dw/org-present-prepare-slide ()
  (org-overview)
  (org-show-entry)
  (org-show-children))

(defun dw/org-present-hook ()
  (setq-local face-remapping-alist '((default (:height 1.5) fixed-pitch)
                                     (header-line (:height 4.5) fixed-pitch)
                                     (org-document-title (:height 1.75) org-document-title)
                                     (org-code (:height 1.3) org-code)
                                     (org-verbatim (:height 1.3) org-verbatim)
                                     (org-block (:height 1.3) org-block)
                                     (org-block-begin-line (:height 1.0) org-block)))
  (setq header-line-format " ")
  (org-appear-mode -1)
  (org-display-inline-images)
  (dw/org-present-prepare-slide)
  (efs/kill-panel))

(defun dw/org-present-quit-hook ()
  (setq-local face-remapping-alist '((default default default)))
  (setq header-line-format nil)
  (org-present-small)
  (org-remove-inline-images)
  (org-appear-mode 1)
  (org-present-mode 0))
;;(efs/start-panel))

(defun dw/org-present-prev ()
  (interactive)
  (org-present-prev)
  (dw/org-present-prepare-slide))

(defun dw/org-present-next ()
  (interactive)
  (org-present-next)
  (dw/org-present-prepare-slide)
  (when (fboundp 'live-crafter-add-timestamp)
    (live-crafter-add-timestamp (substring-no-properties (org-get-heading t t t t)))))

(use-package org-present
  :hook ((org-present-mode . dw/org-present-hook)
         (org-present-mode-quit . dw/org-present-quit-hook)
         (org-present-after-navigate-functions . my/org-present-prepare-slide)))

(require 'simple-httpd)
(setq httpd-root "/var/www")
;; (httpd-start)

(use-package dired
  :init (setq all-the-icons-dired-monochrome nil)
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first")))

(use-package dired-single)

(use-package all-the-icons-dired
  :hook (dired-mode-hook . all-the-icons-dired-mode))

;; treemacs ------------------------------------------------------------------------------------------------
(use-package treemacs
  :ensure t
  :defer t)

;; used with treemacs ------------------------------------------------------------------------------------

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :ensure t
  :config (treemacs-set-scope-type 'Tabs))

;; sequence diagram from www.websequencediagrams.com ------------------------------------------------------
(add-hook 'wsd-mode-hook 'company-mode)
;; plantuml diagrams ----------------------------------------------------------------------------------------
(setq org-plantuml-jar-path
      (expand-file-name "~/Projects/notes/plantuml/plantuml-1.2022.5.jar"))

;; yaml mode ------------------------------------------------------------------------------------------------
(use-package yaml-mode
  :hook (yaml-mode . lsp-deferred))
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;; golang gopls lsp setup taken from  ----------------------------------------------------------------------
(use-package go-mode
  :ensure t
  :bind (
         ;; If you want to switch existing go-mode bindings to use lsp-mode/gopls instead
         ;; uncomment the following lines
         ;; ("C-c C-j" . lsp-find-definition)
         ;; ("C-c C-d" . lsp-describe-thing-at-point)
         )
  :hook ((go-mode . lsp-deferred)
         (before-save . lsp-format-buffer)
         (before-save . lsp-organize-imports)))

(add-hook 'go-mode-hook (lambda () (setq tab-width 2)))

;; dap mode debugging
(require 'dap-dlv-go)


;; DAP mode ------------------------------------------------------------------------------------------------
(use-package dap-mode
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  :config
  (dap-ui-mode 1)

  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup)) ;; Automatically installs Node debug adapter if needed

;; C++ lsp mode  --------------------------------------------------------------------------------------------
;; install language server : sudo snap install clangd --classic
;; (add-hook 'c-mode-hook 'lsp)
;; (add-hook 'c++-mode-hook 'lsp)

;; Read Dockerfile --------------------------------------------------------------------------------------
(require 'dockerfile-mode)

;; dsp for for SQLS
(add-hook 'sql-mode-hook 'lsp)
(setq lsp-sqls-workspace-config-path nil)
(setq lsp-sqls-connections
      '(((driver . "postgresql") (dataSourceName . "host=127.0.0.1 port=5432 user=postgres password=postgres dbname=fulfillment_service sslmode=disable"))))


;; Python lsp mode ------------------------------------------------------------------------------------------
(use-package python-mode
  :ensure nil
  :hook (python-mode . lsp-deferred)
  :custom
  (python-shell-interpreter "python3")
  (dap-python-executable "python3"))

(require 'dap-python)
(setq dap-python-debugger 'debugpy)


(setq org-babel-python-command "python3")
(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
            (setq python-indent-offset 4)))


(use-package css-mode
  :ensure nil
  :hook (css-mode . lsp-deferred))

(use-package html-mode
  :ensure nil
  :hook (html-mode . lsp-deferred))

(use-package scss-mode
  :ensure nil
  :hook (scss-mode . lsp-deferred))


;; better code completion -----------------------------------------------------------------------------------
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))
;; better looking suggestions
(use-package company-box
  :hook (company-mode . company-box-mode))

;; code commenting
(use-package evil-nerd-commenter
  :bind ("C-/" . evilnc-comment-or-uncomment-lines))

;; (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(use-package dired-open
  :config
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

;; kill the current buffer when selecting a new directory to display
;; (setq dired-kill-when-opening-new-dired-buffer t)


;; yas snippets - - - - - - - - - - - - - - - - - - - - - - - - - -  -- -- - - -- -
;; C++ snippets using yasnippet
(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config
  (setq yas-snippet-dirs '("~/config/emacs-snippets"))
  (yas-global-mode 1))


;; term mode ----------------------------------------------------------------------------------
(use-package term
  :config
  (setq explicit-shell-file-name "bash") ;; Change this to zsh, etc
  ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

  ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

;; colouring your terminal in term-mode
(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

;; eshell --------------------------------------------------------------------------------------------------
(defun read-file (file-path)
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))

(defun dw/get-current-package-version ()
  (interactive)
  (let ((package-json-file (concat (eshell/pwd) "/package.json")))
    (when (file-exists-p package-json-file)
      (let* ((package-json-contents (read-file package-json-file))
             (package-json (ignore-errors (json-parse-string package-json-contents))))
        (when package-json
          (ignore-errors (gethash "version" package-json)))))))

(defun dw/map-line-to-status-char (line)
  (cond ((string-match "^?\\? " line) "?")))

(defun dw/get-git-status-prompt ()
  (let ((status-lines (cdr (process-lines "git" "status" "--porcelain" "-b"))))
    (seq-uniq (seq-filter 'identity (mapcar 'dw/map-line-to-status-char status-lines)))))

(defun dw/get-prompt-path ()
  (let* ((current-path (eshell/pwd))
         (git-output (shell-command-to-string "git rev-parse --show-toplevel"))
         (has-path (not (string-match "^fatal" git-output))))
    (if (not has-path)
        (abbreviate-file-name current-path)
      (string-remove-prefix (file-name-directory git-output) current-path))))

;; This prompt function mostly replicates my custom zsh prompt setup
;; that is powered by github.com/denysdovhan/spaceship-prompt.
(defun dw/eshell-prompt ()
  (let ((current-branch (magit-get-current-branch))
        (package-version (dw/get-current-package-version)))
    (concat
     "\n"
     (propertize "Mathura" 'face `(:foreground "#62aeed" :family "OLCK Optimum Med"))
     (propertize " ॐ " 'face `(:foreground "#ff9f33"))
     (propertize (dw/get-prompt-path) 'face `(:foreground "#82cfd3"))
     (when current-branch
       (concat
        (propertize " • " 'face `(:foreground "white"))
        (propertize (concat " " current-branch) 'face `(:foreground "#c475f0"))))
     (when package-version
       (concat
        (propertize " @ " 'face `(:foreground "white"))
        (propertize package-version 'face `(:foreground "#e8a206"))))
     (propertize " • " 'face `(:foreground "white"))
     (propertize (format-time-string "%I:%M:%S %p") 'face `(:foreground "#5a5b7f"))
     (if (= (user-uid) 0)
         (propertize "\n#" 'face `(:foreground "red2"))
       (propertize "\nλ" 'face `(:foreground "#aece4a")))
     (propertize " " 'face `(:foreground "white")))))

;; (add-hook 'eshell-banner-load-hook
;;          (lambda ()
;;             (setq eshell-banner-message
;;                   (concat "\n" (propertize " " 'display (create-image "~/config/.config/emacs/eshell/sarna.png" 'png nil :scale 0.05 :align-to "center"))
;;                           "\n"))))

(defun dw/eshell-configure ()
  (use-package xterm-color)

  (push 'eshell-tramp eshell-modules-list)
  (push 'xterm-color-filter eshell-preoutput-filter-functions)
  (delq 'eshell-handle-ansi-color eshell-output-filter-functions)

  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  (add-hook 'eshell-before-prompt-hook
            (lambda ()
              (setq xterm-color-preserve-properties t)))

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; We want to use xterm-256color when running interactive commands
  ;; in eshell but not during other times when we might be launching
  ;; a shell command to gather its output.
  (add-hook 'eshell-pre-command-hook
            (lambda () (setenv "TERM" "xterm-256color")))
  (add-hook 'eshell-post-command-hook
            (lambda () (setenv "TERM" "dumb")))

  ;; Use completion-at-point to provide completions in eshell
  (define-key eshell-mode-map (kbd "<tab>") 'completion-at-point)

  ;; Initialize the shell history
  (eshell-hist-initialize)

  (setenv "PAGER" "cat")

  (setq eshell-prompt-function      'dw/eshell-prompt
        eshell-prompt-regexp        "^λ "
        eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-highlight-prompt t
        eshell-scroll-to-bottom-on-input t
        eshell-prefer-lisp-functions nil))

(use-package eshell
  :hook (eshell-first-time-mode . dw/eshell-configure)
  :init
  (setq eshell-directory-name "~/Configs/.config/emacs/eshell/"))

(use-package eshell-z
  :hook ((eshell-mode . (lambda () (require 'eshell-z)))
         (eshell-z-change-dir .  (lambda () (eshell/pushd (eshell/pwd))))))

(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; visual commands
(with-eval-after-load 'esh-opt
  (setq eshell-destroy-buffer-when-process-dies t)
  (setq eshell-visual-commands '("htop" "zsh" "vim")))

;; Fish completion
(use-package fish-completion
  :hook (eshell-mode . fish-completion-mode))

;; command highlighting
(use-package eshell-syntax-highlighting
  :after esh-mode
  :config
  (eshell-syntax-highlighting-global-mode +1))

;; History autocompletion
(use-package esh-autosuggest
  :hook (eshell-mode . esh-autosuggest-mode)
  :config
  (setq esh-autosuggest-delay 0.5)
  (set-face-foreground 'company-preview-common "#4b5668")
  (set-face-background 'company-preview nil))

;; Toggling eshell
(use-package eshell-toggle
  :bind ("C-<return>" . eshell-toggle)
  :custom
  (eshell-toggle-window-side 'right)
  (eshell-toggle-use-projectile-root t)
  (eshell-toggle-run-command nil))

(use-package password-store)

(setq custom-file (concat user-emacs-directory "emacs-custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))
