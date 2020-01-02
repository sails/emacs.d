;;; init-gtags'.el ---  gtags -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; helm-gtags
(require-package 'helm-gtags)
(setenv "GTAGSFORCECPP" "1")
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)
(add-hook 'jce-mode-hook 'helm-gtags-mode)
(with-eval-after-load 'helm-gtags
  (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
  (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-find-tag-from-here)
  (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
  (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack))

(provide 'init-gtags)
;;; init-gtags.el ends here
