;;; jce-mode.el --- jce-mode derived from cc-mode to support JCE.

;; Author: spockwang
;; Keywords: Jce cc-mode

;;; Usage:

;; Put these lines in your .emacs startup file.
;;   (autoload 'jce-mode "jce-mode" "Major mode for editing Jce codes." t)
;;   (add-to-list 'auto-mode-alist '("\\.jce\\'" . jce-mode))

;;; Commentary:

;;; Code:

(require 'cc-mode)

(eval-when-compile
  (require 'cc-langs)
  (require 'cc-fonts))

(eval-and-compile
  (c-add-language 'jce-mode 'c++-mode))

(c-lang-defconst c-primitive-type-kwds
  jce '("void" "byte" "bool" "short" "int" "long" "float" "double" "string" "vector" "map"))

(c-lang-defconst c-type-modifier-kwds
  jce '("const" "require" "optional" "routekey"))

(c-lang-defconst c-class-decl-kwds
  jce '("struct" "interface"))

(c-lang-defconst c-type-prefix-kwds
  jce '("enum" "struct" "interface"))

(c-lang-defconst c-ref-list-kwds
  jce '("module"))

(c-lang-defconst c-brace-list-decl-kwds
  jce '("struct" "enum" "interface"))

(c-lang-defconst c-other-block-decl-kwds
  jce '("module"))

(c-lang-defconst c-modifier-kwds
  jce '("out"))

(c-lang-defconst c-<>-type-kwds
  jce '("vector" "map"))

(c-lang-defconst c-constants-kwds
  ;; Keywords for constants.
  jce '("true" "false"))

(c-lang-defconst c-cpp-include-directives
  jce '("include"))

(c-lang-defconst c-operators
  "List describing all operators, along with their precedence and
associativity.

See `cc-langs.el'."
  jce '((prefix "#")))


(defcustom jce-font-lock-extra-types '("key")
  "*List of extra types (aside from the type keywords) to recognize in Jce mode.
 Each list item should be a regexp matching a single identifier.")

(defconst jce-font-lock-keywords-1 (c-lang-const c-matchers-1 jce)
  "Minimal highlighting for JCE mode.")

(defconst jce-font-lock-keywords-2 (c-lang-const c-matchers-2 jce)
  "Fast normal highlighting for JCE mode.")

(defconst jce-font-lock-keywords-3 (c-lang-const c-matchers-3 jce)
  "Accurate normal highlighting for JCE mode.")

(defvar jce-font-lock-keywords jce-font-lock-keywords-3
  "Default expressions to highlight in JCE mode.")

(defvar jce-mode-syntax-table nil
  "Syntax table used in jce-mode buffers.")
(or jce-mode-syntax-table
    (setq jce-mode-syntax-table
          (funcall (c-lang-const c-make-mode-syntax-table jce))))

(defvar jce-mode-abbrev-table nil
  "Abbreviation table used in jce-mode buffers.")

(defvar jce-mode-map
  (let ((map (c-make-inherited-keymap)))
    ;; Add bindings which are only useful for JCE.
    map)
  "Keymap used in jce-mode buffers.")

(defun jce-mode ()
  "Major mode for editing C: (pronounced \"big nose\") code.
This is a simple example of a separate mode derived from CC Mode to
support a language with syntax similar to C/C++/ObjC/Java/IDL/Pike.

The hook `c-mode-common-hook' is run with no args at mode
initialization, then `jce-mode-hook'.

Key bindings:
\\{jce-mode-map}"
  (interactive)
  (kill-all-local-variables)
  (c-initialize-cc-mode t)
  (set-syntax-table jce-mode-syntax-table)
  (setq major-mode 'jce-mode
        mode-name "Jce"
        local-abbrev-table jce-mode-abbrev-table
        abbrev-mode t)
  (use-local-map c-mode-map)
  ;; `c-init-language-vars' is a macro that is expanded at compile
  ;; time to a large `setq' with all the language variables and their
  ;; customized values for our language.
  (c-init-language-vars jce-mode)
  ;; `c-common-init' initializes most of the components of a CC Mode
  ;; buffer, including setup of the mode menu, font-lock, etc.
  ;; There's also a lower level routine `c-basic-common-init' that
  ;; only makes the necessary initialization to get the syntactic
  ;; analysis and similar things working.
  (c-common-init 'jce-mode)
                                        ;  (easy-menu-add c:-menu)
  (c-run-mode-hooks 'c-mode-common-hook 'jce-mode-hook)
  (c-update-modeline))

(provide 'jce-mode)

;;; jce-mode.el ends here
