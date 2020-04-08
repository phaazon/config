; Moving around.
(define-key evil-normal-state-map "c" 'left-char)
(define-key evil-normal-state-map "r" 'right-char)
(define-key evil-normal-state-map "s" 'previous-line)
(define-key evil-normal-state-map "t" 'next-line)
(define-key evil-normal-state-map "é" 'evil-forward-word-begin)

; Visual mode.
(define-key evil-visual-state-map "c" 'left-char)
(define-key evil-visual-state-map "r" 'right-char)
(define-key evil-visual-state-map "s" 'previous-line)
(define-key evil-visual-state-map "t" 'next-line)

; Window handling.
(define-key evil-normal-state-map "w" 'evil-window-map)
(define-key evil-window-map "c" 'evil-window-left)
(define-key evil-window-map "r" 'evil-window-right)
(define-key evil-window-map "s" 'evil-window-up)
(define-key evil-window-map "t" 'evil-window-down)
(define-key evil-window-map "o" 'evil-window-split)

; Replace.
(define-key evil-normal-state-map "h" 'evil-replace)
(define-key evil-normal-state-map "H" 'evil-replace-state)
(define-key evil-visual-state-map "h" 'evil-replace)
(define-key evil-visual-state-map "H" 'evil-replace-state)

; Redo
(define-key evil-normal-state-map "U" 'redo)

; Space map bindings.
(define-prefix-command 'space-map)
(define-key evil-normal-state-map (kbd "SPC") 'space-map)

; Magit
(define-key space-map "g" '("magit"))
(define-key space-map "gs" 'magit-status)

; Projectile
(define-key space-map "p" 'projectile-command-map)

; Neotree
(define-key space-map "n" 'neotree-toggle)

; Avy
(define-key space-map "a" '("avy"))
(define-key space-map "ac" 'avy-goto-char)
(define-key space-map "aC" 'avy-goto-char-2)
(define-key space-map "al" 'avy-goto-line)
(define-key space-map "aw" 'avy-goto-word-0)
(define-key space-map "aW" 'avy-goto-word-1)

; Expand
(define-key space-map "e" 'er/expand-region)

; Ivy
(define-key space-map "s" 'swiper)
(define-key space-map "b" 'ivy-switch-buffer)
(define-key space-map "f" 'counsel-fzf)
(global-set-key (kbd "C-c C-r") 'ivy-resume)

; Evil Nerd Commenter
(define-key space-map "/" 'evilnc-comment-or-uncomment-lines)
(define-key evil-visual-state-map "/" 'evilnc-comment-or-uncomment-lines)

; Neotree keybindings.
(evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "SPC") 'space-map)
(evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
(evil-define-key 'normal neotree-mode-map (kbd "r") 'neotree-refresh)
(evil-define-key 'normal neotree-mode-map (kbd "n") 'neotree-next-line)
(evil-define-key 'normal neotree-mode-map (kbd "p") 'neotree-previous-line)
(evil-define-key 'normal neotree-mode-map (kbd "A") 'neotree-stretch-toggle)
(evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle)
(evil-define-key 'normal neotree-mode-map (kbd "u") 'neotree-select-up-node)

; Markdown.
(define-key space-map "m" '("markdown"))
(define-key space-map "ml" 'markdown-insert-link)
(define-key space-map "mi" 'markdown-insert-image)
(define-key space-map "mti" 'markdown-toggle-inline-images)

; Org.
(define-key space-map "o" '("org"))
(define-key space-map "oa" 'org-agenda)
(define-key space-map "os" 'org-store-link)
(define-key space-map "oc" 'org-capture)
(define-key space-map "ol" 'org-insert-link)
(define-key space-map "ot" 'org-todo)
(evil-define-key 'normal org-mode-map (kbd "C-s") 'org-metaup)
(evil-define-key 'normal org-mode-map (kbd "C-t") 'org-metadown)
(evil-define-key 'normal org-mode-map (kbd "C-c") 'org-metaleft)
(evil-define-key 'normal org-mode-map (kbd "C-r") 'org-metaright)
(evil-define-key 'normal org-mode-map (kbd "C-S-s") 'org-shiftup)
(evil-define-key 'normal org-mode-map (kbd "C-S-t") 'org-shiftdown)
