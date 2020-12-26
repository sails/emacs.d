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
            (flycheck-mode 0)
            (require 'flycheck-google-cpplint)
            (setq flycheck-gcc-language-standard "c++17")
            (setq flycheck-clang-language-standard "c++17")
            (flycheck-add-next-checker 'c/c++-cppcheck
                                       '(warning . c/c++-googlelint))
            (unless (derived-mode-p 'protobuf-mode)
              ;; not in protobuf
              (flycheck-select-checker 'c/c++-cppcheck)
              )

            (setq flycheck-cppcheck-checks (quote ("style" "all")))
            (setq flycheck-googlelint-filter "-legal/copyright,-build/include_subdir")
            (setq flycheck-googlelint-linelength "100")

            ;; company
            ;; company-mode 如果太慢执行company-diag查看backend
            (require 'company-clang)
            (require 'company-dabbrev)
            (set (make-local-variable 'company-backends)
                 '((company-capf company-clang company-files company-keywords)
                   )
                 )

            ;; helm-gtags
            (require-package 'helm-gtags)
            (setenv "GTAGSFORCECPP" "1")
            (add-hook 'c-mode-hook 'helm-gtags-mode)
            (add-hook 'c++-mode-hook 'helm-gtags-mode)
            (add-hook 'asm-mode-hook 'helm-gtags-mode)
            (add-hook 'jce-mode-hook 'helm-gtags-mode)
            (add-hook 'protobuf-mode-hook 'helm-gtags-mode)
            (with-eval-after-load 'helm-gtags
              (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
              (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-find-tag-from-here)
              (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
              (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack))

            ;; ccls比clangd对lsp支持更完善(比如lsp-find-definition,lsp-find-references,pop-tag-mark)
            ;; 不管是ccls还是clangd，如果compile_commands.json很大(10M)，首次分析cpu会占用特别高，并且持
            ;; 续几分钟，所以最好是用daemon模式运行emacs。这里通过限制ccls的threads来限制cpu核数使用
            ;; (require-package 'ccls)
            ;; (require 'ccls)
            ;; (setq ccls-initialization-options
            ;;       '(
            ;;         :index (:threads 4)))
            ;; (require-package 'lsp-mode)
            ;; ;; (require-package 'lsp-ui)

            ;; (add-hook 'c-mode-hook #'lsp)
            ;; (add-hook 'c++-mode-hook #'lsp)
            ;; (setq lsp-enable-file-watchers nil)
            ;; ;; 禁用lsp默认的flycheck设置
            ;; (setq lsp-diagnostic-package :none)

            ;; 可以很方便的在头文件与cpp文件中切换
            (setq cc-other-file-alist
                  '(("\\.c"   (".h"))
                    ("\\.cpp"   (".h"))
                    ("\\.h"   (".c"".cpp"".cc"))))
            (setq ff-search-directories
                  '("." "../src" "../include"))

            (local-set-key  (kbd "C-c o") 'ff-find-other-file)



            (require-package 'quickrun)
            (quickrun-add-command "c++/c17"
              '((:command . "g++")
                (:exec    . ("%c -std=c++17 %o -o %e %s"
                             "%e %a"))
                (:remove  . ("%e")))
              :default "c++")

            ))


(provide 'init-cc)



;;; init-cc.el ends here
