;;; init-shell.el ---  shell -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; exec-path-from-shell
(require-package 'exec-path-from-shell)
;; 这个插件很厉害，可以得到环境变量的值, 它会自动复制MANPATH, PATH and exec-path，
;; 其它的要通过(exec-path-from-shell-copy-env "GOPATH")的方式来设置
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH")
  )

;; eshell-toggle
(require-package 'eshell-toggle)
(require 'eshell-toggle)
(global-set-key "\M-j" 'eshell-toggle)
(require-package 'eshell-git-prompt)
(with-eval-after-load "esh-opt"
  (eshell-git-prompt-use-theme 'robbyrussell)
  )

(add-hook 'eshell-mode-hook
          (lambda ()
            ;;  关闭company，自动补全反而会让多次输入回车，影响速度
            (company-mode -1)
            ))

;; vterm
(require-package 'vterm)
(require-package 'vterm-toggle)
;; (global-set-key (kbd "M-j") 'vterm-toggle-cd)
(add-hook 'vterm-mode-hook
          (lambda ()
            ;; 当打开vterm后M-j替换eshell中的快捷键
            (define-key vterm-mode-map (kbd "M-j")        #'vterm-toggle-cd)
            ;; cd到当前buffer的目录
            (if (display-graphic-p)
                (progn
                  ;; if graphic
                  (define-key vterm-mode-map (kbd "M-RET")   #'vterm-toggle-insert-cd)
                  )
              ;; else (optional)
              (define-key vterm-mode-map (kbd "C-c j")   #'vterm-toggle-insert-cd)
              )



            (define-key vterm-mode-map (kbd "C-c C-y") 'vterm-yank)
            ;; 在buffer底部显示
            (setq vterm-toggle-fullscreen-p nil)
            (add-to-list 'display-buffer-alist
                         '((lambda(bufname _) (with-current-buffer bufname (equal major-mode 'vterm-mode)))
                           (display-buffer-reuse-window display-buffer-at-bottom)
                           ;;(display-buffer-reuse-window display-buffer-in-direction)
                           ;;display-buffer-in-direction/direction/dedicated is added in emacs27
                           ;;(direction . bottom)
                           ;;(dedicated . t) ;dedicated is supported in emacs27
                           (reusable-frames . visible)
                           (window-height . 0.3)))
            ))


(provide 'init-shell)
;;; init-shell.el ends here
