;; Moving binds
(global-set-key (kbd "<home>") 'beginning-of-buffer)
(global-set-key (kbd "<end>") 'end-of-buffer)
;; make cursor movement keys under right hand's home-row.
;; (global-set-key (kbd "M-k") 'previous-line)
;; (global-set-key (kbd "M-h") 'backward-char)
;; (global-set-key (kbd "M-j") 'next-line)
;; (global-set-key (kbd "M-l") 'forward-char)

;; Fast opening file
(global-set-key
 (kbd "<f12>")
 (lambda ()
   (interactive)
   (find-file "~/.emacs.d/src/packages.el")))

;; Faster buffers changing
(global-set-key (kbd "<right>") 'next-buffer)
(global-set-key (kbd "<left>") 'previous-buffer)

;; Move to the beginning and the end of function
(global-set-key (kbd "<up>") 'beginning-of-defun)
(global-set-key (kbd "<down>") 'end-of-defun)

;; Make bind
(global-set-key (kbd "C-c m") 'recompile)

;; Faster killing current buffer
(global-set-key (kbd "C-x k") 'kill-this-buffer)

;; Buffer resize
;(global-set-key (kbd "C-x <up>") 'shrink-window-horizontally)
;(global-set-key (kbd "C-x <down>") 'enlarge-window-horizontally)

;; Shows numbers of buffers to choice
(global-set-key (kbd "M-p") 'switch-window)

;; PLugins
(global-set-key (kbd "<f5>") 'bongo)
(global-set-key (kbd "<f6>") 'elfeed)
(global-set-key (kbd "<f7>") 'magit-status)

(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
  )
(global-set-key (kbd "C-i") 'duplicate-line)

(defun kill-current-line (&optional n)
  (interactive "p")
  (save-excursion
    (beginning-of-line)
    (let ((kill-whole-line t))
      (kill-line n))))
(global-set-key (kbd "C-k") 'kill-current-line)

(defun vi-open-line-below ()
  "Insert a newline below the current line and put point at beginning."
  (interactive)
  (unless (eolp)
    (end-of-line))
  (newline-and-indent))
(global-set-key (kbd "C-o") 'vi-open-line-below)
