;;; init-tramp.el ---  tramp -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'tramp)

;; /sshx:devnet:~/
(setq tramp-default-method "sshx")
(setq tramp-chunksize 2000)
(tramp-set-completion-function "sshx"
                               '((tramp-parse-sconfig "/etc/ssh_config")
                                 (tramp-parse-sconfig "~/.ssh/config")))

;; 加快tramp打开文件速度
(setq remote-file-name-inhibit-cache nil)
(setq vc-ignore-dir-regexp
      (format "%s\\|%s"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))
(setq tramp-verbose 1)

(with-eval-after-load 'tramp
  (eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))
  (add-to-list 'tramp-remote-path '("/data/sailsxu/vas_go_proj/bin" "/data/sailsxu/go_proj/bin" "/usr/local/go/bin"))
  )


(provide 'init-tramp)
;;; init-tramp.el ends here
