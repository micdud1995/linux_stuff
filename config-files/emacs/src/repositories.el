;; Load package.el
(require 'package)

;; Add melpa to the list of repositories
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; Initialize package.el
(package-initialize)
