;;; init-local.el ---  Settings for local -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; (set-fontset-font t 'han (font-spec :family "Heiti SC" :size 14))
;; (set-default-font "Monaco 13")
;; (set-face-attribute 'default nil :font "Monaco-13")
(set-face-attribute 'default nil :font "Fira Code-12")

;; Increase the amount of data which Emacs reads from the process
;; Considering that the some of the language server responses are in 800k - 3M range.
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(setq default-directory "~/")
;; 代码注释
(defun qiang-comment-dwim-line (&optional arg)
  "Comment as ARG."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key "\M-;" 'qiang-comment-dwim-line)

;; 调用reveal-in-osx-finder在finder中打开当前目录，并选中当前文件
(require-package 'reveal-in-osx-finder)

;; 高效的选中region
(require-package 'expand-region)
(global-set-key (kbd "C-x m") 'er/expand-region)
;; 有某些主题中,终端下区分度不大
;; (set-face-attribute 'region nil :background "#6666" :foreground "#ffffff")

;; 复制当前buffer name
(defun copy-file-name(choice)
  "Copy the `buffer-file-name` to the `kill-ring` as CHOICE."
  (interactive "cCopy Buffer Name (f) full, (d) directory, (n) name")
  (let ((new-kill-string)
        (name (if (eq major-mode 'dired-mode)
                  (dired-get-filename)
                (or (buffer-file-name) ""))))
    (cond ((eq choice ?f)
           (setq new-kill-string name))
          ((eq choice ?d)
           (setq new-kill-string (file-name-directory name)))
          ((eq choice ?n)
           (setq new-kill-string (file-name-nondirectory name)))
          (t (message "Quit")))
    (when new-kill-string
      (message "%s copied" new-kill-string)
      (kill-new new-kill-string)
      )
    )
  )




(require-package 'yasnippet)
(require-package 'yasnippet-snippets)
(with-eval-after-load 'yasnippet
  (progn
    (append yas-snippet-dirs '("~/.emacs.d/snippets" . "~/workspace/emacs/snippets"))
    ))
;;(setq yas/prompt-functions '(yas/dropdown-prompt))
(yas-global-mode 1)

;; quickrun
(require-package 'quickrun)

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
;; vterm
(require-package 'vterm)
(require-package 'vterm-toggle)
;; (global-set-key "\M-j" 'vterm-toggle-cd)
(global-set-key (kbd "M-j") 'vterm-toggle-cd)
(add-hook 'vterm-mode-hook
          (lambda ()
            (define-key vterm-mode-map (kbd "M-j")        #'vterm-toggle-cd)
            ;; cd到当前buffer的目录
            (define-key vterm-mode-map (kbd "M-RET")   #'vterm-toggle-insert-cd)
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



;; 代码折叠
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'lua-mode-hook 'hs-minor-mode)
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'go-mode-hook 'hs-minor-mode)
(if (display-graphic-p)
    (progn
      ;; if graphic
      (global-set-key (kbd "C-=") 'hs-show-block)
      (global-set-key (kbd "C--") 'hs-hide-block)
      )
  ;; else (optional)
  (global-set-key (kbd "C-c =") 'hs-show-block)
  (global-set-key (kbd "C-c -") 'hs-hide-block)
  )


;; firestarter
(require-package 'firestarter)
(firestarter-mode)

;; helm
(require-package 'helm)
(require-package 'helm-ag)
(global-set-key (kbd "C-x c i") 'helm-semantic-or-imenu)


(require 'init-convert)

;; terminal copy-paste(copy from terminal-emacs to system (clip)board)
;; when paste into emacs use command+v instead of ctrl+y
(when (not (display-graphic-p))
  (progn
    (require-package 'clipetty)
    (global-clipetty-mode)
    (define-key input-decode-map "\e\eOA" [(meta up)])
    (define-key input-decode-map "\e\eOB" [(meta down)])

    ))


;; ivy高度，默认是10:输入占1行,内容占9行
(setq ivy-height 15)

;; rg搜索
(require-package 'deadgrep)

;; clang-format
(require-package 'clang-format)

;; 要先安装FiraCode-Regular-Symbol和FireCode字体
(if (display-graphic-p)
    (progn
      ;; if graphic
      (require-package 'fira-code-mode)
      (add-hook 'prog-mode-hook 'fira-code-mode)
      )
  ;; else (optional)
  )




(provide 'init-local)
;;; init-local.el ends here
