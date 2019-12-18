;;; init-preload-local.el ---  Settings for preload local -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10\\..*\\|192\\.168\\..*\\)")
        ("http" . "127.0.0.1:12759")
        ("https" . "127.0.0.1:12759")))

(provide 'init-preload-local)
;;; init-preload-local.el ends here
