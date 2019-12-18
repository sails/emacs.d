;;; init-local.el ---  Settings for local -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


;; init jce
(require 'init-jce)

;; helm-gtags
(require-package 'helm-gtags)
(setenv "GTAGSFORCECPP" "1")
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)
(add-hook 'jce-mode-hook 'helm-gtags-mode)
(with-eval-after-load 'helm-gtags
  (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
  (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-find-tag-from-here)
  (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
  (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack))


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

;; copy buffer path
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

(provide 'init-local)
;;; init-local.el ends here
