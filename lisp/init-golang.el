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

            ))

(add-hook 'go-mode-hook #'lsp)


(provide 'init-golang)
;;; init-golang.el ends here
