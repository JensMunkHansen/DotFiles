(require 'package)
(setq package-archives
      '(("elpy" . "http://jorgenschaefer.github.io/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")))
(package-initialize)

; Consider using ccls (faster than clangd)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yaml-mode highlight-doxygen cmake-mode cmake-project auctex markdown-preview-eww lsp-mode clang-capf exec-path-from-shell yasnippet lsp-treemacs helm-lsp projectile hydra flycheck company avy which-key helm-xref dap-mode clang-format clang-format+ csharp-mode glsl-mode markdown-mode dracula-theme))
 '(ultex-run-text-mode-hook t)
 '(ultex-use-auctex t)
 '(ultex-use-color t)
 '(ultex-use-font-latex t)
 '(warning-suppress-types '((comp) (comp) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq company-idle-delay 1)
(load-theme 'dracula t)
(setq inhibit-startup-screen t)
(set-face-attribute 'default (selected-frame) :height 120)

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
(helm-mode)
(require 'helm-xref)
;(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
;(define-key global-map [remap switch-to-buffer] #'helm-mini)

(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 1.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(global-set-key (quote [M-down]) (quote scroll-up-line))
(global-set-key (quote [M-up]) (quote scroll-down-line)) 

(defun clang-format-save-hook-for-this-buffer ()
  "Create a buffer local save hook."
  (add-hook 'before-save-hook
            (lambda ()
              (when (locate-dominating-file "." ".clang-format")
                (clang-format-buffer))
              ;; Continue to save.
              nil)
            nil
            ;; Buffer local hook.
            t))

;; Run this for each mode you want to use the hook.
(add-hook 'c-mode-hook (lambda () (clang-format-save-hook-for-this-buffer)))
(add-hook 'c++-mode-hook (lambda () (clang-format-save-hook-for-this-buffer)))
(add-hook 'glsl-mode-hook (lambda () (clang-format-save-hook-for-this-buffer)))


(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
;  (setq lsp-diagnostics-provider :none)
  (require 'dap-cpptools)
;  (setq flycheck-disabled-checkers '(c/c++-cppcheck))
  (yas-global-mode))

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; TODO: Make read-only while debugging

;; Enabling only some features
(setq dap-auto-configure-features '(sessions locals controls tooltip))

;; The modes below are optional
(dap-ui-mode 1)
; ;; enables mouse hover support
(dap-tooltip-mode 1)
; ;; use tooltips for mouse hover
; ;; if it is not enabled `dap-mode' will use the minibuffer.
; (tooltip-mode 1)
; ;; displays floating panel with debug buttons
; ;; requies emacs 26+
; (dap-ui-controls-mode 1)


;; Markdown (like google)

;(defun markdown-html (buffer)
;  (princ (with-current-buffer buffer
;           (format "<!DOCTYPE html><html><script src=\"https://cdnjs.cloudflare.com/ajax/libs/he/1.1.1/he.js\"></script><link rel=\"stylesheet\" href=\"https://assets-cdn.github.com/assets/github-e6bb18b320358b77abe040d2eb46b547.css\"><link rel=\"stylesheet\" href=\"https://assets-cdn.github.com/assets/frameworks-95aff0b550d3fe338b645a4deebdcb1b.css\"><title>Impatient Markdown</title><div id=\"markdown-content\" style=\"display:none\">%s</div><div class=\"markdown-body\" style=\"max-width:968px;margin:0 auto;\"></div><script>fetch('https://api.github.com/markdown', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ \"text\": document.getElementById('markdown-content').innerHTML, \"mode\": \"gfm\", \"context\": \"knit-pk/homepage-nuxtjs\"}) }).then(response => response.text()).then(response => {document.querySelector('.markdown-body').innerHTML = he.decode(response)}).then(() => { fetch(\"https://gist.githubusercontent.com/FieryCod/b6938b29531b6ec72de25c76fa978b2c/raw/\").then(response => response.text()).then(eval)});</script></html>"
;                   (buffer-substring-no-properties (point-min) (point-max))))
;         (current-buffer)))
;
;(defun markdown-preview-like-god ()
;  (interactive)
;  (impatient-mode 1)
;  (setq imp-user-filter #'markdown-html)
;  (cl-incf imp-last-state)
;  (imp--notify-clients))

;;

;How to use:

;M-x httpd-start
;On .md buffer M-x markdown-preview-like-god
;Go to localhost:8080/imp


;(custom-set-variables
;  '(markdown-command "/usr/bin/pandoc -t pub --webtex"))

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist
             '("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\)\\'" . markdown-mode))

(autoload 'gfm-mode "markdown-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))


;(setq markdown-command "pandoc -c file:///home/jmh/.emacs.d/github-pandoc.css --from gfm -t html5 --mathjax --highlight-style pygments --standalone")
;(setq markdown-command "pandoc -c file:///home/jmh/.emacs.d/github-pandoc.css --from gfm -t html5 --webtex --highlight-style pygments --standalone")
(setq markdown-command "pandoc -t html5 --webtex --standalone")
(setq load-path (cons "/home/jmh/.emacs.d/site-lisp/ultratex/lisp" load-path))
(require 'light)
(require 'ultex-setup)

(require 'reftex)
(setq reftex-ref-macro-prompt nil)

(add-hook 'ultra-tex-mode-hook 'turn-on-reftex) 


(put 'scroll-left 'disabled nil)

(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++17")))
