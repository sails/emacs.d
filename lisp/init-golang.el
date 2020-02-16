;;; init-golang.el ---  golang -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(require-package 'go-mode)
(require-package 'lsp-mode)
(add-hook 'go-mode-hook
          (lambda ()

                                        ; Use goimports instead of go-fmt
            (setq gofmt-command "goimports")
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

            (setq-default flycheck-disabled-checkers '(go-build go-vet))



            ))

(add-hook 'go-mode-hook #'lsp)
(with-eval-after-load 'lsp-mode (lsp-register-client
                                 (make-lsp-client
                                  :new-connection (lsp-tramp-connection "/data/sailsxu/go_proj/bin/gopls")
                                  :major-modes '(go-mode)
                                  :remote? t
                                  :server-id 'go-remote)))


(provide 'init-golang)
;;; init-golang.el ends here
