(load-file "~/.emacs.d/src/repositories.el")
(load-file "~/.emacs.d/src/packages.el")
(load-file "~/.emacs.d/src/interface.el")
(load-file "~/.emacs.d/src/binds.el")
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
 '(custom-enabled-themes (quote (quasi-monochrome)))
 '(custom-safe-themes
   (quote
    ("1fab355c4c92964546ab511838e3f9f5437f4e68d9d1d073ab8e36e51b26ca6a" default)))
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
 '(ecb-source-path (quote (("/home/michal" "/"))))
 '(ecb-windows-height 40)
 '(ecb-windows-width 20)
 '(elfeed-feeds
   (quote
    ("https://www.archlinux.org/feeds/news/" "https://www.archlinux.org/feeds/releases/" "http://bash.org.pl/rss" "http://wroclaw.naszemiasto.pl/rss/artykuly/61.xml" "http://wroclaw.naszemiasto.pl/rss/artykuly/73.xml" "http://feeds.linuxportal.pl/LinuxPortalpl-news")))
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
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t nil)))
 '(ecb-default-highlight-face ((t nil)))
 '(minimap-font-face ((t (:height 3 :family "DejaVu Sans Mono")))))
