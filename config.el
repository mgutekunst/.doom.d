;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-city-lights)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(setq doom-localleader-key ",")

(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 1)
  (setq company-show-quick-access t)
  (add-hook 'evil-normal-state-entry-hook #'company-abort)
  ) ;; make aborting less annoying.

(map! (:when (featurep! company)
 :map company-active-map
 "<tab>" 'company-complete-selection
 :map lsp-mode-map
  :i "<tab>" #'company-indent-or-complete-common))

(use-package! treemacs
  :config
  (setq doom-themes-treemacs-theme "doom-colors")
  (treemacs-follow-mode 1)
  (setq lsp-treemacs-sync-mode t)
  )

(use-package! jest
  :config
  (setq jest-arguments '("--config=src/jest.config.js"))
  (setq jest-executable "jest"))

(setq lsp-clients-angular-language-server-command
  '("node"
    "~/.nvm/versions/node/v14.15.4/lib/node_modules/@angular/language-server"
    "--ngProbeLocations"
    "~/.nvm/versions/node/v14.15.4/lib/node_modules"
    "--tsProbeLocations"
    "~/.nvm/versions/node/v14.15.4/lib/node_modules"
    "--stdio"))


;; Ctrl + z should put emacs to sleep
(map! :n "SPC z z" #'suspend-emacs)

(defun try-start-jest-minor-mode ()
  "start jest minor mode when file ends with .spec.ts"
  (when (string-suffix-p "spec.ts" buffer-file-name)
    (jest-minor-mode 1)))

;; angular-ls prevents rename from working in ts files, so disable it
(add-hook! typescript-mode
           (make-local-variable 'lsp-disabled-clients)
           (setq lsp-disabled-clients '(angular-ls))
           (try-start-jest-minor-mode)
           (lsp-headerline-breadcrumb-mode 1))

(map! :map typescript-mode-map
      :i "<tab>" #'company-indent-or-complete-common)



(after! web
  (setq lsp-enabled-clients '(angular-ls)))
