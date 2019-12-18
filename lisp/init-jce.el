;;; init-jce.el --- jce -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(autoload
  'jce-mode
  "jce-mode"
  "Major mode for TAF specification language."
  t)

(add-to-list 'auto-mode-alist '("\\.jce\\'" . jce-mode))

;; Use HTML mode for .wsp files.
(add-to-list 'auto-mode-alist '("\\.wsp\\'" . html-mode))

(provide 'init-jce)
;;; init-jce.el ends here
