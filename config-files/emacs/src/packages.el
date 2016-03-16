;; Create repositories cache, if required
(when (not package-archive-contents)
  (package-refresh-contents))

;; Declare a list of required packages
(defvar super-emacs--required-packages
  '(async
    auto-complete
    autopair
    bongo
    centered-cursor-mode
    dash
    ecb
    elfeed
    git-commit
    magit
    magit-popup
    popup
    quasi-monochrome-theme
    smex
    switch-window
    undo-tree
    with-editor))

;; Install required packages
(mapc (lambda (p)
    (package-install p))
      super-emacs--required-packages)

;; Cursor always centered
(and
  (require 'centered-cursor-mode)
  (global-centered-cursor-mode +1))

;; Install required packages
(mapc (lambda (p)
   (package-install p))
   super-emacs--required-packages)

;; InteractivelyDoThings
(ido-mode)
(ido-mode 'both) ;; for buffers and files
ido-ignore-buffers ;; ignore these guys
'("\\` " "^\*Mess" "^\*Back" ".*Completion" "^\*Ido" "^\*trace" "^\*compilation" "^\*GTAGS" "^session\.*" "^\*" "^\*scratch" "^\*ECB" "^\*Compile")
;; ido-work-directory-list '("~/" "~/Desktop" "~/Documents" "~src")
ido-case-fold  t;    be case-insensitive
(setq confirm-nonexistent-file-or-buffer nil)

;; Winner-mode
(winner-mode t)
(windmove-default-keybindings)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(calendar-abbrev-length 12)
 '(calendar-date-style (quote european))
 '(ecb-after-directory-change-hook nil)
 '(ecb-auto-activate t)
 '(ecb-auto-expand-directory-tree (quote best))
 '(ecb-compile-window-height 6)
 '(ecb-create-layout-frame-height 40)
 '(ecb-create-layout-frame-width 25)
 '(ecb-create-new-layout right)
 '(ecb-eshell-auto-activate t)
 '(ecb-fix-window-size (quote width))
 '(ecb-layout-name "ide")
 '(ecb-layout-window-sizes nil)
 '(ecb-minor-mode-text "")
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote (("/home/michal/.emacs.d/src/" "/"))))
 '(ecb-windows-height 40)
 '(ecb-windows-width 20)
 '(erc-autojoin-mode t)
 '(erc-beep-match-types (quote (current-nick)))
 '(erc-beep-p t)
 '(erc-button-mode t)
 '(erc-fill-mode t)
 '(erc-hide-list (quote ("JOIN" "KICK" "QUIT")))
 '(erc-irccontrols-mode t)
 '(erc-list-mode t)
 '(erc-match-mode t)
 '(erc-menu-mode t)
 '(erc-move-to-prompt-mode t)
 '(erc-netsplit-mode t)
 '(erc-networks-mode t)
 '(erc-noncommands-mode t)
 '(erc-pcomplete-mode t)
 '(erc-readonly-mode t)
 '(erc-ring-mode t)
 '(erc-stamp-mode t)
 '(erc-track-minor-mode t)
 '(erc-track-mode t)
 '(european-calendar-style t)
 '(fci-rule-color "#383838")
 '(ido-ignore-buffers
   (quote
    ("*ECB Methods*" "*ECB Sources*" "*Messages*" "^ " "\\` ")))
 '(inhibit-startup-echo-area-message nil)
 '(inhibit-startup-screen t)
 '(neo-theme (quote ascii))
 '(neo-window-fixed-size t)
 '(neo-window-position (quote left))
 '(neo-window-width 20)
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(tab-stop-list
   (quote
    (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120)))
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))

;; Autocomplete
(ac-config-default)

;; Autostart autopair
(autopair-global-mode)

;; Undo things
(global-undo-tree-mode)
(global-set-key (kbd "M-/") 'undo-tree-visualize)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t nil)))
 '(ecb-default-highlight-face ((t nil))))

(setq ecb-tip-of-the-day nil)
(ecb-activate)

(setq elfeed-feeds
    '("https://www.archlinux.org/feeds/news/"
      "https://www.archlinux.org/feeds/releases/"
      "http://bash.org.pl/rss"
      "http://wroclaw.naszemiasto.pl/rss/artykuly/61.xml"
      "http://wroclaw.naszemiasto.pl/rss/artykuly/73.xml"
      "http://feeds.linuxportal.pl/LinuxPortalpl-news" 
      "http://joemonster.org/backend.php?channel" 
      "http://www.cdaction.pl/rss_newsy.xml"
      "http://www.devrand.org/feeds/posts/default"))
