;;; init-local.el ---  Settings for local -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; (set-frame-font "Menlo-12")
;; (set-frame-font "Menlo-12")
;; (set-fontset-font "fontset-default" 'han '("Monaco"))

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

;; /sshx:devnet:~/
(with-eval-after-load 'tramp
  (tramp-set-completion-function "ssh"
                                 '((tramp-parse-sconfig "/etc/ssh_config")
                                   (tramp-parse-sconfig "~/.ssh/config")))
  )

(require-package 'yasnippet)
(require-package 'yasnippet-snippets)
(setq yas/prompt-functions '(yas/dropdown-prompt))
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
    ))


(provide 'init-local)
;;; init-local.el ends here
