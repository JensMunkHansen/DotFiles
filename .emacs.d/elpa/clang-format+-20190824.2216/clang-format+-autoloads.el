;;; clang-format+-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "clang-format+" "clang-format+.el" (0 0 0 0))
;;; Generated autoloads from clang-format+.el

(autoload 'clang-format+-mode "clang-format+" "\
Run clang-format on save.

If called interactively, enable Clang-Format+ mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "clang-format+" '("clang-format+-")))

;;;***

;;;### (autoloads nil nil ("clang-format+-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; clang-format+-autoloads.el ends here
