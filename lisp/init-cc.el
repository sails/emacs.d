;;; init-cc.el ---  c/c++ -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


;; 基于google style修改编程风格
(require-package 'google-c-style)
(c-add-style "Google" google-c-style)
(c-add-style "mine" '("Google"
                      (c-basic-offset . 4)
                      (c-offsets-alist . ((innamespace . 0)
                                          (access-label . -3)
                                          (case-label . 0)
                                          (member-init-intro . +)
                                          (topmost-intro . 0)
                                          ))))

(add-hook 'c-mode-common-hook
          (lambda ()

            (c-set-style "mine")

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

            ;; company
            (after-load 'company
              (set (make-local-variable 'company-backends)
                   '(company-gtags)
                   )
              )))



(provide 'init-cc)
;;; init-cc.el ends here