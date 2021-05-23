;;; early-init.el --- Emacs 27+ pre-initialisation config

;;; Commentary:

;; Emacs 27+ loads this file before (normally) calling
;; `package-initialize'.  We use this file to suppress that automatic
;; behaviour so that startup is consistent across Emacs versions.

;;; Code:

(setq package-enable-at-startup nil)

(setenv "LIBRARY_PATH" "/usr/local/opt/gcc/lib/gcc/11:/usr/local/opt/gcc/lib/gcc/11/gcc/x86_64-apple-darwin20/11.1.0")

;; (setq url-proxy-services '(("http" . "127.0.0.1:12759")))
;; (setq url-proxy-services '(("https" . "127.0.0.1:12759")))
;; So we can detect this having been loaded
(provide 'early-init)

;;; early-init.el ends here
