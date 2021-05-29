;;; init-cc.el ---  c/c++ -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(defvar +ccls-initial-blacklist [])
(defvar +ccls-initial-whitelist [])

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
            ;; (google-make-newline-indent);; 开启时{回车}时右括号不能自动对齐

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

            ;; ;; company
            ;; ;; company-mode 如果太慢执行company-diag查看backend
            ;; (require 'company-dabbrev)
            ;; (set (make-local-variable 'company-backends)
            ;;      '((company-capf company-dabbrev company-files company-keywords company-gtags)
            ;;        )
            ;;      )

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
            (require-package 'ccls)
            (require 'ccls)
            (setq ccls-initialization-options
                  ;; clang -v -fsyntax-only -x c++ /dev/null
                  `(:clang ,(list :extraArgs ["-isystem/Library/Developer/CommandLineTools/usr/include/c++/v1"
                                              "-isystem/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include"
                                              "-isystem/Library/Developer/CommandLineTools/usr/lib/clang/12.0.5/include"
                                              "-isystem/Library/Developer/CommandLineTools/usr/include"
                                              "-isystem/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks"
                                              "-isystem/usr/local/include"]
                                  )))
            ;; (setq ccls-initialization-options
            ;;       (append ccls-initialization-options
            ;;               `(:index (:threads 1 :initialBlacklist [".*"] :initialWhitelist ["qqmail/wwspam.*" "wework/wwspam.*"]))))

            (require-package 'lsp-mode)
            (add-hook 'lsp-mode-hook (lambda ())
                      ;; 顶部目录、文件、方法breadcrumb
                      (setq lsp-headerline-breadcrumb-enable nil)
                      (setq lsp-modeline-diagnostics-enable nil)
                      )

            ;; (require-package 'lsp-ui)

            ;; directory local variables after major-mode hooks run
            (add-hook 'hack-local-variables-hook
                      (lambda ()
                        (when (derived-mode-p 'c++-mode)
                          ;; +ccls-initial-blacklist +ccls-initial-whitelist在dir-locals.el重新中设置新值
                          (setq ccls-initialization-options
                                (append ccls-initialization-options
                                        `(:index (:threads 1 :initialBlacklist ,+ccls-initial-blacklist :initialWhitelist ,+ccls-initial-whitelist))))
                          ;; (print ccls-initialization-options)
                          (setq lsp-enable-file-watchers nil)
                          (setq lsp-diagnostic-package :none)
                          (lsp)
                          )
                        ))
            ;; (add-hook 'c-mode-hook #'lsp)
            ;; (add-hook 'c++-mode-hook #'lsp)
            ;; (setq lsp-enable-file-watchers nil)
            ;; ;; 禁用lsp默认的flycheck设置
            ;; (setq lsp-diagnostic-package :none)

            ;; 可以很方便的在头文件与cpp文件中切换
            (setq cc-other-file-alist
                  '(("\\.cc\\'"  (".hh" ".h"))
                    ("\\.hh\\'"  (".cc" ".C"))

                    ("\\.c\\'"   (".h"))
                    ("\\.h\\'"   (".c" ".cc" ".C" ".CC" ".cxx" ".cpp" ".m" ".mm"))

                    ("\\.m\\'"    (".h"))
                    ("\\.mm\\'"    (".h"))

                    ("\\.C\\'"   (".H"  ".hh" ".h"))
                    ("\\.H\\'"   (".C"  ".CC"))

                    ("\\.CC\\'"  (".HH" ".H"  ".hh" ".h"))
                    ("\\.HH\\'"  (".CC"))

                    ("\\.c\\+\\+\\'" (".h++" ".hh" ".h"))
                    ("\\.h\\+\\+\\'" (".c++"))

                    ("\\.cpp\\'" (".hpp" ".hh" ".h" "_p.h"))
                    ("\\.hpp\\'" (".cpp"))

                    ("\\.cxx\\'" (".hxx" ".hh" ".h"))
                    ("\\.hxx\\'" (".cxx"))))
            (setq ff-search-directories
                  '("." "../src" "../include"))

            (local-set-key  (kbd "C-c o") 'ff-find-other-file)



            (require-package 'quickrun)
            (quickrun-add-command "c++/c17"
              '((:command . "g++")
                (:exec    . ("%c -std=c++17 %o -o %e %s"
                             "%e %a"))
                (:remove  . ("%e")))
              :default "c++")))


(provide 'init-cc)



;;; init-cc.el ends here
