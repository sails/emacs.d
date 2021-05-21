;;; init-rust.el --- Support for the Rust language -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; (when (ma;; ybe-require-package 'rust-mode)
;;   (when (maybe-require-package 'racer)
;;     (add-hook 'rust-mode-hook #'racer-mode))
;;   (when (maybe-require-package 'company)
;;     (add-hook 'racer-mode-hook #'company-mode)))

;; (when (maybe-require-package 'flycheck-rust)
;;   (with-eval-after-load 'rust-mode
;;     (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))

(require-package 'rustic)
(with-eval-after-load 'rustic
  ;; (add-hook 'rustic-mode-hook (lambda ()
  ;;                               (setq-local buffer-save-without-query t)))
  ;; (setq rustic-format-on-save t
  ;;       lsp-rust-analyzer-cargo-watch-command "clippy"
  ;;       lsp-rust-analyzer-server-display-inlay-hints t)
  )


(provide 'init-rust)
;;; init-rust.el ends here
