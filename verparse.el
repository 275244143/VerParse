;; verparse.el
;;
;; Author: Chuck McClish (charles.mcclish@microchip.com)
;; This file should be loaded in your .emacs file when you load a verilog file
;;
;; It issues the verparse script with the necessary arguments and returns the data
;; in the form of opening the returned file and moving the cursor to point or (in
;; the case of multi-line outputs) returns the multiple outputs to an interactive
;; buffer

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:

; Use the button package to setup clickable text
(require 'button)

; Setup symbol rings
(defvar verparse-signal-symbol-ring nil)
(defvar verparse-module-symbol-ring nil)
(defvar verparse-define-symbol-ring nil)

; Remove new line from string if it exists
(defun chomp(string)
  "Perform a perl-like chomp"
  (let ((s string)) (if (string-match "\\(.*\\)\n" s) (match-string 1 s) s)))

; Error detection
(defun verparse-error-detect (verparse-string-to-check)
  "Check the output string from the verparse script to see if there is an
   'ERROR:' prefix. If so, output the error string given from the verparse command."

  (setq verparse-string-to-check-list (split-string verparse-string-to-check "[ \n]+" t))

  (if (string= "ERROR:" (car verparse-string-to-check-list)) t))

; Run a signal definition search
(defun verparse-signal-search ()
  "Issue a signal search using the external verparse perl script and open the
   returned file in a new buffer and move point to the returned line number"
  (interactive)
  ; Create an interactive prompt
  (setq verparse-search-string (read-from-minibuffer "Goto signal definition: " (verparse-get-default-symbol) nil nil 'verparse-signal-symbol-ring))
  (cons verparse-search-string verparse-signal-symbol-ring)
  
  ; Issue the verparse command
  (setq verparse-output-string (shell-command-to-string (concat (executable-find "verparse") " -t signal -f "
                                                                buffer-file-name
                                                                " -s "
                                                                verparse-search-string)))

  ; Check to make sure there are no errors returned from the verparse script
  (if (verparse-error-detect verparse-output-string) (error (chomp verparse-output-string)))

  ; Check to see if returned string is empty
  (if (string= "\n" verparse-output-string)
      (message (concat "The signal '" verparse-search-string "' was not found."))

  ; Open up the returned file and move point to the returned line number
  (progn
    (setq verparse-output-list (split-string verparse-output-string "[ \n]+" t))
    (find-file (car verparse-output-list))
    (goto-line (string-to-number (nth 1 verparse-output-list)))))
  )

; Run a signal trace
(defun verparse-signal-trace ()
  "Issue a signal trace using the external verparse perl script and return the
   files and associated line numbers of where the given signal goes"
  (interactive)
  ; Create an interactive prompt
  (setq verparse-search-string (read-from-minibuffer "Trace signal: " (verparse-get-default-symbol) nil nil 'verparse-signal-symbol-ring))
  (cons verparse-search-string verparse-signal-symbol-ring)

  ; Issue the verparse command
  (setq verparse-output-string (shell-command-to-string (concat (executable-find "verparse") " -t signal -f "
                                                                buffer-file-name
                                                                " -s "
                                                                verparse-search-string)))

  ; Check to make sure there are no errors returned from the verparse script
  (if (verparse-error-detect verparse-output-string) (error (chomp verparse-output-string)))

  ; FIXME: not yet implemented
  (message "Sorry! Not yet implemented"))

; Run a module definition search
(defun verparse-module-search (&optional with-params)
  "Issue a module search using the external verparse perl script and open the
   returned file in a new buffer and move point to the returned line number"
  (interactive)
  ; Create an interactive prompt
  (if (not with-params)
  (setq verparse-search-string (read-from-minibuffer "Goto module definition: " (verparse-get-default-symbol) nil nil 'verparse-module-symbol-ring))
  (setq verparse-search-string (verparse-get-default-symbol)))
  (cons verparse-search-string verparse-module-symbol-ring)
  
  ; Issue the verparse command
  (setq verparse-output-string (shell-command-to-string (concat (executable-find "verparse") " -t module -s "
                                                                verparse-search-string)))

  ; Check to make sure there are no errors returned from the verparse script
  (if (verparse-error-detect verparse-output-string) (error (chomp verparse-output-string)))

  ; Check to see if returned string is empty
  (if (string= "\n" verparse-output-string)
      (message (concat "The module '" verparse-search-string "' was not found."))

  ; Open up the returned file and move point to the returned line number
    (progn
      (setq verparse-output-list (split-string verparse-output-string "[ \n]+" t))
      (find-file (car verparse-output-list))
      (if (= (point) (point-min))
      (goto-line (string-to-number (nth 1 verparse-output-list))))))
  )

; Run a define value search
(defun verparse-define-search ()
  "Issue a define search using the external verparse perl script and print
   the defined value in the minbuffer"
  (interactive)
  ; Create an interactive prompt
  (setq verparse-search-string (read-from-minibuffer "Find value of define: " (verparse-get-default-symbol) nil nil 'verparse-define-symbol-ring))
  (cons verparse-search-string verparse-define-symbol-ring)
  
  ; Issue the verparse command
  (setq verparse-output-string (shell-command-to-string (concat (executable-find "verparse") " -t define -s "
                                                                verparse-search-string)))

  ; Check to make sure there are no errors returned from the verparse script
  (if (verparse-error-detect verparse-output-string) (error (chomp verparse-output-string)))

  ; Check to see if returned string is empty
  (if (string= "\n" verparse-output-string)
      (message (concat "The define '" verparse-search-string "' was not found."))

  ; Return the searched define value
  (progn
    (setq verparse-output-list (split-string verparse-output-string "[ \n]+" t))
    (message (concat "Value of define '" verparse-search-string "': " (car verparse-output-list)))))
  )

; Go up one level of hierarchy
(defun verparse-go-up-level ()
  "Move the current buffer and point up one level of hierarchy"
  (interactive)

  ; Issue the verparse command
  (setq verparse-output-string (shell-command-to-string (concat (executable-find "verparse") " -t up -f " buffer-file-name)))

  ; Check to make sure there are no errors returned from the verparse script
  (if (verparse-error-detect verparse-output-string) (error (chomp verparse-output-string)))

  ; Check the string value
  (if (string= "\n" verparse-output-string)
      (message "This module is a top level cell or has multiple instantiations")

  ; Open up the returned file and move point to the returned line number
    (progn
      (setq verparse-output-list (split-string verparse-output-string "[ \n]+" t))
      (find-file (car verparse-output-list))
      (goto-line (string-to-number (nth 1 verparse-output-list)))))
  )

(defun verparse-rebuild-netlist ()
  "Send the 'refresh' command to the verparse_server to rebuild the netlist object
   for parsing. Run this command when signals/ports are added/removed."
  (interactive)

  ; Issue the refresh command
  (shell-command (concat (executable-find "verparse") " --refresh"))

  ; Check to make sure there are no errors returned from the verparse script
  (if (verparse-error-detect verparse-output-string) (error (chomp verparse-output-string)))

  ; Send message to minibuffer
  (message (concat "Refreshed verparse_server running in " (getenv "VERPARSE_SOCKET"))))

; Toggle view of a buffer with a clickable list that includes all instantiated modules
(defun verparse-toggle-module-list ()
  "Builds a clickable list that includes all of
   the project's instantiated modules."
  (interactive)

  (if (get-buffer-window "*verparse module list*")
      (progn
        (if verparse-module-list-split-window
        (delete-window module-list)
        (switch-to-buffer (other-buffer)))
        )
    (progn
      ; Issue the module_list command
      (setq verparse-output-string (shell-command-to-string (concat (executable-find "verparse") " -t module_list")))

      ; Check to make sure there are no errors returned from the verparse script
      (if (verparse-error-detect verparse-output-string) (error (chomp verparse-output-string)))

      ; Create the module list
      (setq verparse-list-string (replace-regexp-in-string "[ ][0-9]+[ \n]" "\n" verparse-output-string))
      
      ; Split the window horizontally and setup the buffer
      (if verparse-module-list-split-window
          (progn
            (setq module-list (selected-window))
            (setq w1 (split-window module-list verparse-module-list-window-width t))
            (window-edges w1)
            (window-edges module-list)))

      ; Check to see if the *verparse module list* buffer exists, if not create it
      (if (not (get-buffer "*verparse module list*"))
          (verparse-setup-module-list-buffer)
        (switch-to-buffer "*verparse module list*"))
      ))
)

(defun verparse-setup-module-list-buffer ()
  "Setup the *verparse module list* buffer. This is run each time the verparse_server refresh command is
sent. Also, if the buffer is killed."
  ; Create the buffer if it doesn't exist
  (interactive)
  (switch-to-buffer "*verparse module list*")

  ; Set the major mode for the buffer
  (verilog-mode)

  ; Delete any existing text, insert text, and move point to the beginning
  (delete-region (point-min) (point-max))
  (insert verparse-list-string)
  (beginning-of-buffer)
  (skip-chars-forward "^a-zA-Z0-9_")

  ; Setup the local keymap
  (setq verparse-map (make-sparse-keymap))
  (use-local-map verparse-map)
  (local-set-key (kbd "<down>") 'verparse-module-list-next)
  (local-set-key (kbd "<up>") 'verparse-module-list-prev)
  (local-set-key (kbd "<return>") 'verparse-module-search-no-prompt)
  (local-set-key "\C-c\C-m" 'verparse-module-search-no-prompt)
  (local-set-key "\C-c\C-w" 'verparse-toggle-module-list)

  ; Set the mouse-face to highlight on all modules
  (save-excursion
    (loop do (progn
               (skip-chars-forward "^a-zA-Z0-9_")
               (put-text-property (point)
                                  (save-excursion
                                    (skip-chars-forward "a-zA-Z0-9_")
                                    (point))
                                  'mouse-face 'highlight))
          until (eobp) do (forward-line)))

  ; Make the buffer read only
  (setq buffer-read-only t)

)

; Needed to create a verparse-module-search command with the optional parameter for the keymap
(defun verparse-module-search-no-prompt ()
  "Run the verparse-module-search command with no prompt in the minibuffer.
This is used for the bindkeys in the *verparse module list* window"
  (interactive)
  (verparse-module-search t))

; Go to the module declared on the next line down
(defun verparse-module-list-next ()
  "Binds to the <down> key in the *verparse module list* buffer. This moves point to the beginning of the module name on the next line."
  (interactive)
  (forward-line)
  (skip-chars-forward "^a-zA-Z0-9_")
)

; Move point to the module declared on the next line up
(defun verparse-module-list-prev ()
  "Binds to the <up> key in the *verparse module list* buffer. This moves point to the beginning of the module name on the previous line."
  (interactive)
  (forward-line -1)
  (skip-chars-forward "^a-zA-Z0-9_")
)


; Pull the verilog symbol from word under point
(defun verparse-get-default-symbol ()
  "Return symbol around current point as a string."
  (save-excursion
    (buffer-substring (progn
			;(skip-chars-backward " \t") ; This is from verilog-mode, so it may be needed in the future for proper searching
			(skip-chars-backward "a-zA-Z0-9_")
			(point))
		      (progn
			(skip-chars-forward "a-zA-Z0-9_")
			(point)))))

; Setup verparse options. This piggybacks off of the verilog-mode customization options
(defgroup verparse-options nil
  "Customize the verparse Verilog IDE Emacs plugin"
  :group 'verilog-mode)

; Choose whether or not to split the window to display the module list
(defcustom verparse-module-list-split-window nil
  "If not nil, split the current buffer horizontally to display the
*verparse module list* window. Otherwise, take the place of the current
buffer."
  :group 'verparse-options
  :type 'boolean)
(put 'verparse-module-list-split-window 'safe-local-variable 'verparse-booleanp)

(defun verparse-booleanp (value)
  "Return t if VALUE is boolean.
This implements GNU Emacs 22.1's `booleanp' function in earlier Emacs.
This function may be removed when Emacs 21 is no longer supported."
  (or (equal value t) (equal value nil)))

; Setup the width of the verparse-toggle-module-list window
(defcustom verparse-module-list-window-width 40
  "If the above option is false, split the window horizontally.
Set the default width of the *verparse module list* buffer."
  :group 'verparse-options
  :type 'integer)

;; Keybindings for commands, add these to the verilog-mode-map
;; used in Emacs verilog-mode
(define-key verilog-mode-map "\C-c\C-f" 'verparse-signal-search)
(define-key verilog-mode-map "\C-c\C-l" 'verparse-signal-trace)
(define-key verilog-mode-map "\C-c\C-m" 'verparse-module-search)
(define-key verilog-mode-map "\C-c\C-d" 'verparse-define-search)
(define-key verilog-mode-map "\C-c\C-j" 'verparse-go-up-level)
(define-key verilog-mode-map "\C-c\C-w" 'verparse-toggle-module-list)

;; Add commands to the Verilog-mode menu
(easy-menu-add-item verilog-menu
   '("Verparse")
      ["Goto signal definition" verparse-signal-search
       :help "Go to the definition of the given signal"])

(easy-menu-add-item verilog-menu
   '("Verparse")
      ["Trace net load" verparse-signal-trace
       :keys "C-c C-l"
       :help "Trace the loads of the given signal"])

(easy-menu-add-item verilog-menu
   '("Verparse")
      ["Goto module definition" verparse-module-search
       :keys "C-c C-m"
       :help "Go to the definition of the given module"])

(easy-menu-add-item verilog-menu
   '("Verparse")
      ["Return the define value" verparse-define-search
       :keys "C-c C-d"
       :help "Return the value of the given define"]
      )

(easy-menu-add-item verilog-menu
   '("Verparse")
      ["Go up one level of hierarchy" verparse-go-up-level
       :keys "C-c C-j"
       :help "Go up one level of hierarchy from the current buffer"]
      )

(easy-menu-add-item verilog-menu
   '("Verparse")
      ["Rebuild netlist object" verparse-rebuild-netlist
       :help "Run this command when signals/ports are added/removed"]
      )

(easy-menu-add-item verilog-menu
   '("Verparse")
      ["Toggle module list" verparse-toggle-module-list
       :help "Toggle a clickable module list"]
      )

;; Remove the verilog-mode version of the module goto
(easy-menu-remove-item verilog-menu
   '("Move") "Goto function/module")

(provide 'verparse)

;; Local Variables:
;; checkdoc-permit-comma-termination-flag:t
;; checkdoc-force-docstrings-flag:nil
;; End:

;;; verparse.el ends here
