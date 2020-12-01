;;; init-xterm.el --- Integrate with terminals such as xterm -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'init-frame-hooks)

(global-set-key [mouse-4] (lambda () (interactive) (scroll-down 1)))
(global-set-key [mouse-5] (lambda () (interactive) (scroll-up 1)))

(autoload 'mwheel-install "mwheel")

(defun sanityinc/console-frame-setup ()
  (xterm-mouse-mode 1) ; Mouse in a terminal (Use shift to paste with middle button)
  (mwheel-install))

(add-hook 'after-make-console-frame-hooks 'sanityinc/console-frame-setup)

(defun xterm-title-update ()
  (unless (active-minibuffer-window)
    (send-string-to-terminal (concat "\033]1;" (buffer-name) "\007"))
    (if buffer-file-name
        (send-string-to-terminal (concat "\033]2;" (abbreviate-file-name (buffer-file-name)) "\007"))
      (send-string-to-terminal (concat "\033]2;" (buffer-name) "\007")))))

(defun xterm-title-update--register ()
  (add-hook 'after-init-hook 'xterm-title-update)
  (add-hook 'post-command-hook 'xterm-title-update))

(add-hook 'terminal-init-xterm-hook 'xterm-title-update--register)


(provide 'init-xterm)
;;; init-xterm.el ends here
