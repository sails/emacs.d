;;; init-cc.el ---  c/c++ -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(add-hook 'c-mode-common-hook
          (lambda ()

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

            (google-set-c-style)
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

            ;; (require-package 'ccls)
            ;; (require 'ccls)
            ;; (setq ccls-executable "/usr/local/bin/ccls")
            (require-package 'lsp-mode)
            ;; (require 'lsp)
            (add-hook 'c-mode-hook #'lsp)
            (add-hook 'c++-mode-hook #'lsp)
            (setq lsp-enable-file-watchers nil)
            (require-package 'company-lsp)

            (with-eval-after-load 'lsp-mode (lsp-register-client
                                             (make-lsp-client
                                              :new-connection (lsp-tramp-connection "/data/sailsxu/install/llvm-project/Release/bin/clangd")
                                              ;; :new-connection (lsp-tramp-connection "/usr/local/bin/ccls")
                                              :major-modes '(c-mode c++-mode)
                                              :remote? t
                                              :server-id 'c++-remote)))

            ;; company

            (after-load 'company
              (require 'company-dabbrev)
              (set (make-local-variable 'company-backends)
                   ;; '(company-gtags company-clang company-lsp)
                   '(company-lsp company-dabbrev company-gtags company-clang)
                   )
              )

            ;; 可以很方便的在头文件与cpp文件中切换
            (setq cc-other-file-alist
                  '(("\\.c"   (".h"))
                    ("\\.cpp"   (".h"))
                    ("\\.h"   (".c"".cpp"".cc"))))
            (setq ff-search-directories
                  '("." "../src" "../include"))

            (local-set-key  (kbd "C-c o") 'ff-find-other-file)
            ))



(provide 'init-cc)
;;; init-cc.el ends here
