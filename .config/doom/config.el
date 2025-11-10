;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Projectile known directories
(projectile-discover-projects-in-directory "~/deckenburg/" 1)
(projectile-discover-projects-in-directory "~/deckenburg/osna" 4)
(projectile-discover-projects-in-directory "~/deckenburg/git/" 1)
(projectile-discover-projects-in-directory "~/deckenburg/synch/" 1)
(projectile-discover-projects-in-directory "~/deckenburg/synch/GateOne/" 1)
(projectile-discover-projects-in-directory "~/deckenburg/synch/git-merge-attempts/fullstack/" 1)

(setq projectile-cleanup-known-projects t)

;; catppuccin theme
(setq doom-theme 'catppuccin)


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/deckenburg/org/")


;; Change cursors in insert mode
(add-hook 'evil-insert-state-entry-hook (lambda () (send-string-to-terminal "\033[5 q")))
(add-hook 'evil-insert-state-exit-hook  (lambda () (send-string-to-terminal "\033[2 q")))

;; Use delta for diffs in magit
(use-package magit-delta
  :hook (magit-mode . magit-delta-mode))

(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))

(setq lsp-java-java-path "/usr/lib/jvm/java-25-openjdk/bin/java")

;; (setq lsp-java-jdt-download-url
;;       "https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.52.0/jdt-language-server-1.52.0-202510301627.tar.gz")

(setq xterm-extra-capabilities '(getSelection setSelection modifyOtherKeys))

;; ((and (eq system-type 'gnu/linux) (executable-find "wl-copy"))
;;  (setq interprogram-cut-function
;;        (lambda (text &optional _)
;;          (let ((process-connection-type nil))
;;            (let ((proc (start-process "wl-copy" "*Messages*" "wl-copy")))
;;              (process-send-string proc text)
;;              (process-send-eof proc)))))
;;  (setq interprogram-paste-function
;;        (lambda ()
;;          (shell-command-to-string "wl-paste -n"))))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
