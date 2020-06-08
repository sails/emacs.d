;;; init-cc.el ---  c/c++ -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(add-hook 'c-mode-common-hook
          (lambda ()

            ;; 基于google style修改编程风格
            (require-package 'google-c-style)
            ;; (c-add-style "mine" '("Google"
            ;;                       (c-basic-offset . 4)
            ;;                       (c-offsets-alist . ((innamespace . 0)
            ;;                                           (access-label . -3)
            ;;                                           (case-label . 0)
            ;;                                           (member-init-intro . +)
            ;;                                           (topmost-intro . 0)
            ;;                                           ))))

            ;; (google-set-c-style)
            ;; (c-set-style "mine")
            (google-set-c-style)
            (google-make-newline-indent)

            ;; flycheck 设置
            (flycheck-mode 1)
            (require 'flycheck-google-cpplint)
            (setq flycheck-clang-language-standard "c++11")
            (flycheck-add-next-checker 'c/c++-cppcheck
                                       '(warning . c/c++-googlelint))
            (flycheck-select-checker 'c/c++-cppcheck)
            (setq flycheck-cppcheck-checks (quote ("style" "all")))
            (setq flycheck-googlelint-linelength "100")

            ;; company
            ;; company-mode 如果太慢执行company-diag查看backend
            (require 'company-clang)
            (require 'company-dabbrev)
            (require-package 'company-lsp)
            (require-package 'company-tabnine)
            (set (make-local-variable 'company-backends)
                 '((company-lsp company-tabnine company-clang company-files company-keywords)
                   (company-abbrev company-dabbrev)
                   ;; 如果不在这最后加一个company-lsp，lsp-mode会调用add-to-list把company-lsp加到company-keywords最前面，
                   ;; 导致company-lsp不能同其它后端在一个组里
                   company-lsp
                   )
                 )

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

            (add-hook 'c-mode-hook #'lsp)
            (add-hook 'c++-mode-hook #'lsp)
            (setq lsp-enable-file-watchers nil)

            (with-eval-after-load 'lsp-mode (lsp-register-client
                                             (make-lsp-client
                                              :new-connection (lsp-tramp-connection "/usr/local/bin/clangd")
                                              ;; :new-connection (lsp-tramp-connection "/usr/local/bin/ccls")
                                              :major-modes '(c-mode c++-mode)
                                              :remote? t
                                              :server-id 'c++-remote)))



            ;; lsp的自动配置过程会把flycheck重置
            (setq lsp-auto-configure nil)
            ;; ;; 去掉lsp检查
            ;; (setq-default flycheck-disabled-checkers '(lsp))


            ;; 可以很方便的在头文件与cpp文件中切换
            (setq cc-other-file-alist
                  '(("\\.c"   (".h"))
                    ("\\.cpp"   (".h"))
                    ("\\.h"   (".c"".cpp"".cc"))))
            (setq ff-search-directories
                  '("." "../src" "../include"))

            (local-set-key  (kbd "C-c o") 'ff-find-other-file)



            (require-package 'quickrun)
            (quickrun-add-command "c++/c11"
              '((:command . "g++")
                (:exec    . ("%c -std=c++11 %o -o %e %s"
                             "%e %a"))
                (:remove  . ("%e")))
              :default "c++")
            ;; (setq flycheck-gcc-language-standard "c++11")
            ;; (setq flycheck-clang-language-standard "c++11")

            ))


(provide 'init-cc)



;;; init-cc.el ends here
