;; Default font
(set-default-font "Inconsolata-9")

;; Default theme
(setq sml/no-confirm-load-theme t)
(load-theme 'cyberpunk t)

;; Different colors for odd and even lines
;;(turn-on-stripes-mode)

;; Show battery status
(display-battery-mode 1)

;; No bell
(setq ring-bell-function 'ignore)

;; Frame title
(setq frame-title-format "emacs")

;; No bars
(menu-bar-mode -1)
(tool-bar-mode -1)

;; (column-number-mode)
(show-paren-mode)

;; Highlight current line
;; (global-hl-line-mode)

;; Insert 4 space isntead of tab
(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(setq-default tab-width 4)
;; make tab key always call a indent command.
(setq-default tab-always-indent t)
;; Better indent style
(setq c-default-style "linux"
    c-basic-offset 4)

;; Max 80 signs in a line
(setq-default header-line-format
(list " " (make-string 79 ?-) "|"))

;; Makes *scratch* empty.
(setq initial-scratch-message nil)

;; Don't make backup files
(setq make-backup-files nil)
;; Disable backup
(setq backup-inhibited t)
;; Disable auto save
(setq auto-save-default nil)

;; Forces the messages to 0, and kills the *Messages* buffer
(setq-default message-log-max nil)
(kill-buffer "*Messages*")
(kill-buffer "*Compile-Log*")
