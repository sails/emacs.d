;;; init-go.el ---  golang -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(require-package 'go-mode)
(require-package 'lsp-mode)
(add-hook 'go-mode-hook #'lsp)
(add-hook 'go-mode-hook
          (lambda ()

                                        ; Use goimports instead of go-fmt
            (setq gofmt-command "goimports")
            ;; goimports在tramp模式下支持不好，它对目录结构有要求,而tramp时是在
            ;; 临时目录下，所以在编辑远程文件时，不能使用goimports
            ;; (setq gofmt-command "gofmt")

            ;; Call Gofmt before saving
            (add-hook 'before-save-hook 'gofmt-before-save)
                                        ; Godef jump key binding
            (local-set-key (kbd "M-.") 'godef-jump)
            (local-set-key (kbd "M-,") 'pop-tag-mark)
            (setq lsp-prefer-flymake nil)
            (setq lsp-ui-peek-enable t)
            (setq lsp-ui-doc-enable nil)
            (setq lsp-ui-imenu-enable t)
            (setq lsp-ui-flycheck-enable t)
            (setq lsp-ui-sideline-enable nil)
            (setq lsp-ui-sideline-ignore-duplicate t)
            (setq lsp-enable-file-watchers nil)

            ;; (setq-default flycheck-disabled-checkers '(go-build go-vet))

            (require-package 'lsp-mode)
            (with-eval-after-load 'lsp-mode (lsp-register-client
                                             (make-lsp-client
                                              :new-connection (lsp-tramp-connection "/data/sailsxu/go_proj/bin/gopls")
                                              :major-modes '(go-mode)
                                              :remote? t
                                              :server-id 'go-remote)))
            ))

(provide 'init-go)
;;; init-golang.el ends here
