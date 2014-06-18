;; ergoemacs-theme-engine.el --- Engine for ergoemacs-themes

;; Copyright © 2014  Free Software Foundation, Inc.

;; Filename: ergoemacs-theme-engine.el
;; Description: 
;; Author: Matthew L. Fidler
;; Maintainer: 
;; Created: Thu Mar 20 10:41:30 2014 (-0500)
;; Version: 
;; Package-Requires: ()
;; Last-Updated: 
;;           By: 
;;     Update #: 0
;; URL: 
;; Doc URL: 
;; Keywords:
;; Compatibility: 
;; 
;; Features that might be required by this library:
;;
;;   None
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Commentary: 
;; 
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Change Log:
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Code:

(eval-when-compile 
  (require 'cl)
  (require 'ergoemacs-macros 
           (expand-file-name "ergoemacs-macros" 
                             (file-name-directory (or
                                                   load-file-name
                                                   (buffer-file-name)
                                                   default-directory)))))

(defgroup ergoemacs-themes nil
  "Default Ergoemacs Layout"
  :group 'ergoemacs-mode)

(defcustom ergoemacs-theme-options
  '()
  "List of theme options"
  :type '(repeat
          (list
           (sexp :tag "Theme Component")
           (choice
            (const :tag "Force Off" off)
            (const :tag "Force On" on)
            (const :tag "Let theme decide" nil))))
  :group 'ergoemacs-themes)

(defcustom ergoemacs-theme-version
  '()
  "Each themes set version"
  :type '(repeat
          (string :tag "Theme Component")
          (choice
           (const :tag "Latest Version" nil)
           (string :tag "Version")))
  :group 'ergoemacs-theme)

(defcustom ergoemacs-function-short-names
  '((backward-char  "← char")
    (forward-char "→ char")
    (previous-line "↑ line")
    (next-line "↓ line")
    (left-word  "← word")
    (right-word "→ word")
    (backward-paragraph "↑ ¶")
    (forward-paragraph "↓ ¶")
    (backward-word "← word")
    (forward-word "→ word")
    (ergoemacs-backward-block "← ¶")
    (ergoemacs-forward-block  "→ ¶")
    (ergoemacs-beginning-of-line-or-what "← line/*")
    (ergoemacs-end-of-line-or-what "→ line/*")
    (scroll-down "↑ page")
    (scroll-down-command "↑ page")
    (scroll-up-command "↓ page")
    (scroll-up "↓ page")
    (ergoemacs-beginning-or-end-of-buffer "↑ Top*")
    (ergoemacs-end-or-beginning-of-buffer "↓ Bottom*")
    (ergoemacs-backward-open-bracket "← bracket")
    (ergoemacs-forward-close-bracket "→ bracket")
    (isearch-forward "→ isearch")
    (isearch-backward "← isearch")
    (recenter-top-bottom "recenter")
    (delete-backward-char "⌫ char")
    (delete-char "⌦ char")
    (backward-kill-word "⌫ word")
    (kill-word "⌦ word")
    (ergoemacs-cut-line-or-region "✂ region")
    (ergoemacs-copy-line-or-region "copy")
    (ergoemacs-paste "paste")
    (ergoemacs-paste-cycle "paste ↑")
    (ergoemacs-copy-all "copy all")
    (ergoemacs-cut-all "✂ all")
    (undo-tree-redo "↷ redo")
    (redo "↷ redo")
    (undo "↶ undo")
    (kill-line "⌦ line")
    (ergoemacs-kill-line-backward "⌫ line")
    (mark-paragraph "Mark Paragraph")
    (ergoemacs-shrink-whitespaces "⌧ white")
    (comment-dwim "cmt dwim")
    (ergoemacs-toggle-camel-case "tog. camel")
    (ergoemacs-toggle-letter-case "tog. case")
    (ergoemacs-call-keyword-completion "↯ compl")
    (flyspell-auto-correct-word "flyspell")
    (ergoemacs-compact-uncompact-block "fill/unfill ¶")
    (set-mark-command "Set Mark")
    (execute-extended-command "M-x")
    (shell-command "shell cmd")
    (ergoemacs-move-cursor-next-pane "next pane")
    (ergoemacs-move-cursor-previous-pane "prev pane")
    (ergoemacs-switch-to-previous-frame "prev frame")
    (ergoemacs-switch-to-next-frame "next frame")
    (query-replace "rep")
    (vr/query-replace "rep reg")
    (query-replace-regexp "rep reg")
    (delete-other-windows "x other pane")
    (delete-window "x pane")
    (split-window-vertically "split |")
    (split-window-right "split |")
    (split-window-horizontally "split —")
    (split-window-below "split —")
    (er/expand-region "←region→")
    (ergoemacs-extend-selection "←region→")
    (er/expand-region "←region→")
    (ergoemacs-extend-selection "←region→")
    (er/mark-outside-quotes "←quote→")
    (ergoemacs-select-text-in-quote "←quote→")
    (ergoemacs-select-current-block "Sel. Block")
    (ergoemacs-select-current-line "Sel. Line")
    (ace-jump-mode "Ace Jump")    (delete-window "x pane")
    (delete-other-windows "x other pane")
    (split-window-vertically "split —")
    (query-replace "rep")
    (ergoemacs-cut-all "✂ all")
    (ergoemacs-copy-all "copy all")
    (execute-extended-command "M-x")
    (execute-extended-command "M-x")
    (indent-region "indent-region")  ;; Already in CUA
    (set-mark-command "Set Mark")
    (mark-whole-buffer "Sel All"))
  "Ergoemacs short command names"
  :group 'ergoemacs-themes
  :type '(repeat :tag "Command abbreviation"
                 (list (sexp :tag "Command")
                       (string :tag "Short Name"))))
(require 'eieio)

(defclass ergoemacs-named ()
  ()
  "Object with a name.
Name access by slot :object-name
Symbol access by slot :object-symbol"
  :abstract t)

(defmethod slot-missing ((obj ergoemacs-named)
                         slot-name operation &optional new-value)
  "Called when a non-existent slot is accessed.
For variable `ergoemacs-named', provide an imaginary `object-name' slot, which is a string.
Also provide imaginary `object-symbol' slot, which is a symbol.

Argument OBJ is the named object.
Argument SLOT-NAME is the slot that was attempted to be accessed.
OPERATION is the type of access, such as `oref' or `oset'.
NEW-VALUE is the value that was being set into SLOT if OPERATION were
a set type."
  (cond
   ((or (eq slot-name 'object-name)
        (eq slot-name :object-name))
    (cond ((eq operation 'oset)
           (if (not (stringp new-value))
               (signal 'invalid-slot-type
                       (list obj slot-name 'string new-value)))
           (object-set-name-string obj new-value))
          (t (save-match-data (replace-regexp-in-string "::.*$" "" (object-name-string obj))))))
   ((or (eq slot-name 'object-symbol)
        (eq slot-name :object-symbol))
    (cond ((eq operation 'oset)
           (if (not (symbolp new-value))
               (signal 'invalid-slot-type
                       (list obj slot-name 'symbol new-value)))
           (object-set-name-string obj (symbol-name new-value)))
          (t (intern (save-match-data (replace-regexp-in-string "::.*$" "" (object-name-string obj)))))))
   (t
    (call-next-method))))

(defclass ergoemacs-fixed-map (ergoemacs-named)
  ;; object-name is the object name.
  ((name :initarg :name
         :type symbol)
   (global-map-p :initarg :global-map-p
                 :initform nil
                 :type boolean)
   (read-map :initarg :read-map
             :initform (make-sparse-keymap)
             :type keymap)
   (read-list :initarg :read-list
              :initform ()
              :type list)
   (shortcut-map :initarg :shortcut-map
                 :initform (make-sparse-keymap)
                 :type keymap)
   (no-shortcut-map :initarg :no-shortcut-map
                    :initform (make-sparse-keymap)
                    :type keymap)
   (map :initarg :map
        :initform (make-sparse-keymap)
        :type keymap)
   (unbind-map :initarg :unbind-map
               :initform (make-sparse-keymap)
               :type keymap)
   (shortcut-list :initarg :shortcut-list
                  :initform '()
                  :type list)
   (shortcut-movement :initarg :shortcut-movement
                      :initform '()
                      :type list)
   (shortcut-shifted-movement :initarg :shortcut-shifted-movement
                              :initform '()
                              :type list)
   (rm-keys :initarg :rm-keys
            :initform '()
            :type list)
   (cmd-list :initarg :cmd-list
             :initform '()
             :type list)
   (modify-map :initarg :modify-map
               :initform nil
               :type boolean)
   (hook :initarg :hook
         :type symbol)
   (full-map :initarg :full-map
             :initform nil
             :type boolean)
   (always :initarg :always
           :initform nil
           :type boolean)
   (deferred-keys :initarg :deferred-keys
     :initform '()
     :type list))
  "`ergoemacs-mode' fixed-map class")

(defgeneric ergoemacs-fixed-layout-list ()
  "Retrieves the fixed layout list for `ergoemacs-mode'.")

(defmethod ergoemacs-fixed-layout-list ((obj ergoemacs-fixed-map))
  (with-slots (cmd-list) obj
    cmd-list))


(defgeneric ergoemacs-copy-obj (obj)
  "Copies OBJECTS so they are not shared beteween instances.")

(declare-function ergoemacs-shortcut-function-binding "ergoemacs-shortcuts.el")
(declare-function ergoemacs-is-movement-command-p "ergoemacs-mode.el")
(declare-function ergoemacs-setup-translation "ergoemacs-translate.el")
(declare-function ergoemacs-kbd "ergoemacs-translate.el")
(defun ergoemacs-copy-list (list)
  "Return a copy of LIST, which may be a dotted list.
The elements of LIST are not copied, just the list structure itself."
  ;; Taken from cl, to remove warnings
  (if (consp list)
      (let ((res nil))
        (while (consp list) (push (pop list) res))
        (prog1 (nreverse res) (setcdr res list)))
    (car list)))

(defmethod ergoemacs-copy-obj ((obj ergoemacs-fixed-map))
  (with-slots (read-map
               shortcut-map
               no-shortcut-map
               map
               unbind-map
               deferred-keys
               cmd-list
               rm-keys
               shortcut-shifted-movement
               shortcut-movement
               shortcut-list) obj
    (oset obj read-map (copy-keymap read-map))
    (oset obj shortcut-map (copy-keymap shortcut-map))
    (oset obj no-shortcut-map (copy-keymap no-shortcut-map))
    (oset obj map (copy-keymap map))
    (oset obj unbind-map (copy-keymap unbind-map))
    (oset obj deferred-keys (ergoemacs-copy-list deferred-keys))
    (oset obj cmd-list (ergoemacs-copy-list cmd-list))
    (oset obj rm-keys (ergoemacs-copy-list rm-keys))
    (oset obj shortcut-shifted-movement (ergoemacs-copy-list shortcut-shifted-movement))
    (oset obj shortcut-movement (ergoemacs-copy-list shortcut-movement))
    (oset obj shortcut-list (ergoemacs-copy-list shortcut-list))))

(declare-function ergoemacs-debug "ergoemacs-debug.el")
(declare-function ergoemacs-debug-keymap "ergoemacs-debug.el")
(defmethod ergoemacs-debug-obj ((obj ergoemacs-fixed-map) &optional stars)
  (let ((stars (or stars "**")))
    (with-slots (object-name
                 map
                 shortcut-map
                 no-shortcut-map
                 read-map
                 unbind-map
                 always
                 modify-map
                 deferred-keys
                 full-map) obj
      (ergoemacs-debug "%s %s" (or (and (string= stars "") "Keymap:")
                                   stars) object-name)
      (ergoemacs-debug "Deferred Keys: %s" deferred-keys)
      (cond
       ((ergoemacs-keymap-empty-p read-map)
        (ergoemacs-debug "Modify Keymap: %s" modify-map)
        (ergoemacs-debug "Always Modify Keymap: %s" always)
        (ergoemacs-debug "Add all ergoemacs-mode keys (override): %s" full-map)
        (ergoemacs-debug "%s\n" map)
        (ergoemacs-debug-keymap map))
       (t
        (ergoemacs-debug "%s* Read\n" stars)
        (ergoemacs-debug "%s\n" read-map)
        (ergoemacs-debug-keymap read-map)
        (ergoemacs-debug "%s* Fixed\n" stars)
        (ergoemacs-debug "%s\n" map)
        (ergoemacs-debug-keymap map)
        (ergoemacs-debug "%s* Shortcut\n" stars)
        (ergoemacs-debug "%s\n" shortcut-map)
        (ergoemacs-debug-keymap shortcut-map)
        (ergoemacs-debug "%s* Shortcut Free\n" stars)
        (ergoemacs-debug "%s\n" no-shortcut-map)
        (ergoemacs-debug-keymap no-shortcut-map)
        (ergoemacs-debug "%s* Unbind\n" stars)
        (ergoemacs-debug "%s\n" unbind-map)
        (ergoemacs-debug-keymap unbind-map))))))

(defmethod ergoemacs-define-map--shortcut-list ((obj ergoemacs-fixed-map) key-vect def)
  "Define KEY-VECT with DEF in slot shortcut-list for OBJ."
  (with-slots (shortcut-list) obj
    (let ((tmp (list key-vect (list def 'global))))
      (setq shortcut-list
            (mapcar
             (lambda(elt)
               (if (equal (nth 0 elt) key-vect)
                   (prog1 tmp
                     (setq tmp nil))
                 elt))
             shortcut-list))
      (when tmp
        (push tmp shortcut-list))
      (oset obj shortcut-list shortcut-list))))

(defmethod ergoemacs-define-map--deferred-list ((obj ergoemacs-fixed-map) key deferred-list)
  "Add/Replace DEFERRED-LIST for KEY in OBJ."
  (with-slots (deferred-keys) obj
    (let ((deferred-list deferred-list))
      (setq deferred-keys
            (mapcar
             (lambda(x)
               (if (equal (nth 0 x) key)
                   (prog1 (list key deferred-list)
                     (setq deferred-list nil))
                 x))
             deferred-keys))
      (when deferred-list
        (push (list key (reverse deferred-list)) deferred-keys))
      (oset obj deferred-keys deferred-keys))))

(defmethod ergoemacs-define-map--cmd-list ((obj ergoemacs-fixed-map) key-desc def &optional desc)
  "Add KEY-DESC for DEF to OBJ cmd-list slot.
Optionally use DESC when another description isn't found in `ergoemacs-function-short-names'."
  (with-slots (cmd-list) obj
    (let ((tmp (assoc def ergoemacs-function-short-names)))
      (if tmp
          (setq tmp (nth 1 tmp))
        (cond
         ((symbolp def)
          (setq tmp (symbol-name def)))
         ((stringp def)
          (setq tmp def))
         (t (setq tmp (or desc "")))))
      (setq tmp (list key-desc def tmp))
      (setq cmd-list
            (mapcar
             (lambda(x)
               (if (equal (nth 0 x) key-desc)
                   (prog1 tmp
                     (setq tmp nil))
                 x))
             cmd-list))
      (when tmp
        (push tmp cmd-list))
      (oset obj cmd-list cmd-list))))

(defvar ergoemacs-ignored-prefixes)
(defmethod ergoemacs-define-map--read-map ((obj ergoemacs-fixed-map) key)
  "Defines KEY in the OBJ read-key slot if it is a vector over 2.
Key sequences starting with `ergoemacs-ignored-prefixes' are not added."
  (with-slots (read-map
               read-list) obj
    (when (< 1 (length key))
      (let* ((new-key (substring key 0 1))
             (kd (key-description new-key)))
        (unless (member kd ergoemacs-ignored-prefixes)
          (push new-key read-list)
          (oset obj read-list read-list)
          (define-key read-map new-key #'ergoemacs-read-key-default)
          (oset obj read-map read-map))))))

(defgeneric ergoemacs-define-map (obj key def &optional no-unbind)
  "Method to define a key in an `ergoemacs-mode' key class.

Arguments are OBJ KEY DEF NO-UNBIND

OBJ is the object where the key is defined.

Define key sequence KEY as DEF.

NO-UNBIND is an optional component that forces keys to be removed
from final keymaps instead of being added to a ergoemacs-unbound
keymap.

KEY is a string or a vector of symbols and characters, representing a
sequence of keystrokes and events.  Non-ASCII characters with codes
above 127 (such as ISO Latin-1) can be represented by vectors.
Two types of vector have special meanings:
 [remap COMMAND] remaps any key binding for COMMAND.
 [t] creates a default definition, which applies to any event with no
    other definition in KEYMAP.

DEF is anything that can be a key's definition:
 nil (means key is undefined in this keymap),
 a command that is globally bound
   (If this occurs, `ergoemacs-mode' and this is for the general
    `ergoemacs-mode' map, will remap to mode-specific definitions)
 a command (a Lisp function suitable for interactive calling),
 a string (treated as a keyboard macro),
 a keymap (to define a prefix key),
 a list of key/translation 
   (kbd-code translation) for example '(\"C-x\" unchorded)
 a list of commands.  The first bound command is used. This will
    be reassessed when loading other libraries.
 a symbol (when the key is looked up, the symbol will stand for its
    function definition, which should at that time be one of the above,
    or another symbol whose function definition is used, etc.),
 a cons (STRING . DEFN), meaning that DEFN is the definition
    (DEFN should be a valid definition in its own right),
 or a cons (MAP . CHAR), meaning use definition of CHAR in keymap MAP,
 or an extended menu item definition.
")

(defmethod ergoemacs-define-map ((obj ergoemacs-fixed-map) key def &optional
                                 no-unbind)
  (with-slots (shortcut-map
               no-shortcut-map
               map
               unbind-map
               rm-keys
               shortcut-movement
               global-map-p
               shortcut-shifted-movement
               read-list
               read-map) obj
    (let* ((key-desc (key-description key))
           (key-vect (read-kbd-macro key-desc t))
           swapped
           tmp)
      ;; Swap out apps for menu on the appropriate system.
      (dotimes (number (length key-vect))
        (cond
         ((and (eq system-type 'windows-nt)
               (eq (elt key-vect number) 'menu))
          (setq swapped t)
          (aset key-vect number 'apps))
         ((and (not (eq system-type 'windows-nt))
               (eq (elt key-vect number) 'apps))
          (setq swapped t)
          (aset key-vect number 'menu))))
      (when swapped
        (setq key-desc (key-description key-vect)))
      (ergoemacs-theme-component--ignore-globally-defined-key key-vect)
      (ergoemacs-define-map--read-map obj key-vect)
      (cond
       ((and global-map-p (eq def nil) (not no-unbind))
        ;; Unbound keymap
        (define-key unbind-map key-vect 'ergoemacs-undefined)
        (oset obj unbind-map unbind-map))
       ((and global-map-p (eq def nil) no-unbind)
        ;; Remove from all keymaps
        (push key-vect rm-keys)
        (oset obj rm-keys rm-keys))
       ((and global-map-p (commandp def t)
             (not (string-match "\\(mouse\\|wheel\\)" (key-description key)))
             (ergoemacs-shortcut-function-binding def))
        ;; This key could have some smart interpretations.
        (ergoemacs-define-map--shortcut-list obj key-vect def)
        (if (ergoemacs-is-movement-command-p def)
            (if (let (case-fold-search)
                  (string-match "\\(S-\\|[A-Z]$\\)" key-desc))
                (progn
                  (pushnew key-vect shortcut-shifted-movement :test 'equal)
                  (oset obj shortcut-shifted-movement shortcut-shifted-movement)
                  (define-key shortcut-map key 'ergoemacs-shortcut-movement-no-shift-select))
              (pushnew key-vect shortcut-movement :test 'equal)
              (oset obj shortcut-movement shortcut-movement)
              (define-key shortcut-map key 'ergoemacs-shortcut-movement))
          (define-key shortcut-map key 'ergoemacs-shortcut))
        (oset obj no-shortcut-map no-shortcut-map)
        (ergoemacs-define-map--cmd-list obj key-desc def)
        (define-key no-shortcut-map key def)
        (oset obj shortcut-map shortcut-map))
       ((or (commandp def t) (keymapp def) (stringp def))
        ;; Normal command
        (if (memq def '(ergoemacs-ctl-c ergoemacs-ctl-x))
            (progn
              (push (list key-vect def) read-list)
              (define-key read-map key-vect def)
              (oset obj read-map read-map)
              (oset obj read-list read-list))
          (define-key map key-vect def)
          (oset obj map map))
        (ergoemacs-define-map--cmd-list obj key-desc def))
       ((ignore-errors (keymapp (symbol-value def)))
        ;; Keymap variable.
        (ergoemacs-define-map--cmd-list obj key-desc def)
        (define-key map key-vect (symbol-value def))
        (oset obj map map))
       ((and (listp def) (or (stringp (nth 0 def))))
        ;; `ergoemacs-read-key' shortcut
        (ergoemacs-define-map--shortcut-list obj key-vect def)
        (ergoemacs-define-map--cmd-list obj key-desc def (nth 0 def))
        (define-key shortcut-map key 'ergoemacs-shortcut)
        (oset obj shortcut-map shortcut-map))
       ((listp def)
        (catch 'found-command
          (dolist (command def)
            (if (not (commandp command t))
                (push command tmp)
              (define-key map key-vect command)
              (ergoemacs-define-map--cmd-list obj key-desc def)
              (oset obj map map)
              (throw 'found-command t))))
        (when tmp
          ;; Add to deferred key list
          (ergoemacs-define-map--deferred-list obj key-vect tmp)))
       ((symbolp def)
        ;; Unbound symbol, add to deferred key list
        (ergoemacs-define-map--deferred-list obj key-vect (list def)))))))


(defclass ergoemacs-variable-map (ergoemacs-named)
  ((global-map-p :initarg :global-map-p
                 :initform nil
                 :type boolean)
   (layout :initarg :layout
           :initform "us"
           :type string)
   (translation-regexp :initarg :translation-regexp
                       :initform ""
                       :type string)
   (translation-assoc :initarg :translation-assoc
                      :initform ()
                      :type list)
   (just-first :initarg :just-first
               :initform ""
               :type string)
   (cmd-list :initarg :cmd-list
             :initform nil
             :type list)
   (keymap-hash :initarg :keymap-hash
                :initform (make-hash-table)
                :type hash-table)
   (modify-map :initarg :modify-map
               :initform nil
               :type boolean)
   (hook :initarg :hook
         :type symbol)
   (full-map :initarg :full-map
             :initform nil
             :type boolean)
   (always :initarg :always
           :initform nil
           :type boolean))
  "`ergoemacs-mode' variable-map class")

(defgeneric ergoemacs-variable-layout-list ()
  "Retrieves the variable layout list for `ergoemacs-mode'.")

(defmethod ergoemacs-variable-layout-list ((obj ergoemacs-variable-map))
  (with-slots (cmd-list) obj
    cmd-list))

(defmethod ergoemacs-define-map--cmd-list ((obj ergoemacs-variable-map) key-desc def no-unbind &optional desc)
  "Add KEY-DESC for DEF to OBJ cmd-list slot.
Optionally use DESC when another description isn't found in `ergoemacs-function-short-names'."
  (with-slots (cmd-list
               layout
               translation-regexp
               translation-assoc
               just-first) obj
    (let* ((final-desc (assoc def ergoemacs-function-short-names))
           (only-first (if (string= just-first "") nil
                         (ignore-errors (string-match-p just-first key-desc))))
           (us-key
            (or (and (string= layout "us") key-desc) 
                (let ((ergoemacs-translation-from layout)
                      (ergoemacs-translation-to "us")
                      (ergoemacs-needs-translation t)
                      (ergoemacs-translation-regexp translation-regexp)
                      (ergoemacs-translation-assoc translation-assoc))
                  (when (string= "" translation-regexp)
                    (setq ergoemacs-translation-from nil
                          ergoemacs-translation-to nil
                          ergoemacs-translation-regexp nil
                          ergoemacs-translation-assoc nil)
                    (ergoemacs-setup-translation "us" layout)
                    (oset obj translation-regexp ergoemacs-translation-regexp)
                    (oset obj translation-assoc ergoemacs-translation-assoc))
                  (ergoemacs-kbd key-desc t only-first)))))
      (if final-desc
          (setq final-desc (nth 1 final-desc))
        (cond
         ((symbolp def)
          (setq final-desc (symbol-name def)))
         ((stringp def)
          (setq final-desc def))
         (t (setq final-desc (or desc "")))))
      (setq final-desc (list us-key def final-desc only-first no-unbind))
      (setq cmd-list
            (mapcar
             (lambda(x)
               (if (equal (nth 0 x) key-desc)
                   (prog1 final-desc
                     (setq final-desc nil))
                 x))
             cmd-list))
      (when final-desc
        (push final-desc cmd-list))
      (oset obj cmd-list cmd-list))))

(defmethod ergoemacs-define-map ((obj ergoemacs-variable-map) key def &optional no-unbind)
  (let* ((key-desc (key-description key))
         (key-vect (read-kbd-macro key-desc t)))
    (ergoemacs-define-map--cmd-list obj key-desc def no-unbind)
    ;; Defining key resets the fixed-maps...
    (oset obj keymap-hash (make-hash-table))))

(defmethod ergoemacs-copy-obj ((obj ergoemacs-variable-map))
  ;; Reset fixed-map calculations.
  (with-slots (cmd-list) obj
    (oset obj keymap-hash (make-hash-table))
    ;; Translation should remain the same
    ;; (oset obj translation-assoc (ergoemacs-copy-list translation-assoc))
    (oset obj cmd-list (ergoemacs-copy-list cmd-list))))

(defvar ergoemacs-keyboard-layout)
(defmethod ergoemacs-get-fixed-map ((obj ergoemacs-variable-map) &optional layout)
  (with-slots (keymap-list
               cmd-list
               modify-map
               full-map
               always
               global-map-p
               keymap-hash) obj
    (let* ((lay (or layout ergoemacs-keyboard-layout))
           (ilay (intern lay))
           (ret (gethash ilay keymap-hash))
           ergoemacs-translation-from
           ergoemacs-translation-to
           ergoemacs-needs-translation
           ergoemacs-translation-regexp
           ergoemacs-translation-assoc)
      (unless ret
        (setq ret (ergoemacs-fixed-map
                   lay
                   :global-map-p global-map-p
                   :modify-map modify-map
                   :full-map full-map
                   :always always))
        (ergoemacs-setup-translation lay "us")
        (dolist (cmd (reverse cmd-list))
          (ergoemacs-define-map ret (ergoemacs-kbd (nth 0 cmd) nil (nth 3 cmd))
                                (nth 1 cmd) (nth 4 cmd)))
        (puthash ilay ret keymap-hash)
        (oset obj keymap-hash keymap-hash))
      ret)))

(defclass ergoemacs-composite-map (ergoemacs-named)
  ((global-map-p :initarg :global-map-p
                 :initform nil
                 :type boolean)
   (variable-reg :initarg :variable-reg
                 :initform (concat "\\(?:^\\|<\\)" (regexp-opt '("M-" "<apps>" "<menu>")))
                 :type string)
   (just-first :initarg :just-first
               :initform ""
               :type string)
   (layout :initarg :layout
           :initform "us"
           :type string)
   (modify-map :initarg :modify-map
               :initform nil
               :type boolean)
   (hook :initarg :hook
         :type symbol)
   (full-map :initarg :full-map
             :initform nil
             :type boolean)
   (always :initarg :always
           :initform nil
           :type boolean)
   (fixed :initarg :fixed
          :type ergoemacs-fixed-map)
   (keymap-hash :initarg :keymap-hash
                :initform (make-hash-table)
                :type hash-table)
   (variable :initarg :fixed
             :type ergoemacs-variable-map))
  "`ergoemacs-mode' composite-map class")

(defmethod ergoemacs-variable-layout-list ((obj ergoemacs-composite-map))
  (with-slots (variable) obj
    (ergoemacs-variable-layout-list variable)))

(defmethod ergoemacs-fixed-layout-list ((obj ergoemacs-composite-map))
  (with-slots (fixed) obj
    (ergoemacs-fixed-layout-list fixed)))

(defmethod ergoemacs-composite-map--ini ((obj ergoemacs-composite-map))
  (unless (slot-boundp obj 'fixed)
    (let ((fixed (ergoemacs-fixed-map (object-name-string obj) 
                                      :global-map-p (oref obj global-map-p)
                                      :modify-map (oref obj modify-map)
                                      :full-map (oref obj full-map)
                                      :always (oref obj always))))
      (when (slot-boundp obj 'hook)
        (oset fixed hook (oref obj hook)))
      (oset obj fixed fixed)))
  (unless (slot-boundp obj 'variable)
    (let ((var (ergoemacs-variable-map
                (object-name-string obj) 
                :global-map-p (oref obj global-map-p)
                :just-first (oref obj just-first)
                :layout (oref obj layout)
                :modify-map (oref obj modify-map)
                :full-map (oref obj full-map)
                :always (oref obj always))))
      (when (slot-boundp obj 'hook)
        (oset var hook (oref obj hook)))
      (oset obj variable var))))

(defmethod ergoemacs-define-map ((obj ergoemacs-composite-map) key def &optional no-unbind)
  (ergoemacs-composite-map--ini obj)
  (with-slots (fixed
               variable
               variable-reg) obj
    (let* ((key-desc (key-description key))
           (key-vect (read-kbd-macro key-desc t)))
      (if (and (not (string= variable-reg ""))
               (ignore-errors (string-match-p variable-reg key-desc)))
          (ergoemacs-define-map variable key def no-unbind)
        (ergoemacs-define-map fixed key def no-unbind))))
  (oset obj keymap-hash (make-hash-table)))

(defmethod ergoemacs-copy-obj ((obj ergoemacs-composite-map))
  (with-slots (fixed variable keymap-hash) obj
    ;; Copy/Reset fixed/variable keymaps.
    (setq fixed (clone fixed (oref fixed object-name))
          variable (clone variable (oref variable object-name)))
    (ergoemacs-copy-obj fixed)
    (ergoemacs-copy-obj variable)
    (setq keymap-hash (make-hash-table))
    (oset obj fixed fixed)
    (oset obj variable variable)
    (oset obj keymap-hash keymap-hash)))

(defun ergoemacs-get-fixed-map--combine-maps (keymap1 keymap2 &optional parent)
  "Combines KEYMAP1 and KEYMAP2.
When parent is a keymap, make a composed keymap of KEYMAP1 and KEYMAP2 with PARENT keymap
When parent is non-nil, make a composed keymap
When parent is nil collapse the keymaps into a single keymap.
Assumes maps are orthogonal."
  (let ((map1 keymap1) (map2 keymap2))
    (cond
     ((equal map1 '(keymap))
      (if (keymapp parent)
          (make-composed-keymap map2 parent)
        map2))
     ((equal map2 '(keymap))
      (if (keymapp parent)
          (make-composed-keymap map1 parent)
        map1))
     ((keymapp parent)
      (make-composed-keymap (list map1 map2) parent))
     (parent
      (make-composed-keymap (list map1 map2)))
     (t
      (pop map1)
      (pop map2)
      (setq map1 (append map1 map2))
      (push 'keymap map1)
      (copy-keymap map1)))))

(defmethod ergoemacs-get-fixed-map ((obj ergoemacs-composite-map) &optional layout)
  (ergoemacs-composite-map--ini obj)
  (with-slots (variable object-name fixed modify-map full-map always
                        global-map-p keymap-hash) obj
    (let* ((lay (or layout ergoemacs-keyboard-layout))
           read
           (ilay (intern lay))
           (ret (gethash ilay keymap-hash))
           (fix fixed) map1 map2 var)
      (unless ret ;; Calculate
        (setq var (ergoemacs-get-fixed-map variable lay))
        (setq read (copy-keymap (oref fix read-map)))
        ;; This way the read-map is not a composite map.
        (dolist (key (oref var read-list)) 
          (cond
           ((vectorp key)
            (define-key read key #'ergoemacs-read-key-default))
           ((and (listp key) (vectorp (nth 0 key)))
            (define-key read (nth 0 key) (nth 1 key)))))
        (setq ret (ergoemacs-fixed-map
                   lay
                   :global-map-p global-map-p
                   :modify-map modify-map
                   :full-map full-map
                   :always always
                   :read-map read
                   :read-list (append (oref var read-list) (oref fix read-list))
                   :shortcut-map (ergoemacs-get-fixed-map--combine-maps (oref var shortcut-map) (oref fix shortcut-map))
                   :no-shortcut-map (ergoemacs-get-fixed-map--combine-maps (oref var no-shortcut-map) (oref fix no-shortcut-map))
                   :map (ergoemacs-get-fixed-map--combine-maps (oref var map) (oref fix map))
                   :unbind-map (ergoemacs-get-fixed-map--combine-maps (oref var unbind-map) (oref fix unbind-map))
                   :shortcut-list (append (oref var shortcut-list) (oref fix shortcut-list))
                   :shortcut-movement (append (oref var shortcut-movement) (oref fix shortcut-movement))
                   :shortcut-shifted-movement (append (oref var shortcut-shifted-movement) (oref fix shortcut-shifted-movement))
                   :rm-keys (append (oref var rm-keys) (oref fix rm-keys))
                   :cmd-list (append (oref var cmd-list) (oref fix cmd-list))
                   :deferred-keys (append (oref var deferred-keys) (oref fix deferred-keys))))
        (when (slot-boundp obj 'hook)
          (oset ret hook (oref obj hook)))
        (puthash ilay ret keymap-hash)
        (oset obj keymap-hash keymap-hash))
      (setq ret (clone ret (object-name-string obj))) ;; Reset name
      ret)))

(defclass ergoemacs-theme-component-maps (ergoemacs-named)
  ((variable-reg :initarg :variable-reg
                 :initform (concat "\\(?:^\\|<\\)" (regexp-opt '("M-" "<apps>" "<menu>")))
                 :type string)
   (description :initarg :description
                :initform ""
                :type string)
   (just-first :initarg :just-first
               :initform ""
               :type string)
   (layout :initarg :layout
           :initform "us"
           :type string)
   (global :initarg :global
           :type ergoemacs-composite-map)
   (maps :initarg :fixed
         :initform (make-hash-table)
         :type hash-table)
   (fixed-maps :initarg :fixed-maps
               :initform (make-hash-table)
               :type hash-table)
   (hooks :initarg :hooks
          :initform (make-hash-table :test 'equal)
          :type hash-table)
   (init :initarg :init
         :initform ()
         :type list)
   (version :initarg :version ;; "" is default version
            :initform ""
            :type string)
   (versions :initarg :versions
             :initform ()
             :type list))
  "`ergoemacs-mode' theme-component maps")

(defmethod ergoemacs-variable-layout-list ((obj ergoemacs-theme-component-maps))
  (with-slots (global) obj
    (ergoemacs-variable-layout-list global)))

(defmethod ergoemacs-fixed-layout-list ((obj ergoemacs-theme-component-maps))
  (with-slots (global) obj
    (ergoemacs-fixed-layout-list global)))

(defmethod ergoemacs-copy-obj ((obj ergoemacs-theme-component-maps))
  (with-slots (global maps init) obj
    (let ((newmaps (make-hash-table)))
      (setq global (clone global (oref global object-name)))
      (ergoemacs-copy-obj global)
      ;; Reset hash
      (maphash
       (lambda(key o2)
         (let ((new-obj (clone o2 (oref o2 object-name))))
           (ergoemacs-copy-obj new-obj)
           (puthash key new-obj newmaps)))
       maps)
      (oset obj global global)
      (oset obj fixed-maps (make-hash-table))
      (oset obj hooks (make-hash-table :test 'equal))
      (oset obj init (ergoemacs-copy-list init))
      (oset obj maps newmaps))))

(defvar ergoemacs-theme-comp-hash)
(defmethod ergoemacs-theme-component-maps--save-hash ((obj ergoemacs-theme-component-maps))
  (with-slots (object-name version) obj
    (puthash (object-name-string obj)
             obj ergoemacs-theme-comp-hash)))

(defmethod ergoemacs-theme-component-maps--ini ((obj ergoemacs-theme-component-maps))
  (with-slots (variable-reg
               just-first
               layout) obj
    (unless (slot-boundp obj 'global)
      (oset obj global
            (ergoemacs-composite-map
             (object-name-string obj)
             :global-map-p t
             :variable-reg variable-reg
             :just-first just-first
             :layout layout))
      (ergoemacs-theme-component-maps--save-hash obj))))

(defvar ergoemacs-theme-component-maps--always nil)
(defvar ergoemacs-theme-component-maps--full-map nil)
(defvar ergoemacs-theme-component-maps--modify-map nil)
(defvar ergoemacs-theme-component-maps--global-map nil)
(defvar ergoemacs-theme-component-maps--curr-component nil)
(defvar ergoemacs-theme-component-maps--versions '())
(defvar ergoemacs-theme-component-maps--hook nil) 

(defmethod ergoemacs-theme-component-maps--keymap ((obj ergoemacs-theme-component-maps) keymap)
  (ergoemacs-theme-component-maps--ini obj)
  (with-slots (variable-reg
               just-first
               layout
               maps) obj
    (let ((ret (gethash keymap maps)))
        (unless ret
          (setq ret
                (ergoemacs-composite-map
                 (symbol-name keymap)
                 :variable-reg variable-reg
                 :just-first just-first
                 :layout layout
                 :always ergoemacs-theme-component-maps--always
                 :full-map ergoemacs-theme-component-maps--full-map
                 :modify-map ergoemacs-theme-component-maps--modify-map))
          (if ergoemacs-theme-component-maps--hook
              (oset ret hook ergoemacs-theme-component-maps--hook)
            (oset ret hook (intern (save-match-data (replace-regexp-in-string "-map.*\\'" "-hook" (symbol-name keymap))))))
          (puthash keymap ret maps)
          (oset obj maps maps)
          (ergoemacs-theme-component-maps--save-hash obj))
        ret)))

(defmethod ergoemacs-define-map ((obj ergoemacs-theme-component-maps) keymap key def)
  (ergoemacs-theme-component-maps--ini obj)
  (with-slots (global maps) obj
    (cond
     ((eq keymap 'global-map)
      (ergoemacs-define-map global key def))
     ((eq keymap 'ergoemacs-keymap)
      (ergoemacs-define-map global key def t))
     (t
      (let ((composite-map (ergoemacs-theme-component-maps--keymap obj keymap)))
        (if (not (ergoemacs-composite-map-p composite-map))
            (warn "`ergoemacs-define-map' cannot find map for %s" keymap)
          (ergoemacs-define-map composite-map key def)
          (puthash keymap composite-map maps)
          (oset obj maps maps)))))
    (ergoemacs-theme-component-maps--save-hash obj)))

(defmethod ergoemacs-get-fixed-map ((obj ergoemacs-theme-component-maps) &optional keymap layout)
  (ergoemacs-theme-component-maps--ini obj)
  (with-slots (global fixed-maps) obj
    (let* ((ilay (intern (concat (or (and keymap (symbol-name keymap)) "global") "-" (or layout ergoemacs-keyboard-layout))))
           (ret (gethash ilay fixed-maps)))
      (unless ret
        (setq ret (cond
                   ((not keymap) (ergoemacs-get-fixed-map global layout))
                   (t
                    (ergoemacs-get-fixed-map
                     (ergoemacs-theme-component-maps--keymap obj keymap) layout))))
        (puthash ilay ret fixed-maps))
      (ergoemacs-theme-component-maps--save-hash obj)
      ret)))

(defmethod ergoemacs-get-hooks ((obj ergoemacs-theme-component-maps) &optional match ret keymaps)
  (ergoemacs-theme-component-maps--ini obj)
  (with-slots (maps hooks) obj
    (let* ((ret (or ret '()))
           (match (or match "-hook\\'"))
           (append-ret (gethash (list match ret) hooks)))
      (unless append-ret
        (maphash
         (lambda (ignore-key map-obj)
           (when (and (slot-boundp map-obj 'hook)
                      (string-match-p match (symbol-name (oref map-obj hook))))
             (if keymaps
                 (push (oref map-obj object-symbol) append-ret)
               (push (oref map-obj hook) append-ret))))
         maps)
        (puthash (list match ret) append-ret hooks)
        (oset obj hooks hooks)
        (ergoemacs-theme-component-maps--save-hash obj))
      (setq ret (append append-ret ret))
      ret)))

(defvar ergoemacs-theme-component-map-list-fixed-hash (make-hash-table :test 'equal))
(defclass ergoemacs-theme-component-map-list (ergoemacs-named)
  ((map-list :initarg :map-list
             :initform ()
             :type list)
   (components :initarg :components
               :initform ()
               :type list)
   (hooks :initarg :hooks
          :initform (make-hash-table :test 'equal)
          :type hash-table))
  "`ergoemacs-mode' theme-component maps")

(defmethod ergoemacs-variable-layout-list ((obj ergoemacs-theme-component-map-list))
  (with-slots (map-list) obj
    (let (ret)
      (dolist (map map-list)
        (setq ret (append ret (ergoemacs-variable-layout-list map))))
      (reverse ret))))

(defmethod ergoemacs-fixed-layout-list ((obj ergoemacs-theme-component-map-list))
  (with-slots (map-list) obj
    (let (ret)
      (dolist (map map-list)
        (setq ret (append ret (ergoemacs-fixed-layout-list map))))
      (reverse ret))))

(defmethod ergoemacs-get-versions ((obj ergoemacs-theme-component-map-list) )
  (with-slots (map-list) obj
    (let ((ret '()))
      (dolist (map map-list)
        (when (ergoemacs-theme-component-maps-p map)
          (with-slots (versions) map
            (dolist (ver versions)
              (pushnew ver ret :test 'equal)))))
      (sort ret 'string<))))

(defmethod ergoemacs-get-hooks ((obj ergoemacs-theme-component-map-list) &optional match keymaps)
  (with-slots (map-list hooks) obj
    (let* ((final (gethash (list match keymaps) hooks))
           ret test)
      (unless final
        (dolist (map map-list)
          (when (ergoemacs-theme-component-maps-p map)
            (setq ret (ergoemacs-get-hooks map match ret keymaps))))
        (dolist (item ret)
          (pushnew item final :test 'equal))
        (puthash (list match keymaps) final hooks))
      final)))

(defgeneric ergoemacs-get-keymaps-for-hook (obj hook &optional ret)
  "Gets the keymaps that will be modified for HOOK.

Call:
ergoemacs-get-keymaps-for-hook OBJ HOOK")

(defmethod ergoemacs-get-keymaps-for-hook ((obj ergoemacs-theme-component-map-list) hook)
  (ergoemacs-get-hooks obj (concat "\\`" (regexp-quote (symbol-name hook)) "\\'") t))

(defmethod ergoemacs-get-inits ((obj ergoemacs-theme-component-map-list))
  (let (ret '())
    (with-slots (map-list) obj
      (dolist (map map-list)
        (setq ret (append ret (oref map init)))))
    ret))

(defvar ergoemacs-applied-inits '())

(defmethod ergoemacs-apply-inits-obj ((obj ergoemacs-theme-component-map-list))
  (dolist (init (ergoemacs-get-inits obj))
    (cond
     ((not (boundp (nth 0 init))) ;; Do nothing, not bound yet.
      )
     ((assq (nth 0 init) ergoemacs-applied-inits)
      ;; Already applied, Do nothing for now.
      )
     ((and (string-match-p "-mode$" (symbol-name (nth 0 init)))
           (ignore-errors (commandp (nth 0 init) t)))
      (push (list (nth 0 init) (if (symbol-value (nth 0 init)) 1 -1))
            ergoemacs-applied-inits)
      ;; Minor mode toggle... (minor-mode deferred-arg)
      (funcall (nth 0 init) (funcall (nth 1 init))))
     (t
      ;; (Nth 0 Init)iable state change
      (push (list (nth 0 init) (symbol-value (nth 0 init)))
            ergoemacs-applied-inits)
      (set (nth 0 init) (funcall (nth 1 init)))))))

(defun ergoemacs-remove-inits ()
  "Remove the applied initilizations of modes and variables.
This assumes the variables are stored in `ergoemacs-applied-inits'"
  (dolist (init ergoemacs-applied-inits)
    (let ((var (nth 0 init))
          (val (nth 1 init)))
      (cond
       ((and (string-match-p "-mode$" (symbol-name var))
             (ignore-errors (commandp var t)))
        (funcall var val))
       (t
        (set var val)))))
  (setq ergoemacs-applied-inits '()))

(defun ergoemacs-theme--install-shortcuts-list (shortcut-list keymap lookup-keymap full-shortcut-map-p)
  "Install shortcuts for SHORTCUT-LIST into KEYMAP.
LOOKUP-KEYMAP
FULL-SHORTCUT-MAP-P "
  (dolist (y shortcut-list)
    (let ((key (nth 0 y))
          (args (nth 1 y)))
      (ergoemacs-theme--install-shortcut-item
       key args keymap lookup-keymap
       full-shortcut-map-p))))

(declare-function ergoemacs-shortcut-remap-list "ergoemacs-shortcuts.el")
(defun ergoemacs-theme--install-shortcut-item (key args keymap lookup-keymap
                                                   full-shortcut-map-p)
  (let (fn-lst)
    (cond
     ((commandp (nth 0 args))
      (setq fn-lst (ergoemacs-shortcut-remap-list (nth 0 args) lookup-keymap))
      (if fn-lst
          (ignore-errors
            (ergoemacs-theme-component--ignore-globally-defined-key key)
            (define-key keymap key (nth 0 (nth 0 fn-lst))))
        (when full-shortcut-map-p
          (ignore-errors
            (ergoemacs-theme-component--ignore-globally-defined-key key)
            (when (or (commandp (nth 0 args) t)
                      (keymapp (nth 0 args)))
              (define-key keymap key (nth 0 args)))))))
     (full-shortcut-map-p
      (ignore-errors
        (ergoemacs-theme-component--ignore-globally-defined-key key)
        (define-key keymap key
          `(lambda(&optional arg)
             (interactive "P")
             (ergoemacs-read-key ,(nth 0 args) ',(nth 1 args)))))))))

(defvar ergoemacs-original-map-hash (make-hash-table)
  "Hash table of the original maps that `ergoemacs-mode' saves.")

(defvar ergoemacs-deferred-maps '()
  "List of keymaps that should be modified, but haven't been loaded.")

(defvar ergoemacs-deferred-keys '()
  "List of keys that have deferred bindings.")

(defvar ergoemacs-original-keys-to-shortcut-keys-regexp ""
  "Regular expression of original keys that have shortcuts.")

(defvar ergoemacs-shortcut-prefix-keys '()
  "List of prefix keys")

(defvar ergoemacs-original-keys-to-shortcut-keys (make-hash-table :test 'equal)
  "Hash table of the original maps that `ergoemacs-mode' saves.")

(defvar ergoemacs-get-variable-layout  nil)
(defvar ergoemacs-get-fixed-layout nil)
(defvar ergoemacs-global-override-rm-keys)
(defvar ergoemacs-command-shortcuts-hash)
(defvar ergoemacs-theme)
(defvar ergoemacs-keymap)
(defvar ergoemacs-shortcut-keys)
(defvar ergoemacs-read-input-keys)
(defvar ergoemacs-unbind-keys)
(defvar ergoemacs-read-input-keymap)
(defvar ergoemacs-read-emulation-mode-map-alist)
(defvar ergoemacs-shortcut-keymap)
(defvar ergoemacs-emulation-mode-map-alist)
(defvar ergoemacs-shortcut-emulation-mode-map-alist)
(defvar ergoemacs-mode)
(defmethod ergoemacs-theme-obj-install ((obj ergoemacs-theme-component-map-list) &optional remove-p)
  (with-slots (read-map
               map
               shortcut-map
               no-shortcut-map
               unbind-map
               shortcut-list
               rm-keys) (ergoemacs-get-fixed-map obj)
    (let ((hook-map-list '())
          ;; (read-map (or read-map (make-spase-keymap)))
          ;; (shortcut-map (or shortcut-map (make-sparse-keymap)))
          ;; (map (or map (make-sparse-keymap)))
          (menu-keymap (make-sparse-keymap))
          final-map final-shortcut-map final-read-map final-unbind-map
          (rm-list (append rm-keys ergoemacs-global-override-rm-keys)) 
          (i 0))
      ;; Get all the major-mode hooks that will be called or modified
      (setq ergoemacs-deferred-maps '()
            ergoemacs-deferred-keys '())
      (dolist (hook (ergoemacs-get-hooks obj))
        (let ((emulation-var (intern (concat "ergoemacs--for-" (symbol-name hook))))
              (tmp '()) o-map n-map
              (defer '()))
          (dolist (map-name (ergoemacs-get-keymaps-for-hook obj hook))
            (with-slots (map
                         modify-map
                         full-map
                         always
                         deferred-keys) (ergoemacs-get-fixed-map obj map-name)
              (cond
               ((and modify-map always)
                ;; Maps that are always modified.
                (let ((fn-name (intern (concat (symbol-name emulation-var) "-and-" (symbol-name map-name)))))
                  (fset fn-name
                        `(lambda() ,(format "Turn on `ergoemacs-mode' for `%s' during the hook `%s'."
                                       (symbol-name map-name) (symbol-name hook))
                           (let ((new-map ',map))
                             (ergoemacs-theme--install-shortcuts-list 
                              ',(reverse shortcut-list) new-map ,map-name ,full-map)
                             (set ',map-name
                                  (copy-keymap
                                   (make-composed-keymap new-map ,map-name))))))
                  (funcall (if remove-p #'remove-hook #'add-hook) hook
                           fn-name)))
               ((and modify-map (not (boundp map-name)))
                (pushnew (list map-name full-map map deferred-keys) ergoemacs-deferred-maps))
               ((and modify-map (boundp map-name))
                ;; Maps that are modified once (modify NOW if bound);
                ;; no need for hooks?
                (setq defer (append defer (cons map-name deferred-keys)))
                (setq o-map (gethash map-name ergoemacs-original-map-hash))
                (if remove-p
                    (when o-map
                      ;; (message "Restore %s"  map-name)
                      (set map-name (copy-keymap o-map)))
                  ;; (message "Modify %s"  map-name)
                  (unless o-map
                    (setq o-map (copy-keymap (symbol-value map-name)))
                    (puthash map-name o-map ergoemacs-original-map-hash))
                  (setq n-map (copy-keymap map))
                  (ergoemacs-theme--install-shortcuts-list
                   (reverse shortcut-list) n-map o-map full-map)
                  (cond
                   ((ignore-errors
                      (and (eq (nth 0 (nth 1 n-map)) 'keymap)
                               (not (keymap-parent n-map))))
                    (pop n-map)
                    ;; (push (make-sparse-keymap "ergoemacs-modified") n-map)
                    )
                   (t
                    ;; (setq n-map (list (make-sparse-keymap "ergoemacs-modified") n-map))
                    ))
                  (setq n-map (copy-keymap
                               (make-composed-keymap
                                n-map
                                o-map)))
                  (define-key n-map [ergoemacs] 'ignore)
                  (set map-name n-map)))
               (t ;; Maps that are not modified.
                (unless remove-p
                  ;; (message "Setup %s"  hook)
                  (fset emulation-var
                        `(lambda() ,(format "Turn on `ergoemacs-mode' keymaps for `%s'.
This is done by locally setting `ergoemacs--for-%s' to be non-nil.
The actual keymap changes are included in `ergoemacs-emulation-mode-map-alist'." (symbol-name hook) (symbol-name hook))
                           (set (make-local-variable #',emulation-var) t)))
                  (set emulation-var nil)
                  (set-default emulation-var nil)
                  (push map tmp))
                (funcall (if remove-p #'remove-hook #'add-hook) hook
                         emulation-var)))))
          (unless (equal tmp '())
            (unless (eq defer '())
              (push (cons i defer) ergoemacs-deferred-keys))
            (setq i (+ i 1))
            (push (cons emulation-var (ergoemacs-get-fixed-map--composite tmp))
                  hook-map-list))))
      
      ;; Reset shortcut hash
      (setq ergoemacs-command-shortcuts-hash (make-hash-table :test 'equal)
            ergoemacs-shortcut-prefix-keys '()
            ergoemacs-original-keys-to-shortcut-keys-regexp ""
            ergoemacs-original-keys-to-shortcut-keys (make-hash-table :test 'equal))
      (unless remove-p
        ;; Remove keys that should not be in the keymap.
        ;; This includes globally set keys that `ergoemacs-mode' will
        ;; respect.
        ;; The removing of keys doesn't really work right now.
        (setq final-shortcut-map (copy-keymap shortcut-map)
              final-unbind-map (copy-keymap unbind-map)
              final-read-map (copy-keymap read-map)
              final-map (copy-keymap map)
              ergoemacs-get-fixed-layout nil
              ergoemacs-get-variable-layout nil)
        (dolist (key rm-list)
          (let ((vector-key (or (and (vectorp key) key)
                                (read-kbd-macro (key-description key) t))))
            (setq final-read-map (or (and (memq (elt vector-key 0) '(3 24)) ;; Keep `C-c' and `C-x'.
                                          (memq (lookup-key final-read-map (vector (elt vector-key 0)))
                                                '(ergoemacs-ctl-x ergoemacs-ctl-c))
                                          final-read-map)
                                     (ergoemacs-rm-key final-read-map key))
                  final-shortcut-map (ergoemacs-rm-key final-shortcut-map key)
                  final-map (ergoemacs-rm-key final-map key)
                  final-unbind-map (ergoemacs-rm-key final-unbind-map key))))
        ;; Add `ergoemacs-mode' menu.
        (define-key menu-keymap [menu-bar ergoemacs-mode]
          `("ErgoEmacs" . ,(ergoemacs-keymap-menu ergoemacs-theme)))
        ;; Coaleasing the keymaps needs to be done after removing the
        ;; keys, otherwise the keys are not removed...  Probably
        ;; playing with pointers in C.
        ;;(setq final-map (ergoemacs-get-fixed-map--combine-maps menu-keymap final-map))
        ;; Use a combined keymap instead
        (if (not (ignore-errors (nth 0 (nth 1 final-map))))
            (setq final-map (list final-map))
          (pop final-map))
        (push menu-keymap final-map)
        (setq final-map (make-composed-keymap final-map))
        ;; Rebuild Shortcut hash
        (let (tmp)
          (dolist (c (reverse shortcut-list))
            (unless (member (nth 0 c) rm-list)
              (puthash (nth 0 c) (nth 1 c) ergoemacs-command-shortcuts-hash)
              (when (< 1 (length (nth 0 c)))
                (pushnew (substring (nth 0 c) 0 -1)
                         ergoemacs-shortcut-prefix-keys
                         :test 'equal))
              (when (eq (nth 1 (nth 1 c)) 'global)
                (dolist (global-key (ergoemacs-shortcut-function-binding (nth 0 (nth 1 c))))
                  (if (not (gethash global-key ergoemacs-original-keys-to-shortcut-keys))
                      (puthash global-key (append (gethash global-key ergoemacs-original-keys-to-shortcut-keys) (list (nth 0 c))) ergoemacs-original-keys-to-shortcut-keys)
                    (push (key-description global-key) tmp)
                    (puthash global-key (list (nth 0 c)) ergoemacs-original-keys-to-shortcut-keys))))))
          (setq ergoemacs-original-keys-to-shortcut-keys-regexp
                (regexp-opt tmp t))))
      ;; Turn on/off ergoemacs-mode
      (set-default 'ergoemacs-mode (not remove-p))
      (set-default 'ergoemacs-shortcut-keys (not remove-p))
      (set-default 'ergoemacs-read-input-keys (not remove-p))
      (set-default 'ergoemacs-unbind-keys (not remove-p))
      (setq ergoemacs-mode (not remove-p)
            ergoemacs-keymap final-map
            ergoemacs-shortcut-keys (not remove-p)
            ergoemacs-read-input-keys (not remove-p)
            ergoemacs-unbind-keys (not remove-p)
            ergoemacs-read-input-keymap final-read-map
            ergoemacs-read-emulation-mode-map-alist `((ergoemacs-read-input-keys ,@final-read-map))
            ergoemacs-shortcut-keymap final-shortcut-map
            ergoemacs-emulation-mode-map-alist
            (reverse
             (append
              hook-map-list
              (mapcar ;; Get the minor-mode maps that will be added.
               (lambda(remap)
                 (with-slots (map
                              deferred-keys) (ergoemacs-get-fixed-map obj remap)
                   (when deferred-keys
                     (push (cons i (cons remap deferred-keys)) ergoemacs-deferred-keys))
                   (setq i (+ i 1))
                   (cons remap map)))
               (ergoemacs-get-hooks obj "-mode\\'"))))
            ergoemacs-shortcut-emulation-mode-map-alist
            `((ergoemacs-shortcut-keys ,@final-shortcut-map)))
      ;; Apply variables and mode changes.
      (if remove-p
          (progn
            (dolist (item '(ergoemacs-mode ergoemacs-unbind-keys))
              (let ((x (assq item minor-mode-map-alist)))
                (when x
                  (setq minor-mode-map-alist (delq x minor-mode-map-alist)))))
            (ergoemacs-remove-inits)
            (remove-hook 'after-load-functions 'ergoemacs-apply-inits))
        ;; Setup `ergoemacs-mode' and `ergoemacs-unbind-keys'
        (setq minor-mode-map-alist
              `((ergoemacs-mode ,@final-map)
                ,@minor-mode-map-alist
                (ergoemacs-unbind-keys ,@final-unbind-map)))
        (ergoemacs-apply-inits-obj obj)
        (add-hook 'after-load-functions 'ergoemacs-apply-inits)
        (unwind-protect
            (run-hooks 'ergoemacs-theme-hook)))
      t)))

(declare-function ergoemacs-debug-clear "ergoemacs-mode.el")
(defmethod ergoemacs-debug-obj ((obj ergoemacs-theme-component-map-list))
  (ergoemacs-debug-clear)
  (let (tmp)
    (with-slots (map-list object-name) obj
      (ergoemacs-debug "* %s" object-name)
      (ergoemacs-debug "** Variables and Modes")
      (dolist (init (ergoemacs-get-inits obj))
        (ergoemacs-debug "%s = %s" (nth 0 init) (nth 1 init)))
      (setq tmp (ergoemacs-get-fixed-map obj))
      (oset tmp object-name "Composite Keymaps")
      (ergoemacs-debug-obj tmp)
      (ergoemacs-debug "*** Hooks")
      (dolist (hook (ergoemacs-get-hooks obj))
        (ergoemacs-debug "**** %s" hook)
        (setq tmp (ergoemacs-get-keymaps-for-hook obj hook))
        (if (= 1 (length tmp))
            (ergoemacs-debug-obj (ergoemacs-get-fixed-map obj (nth 0 tmp)) "")
          (dolist (map tmp)
            (ergoemacs-debug-obj (ergoemacs-get-fixed-map obj map)
                                 "*****"))))
      (ergoemacs-debug "*** Emulations" )
      (dolist (mode (ergoemacs-get-hooks obj "-mode\\'"))
        (ergoemacs-debug-obj (ergoemacs-get-fixed-map obj mode) "****"))
      (ergoemacs-debug "** Components")
      (dolist (map-obj map-list)
        (when (ergoemacs-theme-component-maps-p map-obj)
          (ergoemacs-debug-obj (ergoemacs-get-fixed-map map-obj) "***")))))
  (call-interactively 'ergoemacs-debug)
  (goto-char (point-min))
  (call-interactively 'hide-sublevels))



(defun ergoemacs-get-fixed-map--composite (map-list)
  (or (and map-list
           (or (and (= 1 (length map-list)) (nth 0 map-list))
               (make-composed-keymap map-list)))
      (make-sparse-keymap)))

(defmethod ergoemacs-get-fixed-map ((obj ergoemacs-theme-component-map-list) &optional keymap layout)
  (with-slots (map-list components) obj
    (let* ((key (append (list keymap
                              (or layout ergoemacs-keyboard-layout)
                              (ergoemacs-theme-get-version)) components))
           (ret (gethash key ergoemacs-theme-component-map-list-fixed-hash)))
      (unless ret
        (let ((fixed-maps (mapcar (lambda(map) (and map (ergoemacs-get-fixed-map map keymap layout))) map-list))
              new-global-map-p
              new-read-map
              new-read-list
              new-shortcut-map
              new-no-shortcut-map
              new-map
              new-unbind-map
              new-shortcut-list
              new-shortcut-movement
              new-shortcut-shifted-movement
              new-rm-keys
              new-cmd-list
              new-modify-map
              new-hook
              new-full-map
              new-always
              new-deferred-keys
              (first t))
          (dolist (map-obj fixed-maps)
            (when (ergoemacs-fixed-map-p map-obj)
              (with-slots (global-map-p
                           read-map
                           read-list
                           shortcut-map
                           no-shortcut-map
                           map
                           unbind-map
                           shortcut-list
                           shortcut-movement
                           shortcut-shifted-movement
                           rm-keys
                           cmd-list
                           modify-map
                           full-map
                           always
                           deferred-keys) map-obj
                (unless (equal read-map '(keymap))
                  (push read-map new-read-map))
                (unless (equal shortcut-map '(keymap))
                  (push shortcut-map new-shortcut-map))
                (unless (equal no-shortcut-map '(keymap))
                  (push no-shortcut-map new-no-shortcut-map))
                (unless (equal map '(keymap))
                  (push map new-map))
                (unless (equal unbind-map '(keymap))
                  (push unbind-map new-unbind-map))
                (when (slot-boundp map-obj 'hook)
                  (setq new-hook (oref map-obj hook)))
                (if first
                    (setq new-shortcut-list shortcut-list
                          new-shortcut-movement shortcut-movement
                          new-shortcut-shifted-movement shortcut-shifted-movement
                          new-read-list read-list
                          new-rm-keys rm-keys
                          new-cmd-list cmd-list
                          new-deferred-keys deferred-keys
                          new-global-map-p global-map-p
                          new-modify-map modify-map
                          new-full-map full-map
                          new-always always
                          first nil)
                  (setq new-global-map-p (or new-global-map-p global-map-p)
                        new-modify-map (or new-modify-map modify-map)
                        new-full-map (or new-full-map full-map)
                        new-always (or new-always always)
                        new-read-list (append new-read-list read-list)
                        new-shortcut-list (append new-shortcut-list shortcut-list)
                        new-shortcut-movement (append new-shortcut-movement shortcut-movement)
                        new-shortcut-shifted-movement (append new-shortcut-shifted-movement shortcut-shifted-movement)
                        new-rm-keys (append new-rm-keys rm-keys)
                        new-cmd-list (append new-cmd-list cmd-list)
                        new-deferred-keys (append new-deferred-keys deferred-keys))))))
          (setq ret
                (ergoemacs-fixed-map
                 (or (and keymap (or (and (stringp keymap) keymap)
                                     (and (symbolp keymap) (symbol-name keymap))))
                     "composite")
                 :global-map-p new-global-map-p
                 :read-list new-read-list
                 :read-map (ergoemacs-get-fixed-map--composite new-read-map)
                 :shortcut-map  (ergoemacs-get-fixed-map--composite new-shortcut-map) 
                 :no-shortcut-map (ergoemacs-get-fixed-map--composite new-no-shortcut-map)
                 :map (ergoemacs-get-fixed-map--composite new-map)
                 :unbind-map (ergoemacs-get-fixed-map--composite new-unbind-map)
                 :shortcut-list new-shortcut-list
                 :shortcut-movement new-shortcut-movement
                 :shortcut-shifted-movement new-shortcut-shifted-movement
                 :rm-keys new-rm-keys
                 :cmd-list new-cmd-list
                 :modify-map new-modify-map
                 :full-map new-full-map
                 :always new-always
                 :deferred-keys new-deferred-keys))
          (when new-hook
            (oset ret hook new-hook))
          (puthash key ret ergoemacs-theme-component-map-list-fixed-hash)))
      ret)))


(defun ergoemacs-define-key (keymap key def)
  "Defines KEY to be DEF in KEYMAP for object `ergoemacs-theme-component-maps--curr-component'."
  (if (not (ergoemacs-theme-component-maps-p ergoemacs-theme-component-maps--curr-component))
      (warn "`ergoemacs-define-key' is meant to be called in a theme definition.")
    (let* ((ergoemacs-theme-component-maps--hook
            (or
             ergoemacs-theme-component-maps--hook
             (and (not (memq keymap '(global-map ergoemacs-keymap)))
                  (string-match-p "\\(mode\\|\\(key\\)?map\\)" (symbol-name keymap))
                  (intern (if (string-match "mode" (symbol-name keymap))
                              (replace-regexp-in-string "mode.*" "mode-hook" (symbol-name keymap))
                            (replace-regexp-in-string "\\(key\\)?map" "mode-hook" (symbol-name keymap)))))))
           (map (or (and (memq keymap '(global-map ergoemacs-keymap))
                         (or ergoemacs-theme-component-maps--global-map
                             (and ergoemacs-theme-component-maps--hook
                                  (string-match "-mode\\'" (symbol-name ergoemacs-theme-component-maps--hook))
                                  ergoemacs-theme-component-maps--hook))) keymap)))
      (ergoemacs-define-map
       ergoemacs-theme-component-maps--curr-component
       map key def))))

(defun ergoemacs-set (symbol newval)
  (if (not (ergoemacs-theme-component-maps-p ergoemacs-theme-component-maps--curr-component))
      (warn "`ergoemacs-set' is meant to be called in a theme definition.")
    ;; ergoemacs-set definition.
    (with-slots (init) ergoemacs-theme-component-maps--curr-component
      (push (list symbol newval) init)
      (oset ergoemacs-theme-component-maps--curr-component
            init init))))

(defun ergoemacs-theme-component--version (version)
  "Changes the theme component version to VERSION."
  (if (not (ergoemacs-theme-component-maps-p ergoemacs-theme-component-maps--curr-component))
      (warn "`ergoemacs-theme-component--version' is meant to be called in a theme definition.")
    ;; ergoemacs-set definition.
    (push ergoemacs-theme-component-maps--curr-component
          ergoemacs-theme-component-maps--versions)
    (setq ergoemacs-theme-component-maps--curr-component
          (clone ergoemacs-theme-component-maps--curr-component
                 (concat (oref ergoemacs-theme-component-maps--curr-component object-name) "::" version)))
    (ergoemacs-copy-obj ergoemacs-theme-component-maps--curr-component)
    (oset ergoemacs-theme-component-maps--curr-component version version)))

(defun ergoemacs-theme-component--with-hook (hook plist body)
  ;; Adapted from Stefan Monnier
  (let ((ergoemacs-theme-component-maps--hook
         (or (and (string-match-p "-\\(hook\\|mode\\)\\'" (symbol-name hook)) hook)
             (and (string-match-p "mode-.*" (symbol-name hook))
                  (save-match-data
                    (intern-soft
                     (replace-regexp-in-string
                      "-mode-.*" "mode-hook"
                      (symbol-name hook)))))
             (and (string-match-p "(key)?map" (symbol-name hook))
                  (save-match-data
                    (intern-soft
                     (replace-regexp-in-string
                      "(key)?map.*" "hook"
                      (symbol-name hook)))))))
        ;; Globally set keys should be an emulation map for the mode.
        (ergoemacs-theme-component-maps--modify-map ;; boolean
         (or (plist-get plist ':modify-keymap)
             (plist-get plist ':modify-map)))
        (ergoemacs-theme-component-maps--full-map
         (or (plist-get plist ':full-shortcut-keymap)
             (plist-get plist ':full-shortcut-map)
             (plist-get plist ':full-map)
             (plist-get plist ':full-keymap)))
        (ergoemacs-theme-component-maps--always
         (plist-get plist ':always)))
    (funcall body)))

;;;###autoload
(defun ergoemacs-theme-component--create-component (plist body)
  ;; Reset variables.
  (let* ((ergoemacs-theme-component-maps--versions '())
         (ergoemacs-theme-component-maps--always nil)
         (ergoemacs-theme-component-maps--full-map nil)
         (ergoemacs-theme-component-maps--modify-map nil)
         (ergoemacs-theme-component-maps--global-map nil)
         (ergoemacs-theme-component-maps--curr-component nil)
         (ergoemacs-theme-component-maps--versions '())
         (ergoemacs-theme-component-maps--hook nil)
         (ergoemacs-theme-component-maps--curr-component
          (ergoemacs-theme-component-maps
           (plist-get plist ':name)
           :description (plist-get plist :description)
           :layout (or (plist-get plist ':layout) "us")
           :variable-reg (or (plist-get plist ':variable-reg)
                             (concat "\\(?:^\\|<\\)" (regexp-opt '("M-" "<apps>" "<menu>"))))
           :just-first (or (plist-get plist ':just-first)
                           (plist-get plist ':first-is-variable-reg)
                           "")))
         ver-list tmp)
    (funcall body)
    (if (equal ergoemacs-theme-component-maps--versions '())
        (ergoemacs-theme-component-maps--save-hash ergoemacs-theme-component-maps--curr-component)
      (push ergoemacs-theme-component-maps--curr-component
            ergoemacs-theme-component-maps--versions)
      (dolist (comp ergoemacs-theme-component-maps--versions)
        (setq tmp (oref comp version))
        (unless (string= tmp "")
          (push tmp ver-list)))
      (dolist (comp ergoemacs-theme-component-maps--versions)
        (with-slots (object-name version) comp
          (oset comp versions ver-list)
          (ergoemacs-theme-component-maps--save-hash comp))))))

(defun ergoemacs-theme-component-get-closest-version (version version-list)
  "Return the closest version to VERSION in VERSION-LIST.
Formatted for use with `ergoemacs-theme-component-hash' it will return ::version or an empty string"
  (if (or (not version) (string= "nil" version)) ""
    (if version-list
        (let ((use-version (version-to-list version))
              biggest-version
              biggest-version-list
              smallest-version
              smallest-version-list
              best-version
              best-version-list
              test-version-list
              ret)
          (mapc
           (lambda (v)
             (setq test-version-list (version-to-list v))
             (if (not biggest-version)
                 (setq biggest-version v
                       biggest-version-list test-version-list)
               (when (version-list-< biggest-version-list test-version-list)
                 (setq biggest-version v
                       biggest-version-list test-version-list)))
             (if (not smallest-version)
                 (setq smallest-version v
                       smallest-version-list test-version-list)
               (when (version-list-< test-version-list smallest-version-list)
                 (setq smallest-version v
                       smallest-version-list test-version-list)))
             (cond
              ((and (not best-version)
                    (version-list-<= test-version-list use-version))
               (setq best-version v
                     best-version-list test-version-list))
              ((and (version-list-<= best-version-list test-version-list) ;; Better than best 
                    (version-list-<= test-version-list use-version))
               (setq best-version v
                     best-version-list test-version-list))))
           version-list)
          (if (version-list-< biggest-version-list use-version)
              (setq ret "")
            (if best-version
                (setq ret (concat "::" best-version))
              (setq ret (concat "::" smallest-version))))
          ret)
      "")))

(defun ergoemacs-theme-get-component-description (component)
  "Gets the description of a COMPONENT.
Allows the component not to be calculated."
  (let* ((comp-name (or (and (symbolp component) (symbol-name component))
                        component))
         (comp (gethash comp-name ergoemacs-theme-comp-hash)))
    (cond
     ((functionp comp)
      (documentation comp))
     ((ergoemacs-theme-component-maps-p comp)
      (oref comp description))
     (t ""))))

(defun ergoemacs-theme-get-component (component &optional version name)
  "Gets the VERSION of COMPONENT from `ergoemacs-theme-comp-hash'.
COMPONENT can be defined as component::version"
  (if (listp component)
      (ergoemacs-theme-component-map-list
       (or name "list") :map-list (mapcar (lambda(comp) (ergoemacs-theme-get-component comp version)) component)
       :components component)
    (let* ((comp-name (or (and (symbolp component) (symbol-name component))
                          component))
           (version (or (and (symbolp version) (symbol-name version))
                        version ""))
           comp ver-list ver)
      (save-match-data
        (when (string-match "::\\([0-9.]+\\)$" comp-name)
          (setq version (match-string 1 comp-name)
                comp-name (replace-match "" nil nil comp-name))))
      (setq comp (gethash comp-name ergoemacs-theme-comp-hash))
      (when (and (not (ergoemacs-theme-component-maps-p comp))
                 (functionp comp))
        ;; Calculate component (and versions)
        (funcall comp)
        (setq comp (gethash comp-name ergoemacs-theme-comp-hash)))
      (if (not (ergoemacs-theme-component-maps-p comp))
          (message "Component %s has not been defined!" component)
        (when (not (string= "" version))
          (setq ver-list (oref comp versions))
          (setq version
                (ergoemacs-theme-component-get-closest-version
                 version ver-list))
          (setq comp (gethash (concat comp-name version)
                              ergoemacs-theme-comp-hash))))
      comp)))

(defun ergoemacs-theme-get-obj (&optional theme version)
  "Get the VERSION of THEME from `ergoemacs-theme-get-component' and `ergoemacs-theme-components'"
  (ergoemacs-theme-get-component (ergoemacs-theme-components (or theme ergoemacs-theme)) version (or theme ergoemacs-theme)))

(defun ergoemacs-keymap-empty-p (keymap &optional dont-collapse)
  "Determines if the KEYMAP is an empty keymap.
DONT-COLLAPSE doesn't collapse empty keymaps"
  (let ((keymap (or (and dont-collapse keymap)
                    (ergoemacs-keymap-collapse keymap))))
    (or (equal keymap nil)
        (equal keymap '(keymap))
        (and (keymapp keymap) (stringp (nth 1 keymap)) (= 2 (length keymap))))))

(defun ergoemacs-keymap-collapse (keymap)
  "Takes out all empty keymaps from a composed keymap"
  (let ((ret '()) tmp)
    (dolist (item keymap)
      (cond
       ((eq item 'keymap) (push item ret))
       ((ignore-errors (keymapp item))
        (unless (ergoemacs-keymap-empty-p item t)
          (setq tmp (ergoemacs-keymap-collapse item))
          (when tmp
            (push tmp ret))))
       (t (push item ret))))
    (setq ret (reverse ret))
    (if (ergoemacs-keymap-empty-p ret t)
        nil
      ret)))

(defvar ergoemacs-theme--object nil
  "Current `ergoemacs-mode' theme object")
(defun ergoemacs-theme-install (&optional theme  version)
  "Gets the keymaps for THEME for VERSION."
  (setq ergoemacs-theme--object (ergoemacs-theme-get-obj (or theme ergoemacs-theme) (or version (ergoemacs-theme-get-version))))
  (ergoemacs-theme-obj-install ergoemacs-theme--object))

(defun ergoemacs-apply-inits (&rest ignore)
  "Applies any deferred initializations."
  (when ergoemacs-theme--object
    (ergoemacs-apply-inits-obj ergoemacs-theme--object)))

(defun ergoemacs-theme-debug ()
  "Prints debugging information about the currently installed theme object."
  (interactive)
  (if ergoemacs-theme--object
      (ergoemacs-debug-obj ergoemacs-theme--object)
    (message "`ergoemacs-mode' isn't running a theme.")))

(defun ergoemacs-theme-remove ()
  "Remove the currently installed theme and reset to emacs keys."
  (when ergoemacs-theme--object
    (ergoemacs-theme-obj-install ergoemacs-theme--object 'remove)
    (setq ergoemacs-theme--object nil)))

(declare-function ergoemacs-global-changed-p "ergoemacs-unbind.el")
(declare-function ergoemacs-shuffle-keys "ergoemacs-mode.el")
(defun ergoemacs-theme-component--ignore-globally-defined-key (key &optional reset)
  "Adds KEY to `ergoemacs-global-override-rm-keys' and `ergoemacs-global-override-map' if globally redefined."
  (let ((ergoemacs-ignore-advice t)
        (key (or (and (vectorp key) key) (read-kbd-macro (key-description key) t)))
        test-key lk)
    (catch 'found-global-command
      (while (>= (length key) 1)
        (setq lk (lookup-key (current-global-map) key))
        (when (ergoemacs-global-changed-p key)
          (when reset ;; Reset keymaps
            ;; Reset keymaps.
            (dolist (map '(ergoemacs-shortcut-keymap ergoemacs-read-input-keymap ergoemacs-keymap ergoemacs-unbind-keymap))
              (when (symbol-value map)
                (set map (ergoemacs-rm-key (symbol-value map) key))
                (setq lk (lookup-key (symbol-value map) key))
                (if (not (integerp lk))
                    (setq test-key key)
                  (setq test-key (substring key 0 lk))
                  (setq lk (lookup-key (symbol-value map) test-key)))
                (when (commandp lk t)
                  (set map (ergoemacs-rm-key (symbol-value map) test-key)))))
            ;; Remove from shortcuts, if present
            (remhash key ergoemacs-command-shortcuts-hash)
            ;; Reset `ergoemacs-shortcut-prefix-keys'
            (setq ergoemacs-shortcut-prefix-keys '())
            (maphash
             (lambda(key ignore)
               (when (< 1 (length key))
                 (pushnew (substring key 0 -1)
                          ergoemacs-shortcut-prefix-keys
                          :test 'equal)))
             ergoemacs-command-shortcuts-hash)
            ;; Setup emulation maps.
            (setq ergoemacs-read-emulation-mode-map-alist
                  (list (cons 'ergoemacs-read-input-keys ergoemacs-read-input-keymap))
                  ergoemacs-shortcut-emulation-mode-map-alist
                  (list (cons 'ergoemacs-shortcut-keys ergoemacs-shortcut-keymap)))
            ;;Put maps in `minor-mode-map-alist'
            (ergoemacs-shuffle-keys t))
          (when (and (or (commandp lk t)
                         (keymapp lk)))
            (push key ergoemacs-global-override-rm-keys)
            (throw 'found-global-command t)))
        (setq key (substring key 0 (- (length key) 1)))))))


(defun ergoemacs-theme-versions (&optional theme version)
  "Get a list of versions for the current theme."
  (ergoemacs-get-versions (ergoemacs-theme-get-obj theme version)))

(defun ergoemacs-theme-set-version (version)
  "Sets the current themes default VERSION"
  (let (found)
    (setq ergoemacs-theme-version
          (mapcar
           (lambda(elt)
             (if (not (equal ergoemacs-theme (nth 0 elt)))
                 elt
               (setq found t)
               (list ergoemacs-theme version)))
           ergoemacs-theme-version))
    (unless found
      (push (list ergoemacs-theme version) ergoemacs-theme-version))))

(defun ergoemacs-theme-get-version ()
  "Gets the current version for the current theme"
  (let ((theme-ver (assoc ergoemacs-theme ergoemacs-theme-version)))
    (if (not theme-ver) nil
      (car (cdr theme-ver)))))

(defvar ergoemacs-theme-hash)
(defun ergoemacs-theme-components (&optional theme)
  "Get a list of components used for the current theme.
This respects `ergoemacs-theme-options'."
  (let* ((theme (or theme ergoemacs-theme))
         (theme-plist (gethash (if (stringp theme) theme
                                 (symbol-name theme))
                               ergoemacs-theme-hash))
         components)
    (setq components (reverse (plist-get theme-plist ':components)))
    (mapc
     (lambda(x)
       (let ((a (assoc x ergoemacs-theme-options)))
         (if (not a)
             (push x components)
           (setq a (car (cdr a)))
           (when (or (not a) (eq a 'on))
             (push x components)))))
     (reverse (plist-get theme-plist ':optional-on)))
    (mapc
     (lambda(x)
       (let ((a (assoc x ergoemacs-theme-options)))
         (when a
           (setq a (car (cdr a)))
           (when (eq a 'on)
             (push x components)))))
     (reverse (plist-get theme-plist ':optional-off)))
    (setq components (reverse components))
    components))

;;;###autoload
(defun ergoemacs-theme-option-off (option)
  "Turns OPTION off.
Uses `ergoemacs-theme-option-on'."
  (ergoemacs-theme-option-on option 'off))

(defun ergoemacs-require (option &optional theme type)
  "Requires an OPTION on ergoemacs themes.

THEME can be a single theme or list of themes to apply the option
to.  If unspecified, it is all themes.

TYPE can be nil, where the option will be turned on by default
but shown as something that can be toggled in the ergoemacs-mode
menu.

TYPE can also be 'required-hidden, where the option is turned on,
and it dosen't show up on the ergoemacs-mode menu.

TYPE can also be 'off, where the option will be included in the
theme, but assumed to be disabled by default.
"
  (if (eq (type-of option) 'cons)
      (mapc
       (lambda(new-option)
         (let (ergoemacs-mode)
           (ergoemacs-require new-option theme type)))
       option)
    (let ((option-sym
           (or (and (stringp option) (intern option)) option)))
      (mapc
     (lambda(theme)
       (let ((theme-plist (gethash (if (stringp theme) theme
                                     (symbol-name theme))
                                   ergoemacs-theme-hash))
             comp on off)
         (setq comp (plist-get theme-plist ':components)
               on (plist-get theme-plist ':optional-on)
               off (plist-get theme-plist ':optional-off))
         (setq comp (delq option-sym comp)
               on (delq option-sym on)
               off (delq option-sym off))
         (cond
          ((eq type 'required-hidden)
           (push option-sym comp))
          ((eq type 'off)
           (push option-sym off))
          (t
           (push option-sym on)))
         (setq theme-plist (plist-put theme-plist ':components comp))
         (setq theme-plist (plist-put theme-plist ':optional-on on))
         (setq theme-plist (plist-put theme-plist ':optional-off off))
         (puthash (if (stringp theme) theme (symbol-name theme)) theme-plist
                  ergoemacs-theme-hash)))
     (or (and theme (or (and (eq (type-of theme) 'cons) theme) (list theme)))
         (ergoemacs-get-themes)))))
  (ergoemacs-theme-option-on option))

(declare-function ergoemacs-mode "ergoemacs-mode.el")
;;;###autoload
(defun ergoemacs-theme-option-on (option &optional off)
  "Turns OPTION on.
When OPTION is a list turn on all the options in the list
If OFF is non-nil, turn off the options instead."
  (if (eq (type-of option) 'cons)
      (mapc
       (lambda(new-option)
         (let (ergoemacs-mode)
           (ergoemacs-theme-option-on new-option off)))
       option)
    (let (found)
      (setq ergoemacs-theme-options
            (mapcar
             (lambda(elt)
               (if (not (eq (nth 0 elt) option))
                   elt
                 (setq found t)
                 (if off
                     (list option 'off)
                   (list option 'on))))
             ergoemacs-theme-options))
      (unless found
        (push (if off (list option 'off) (list option 'on))
              ergoemacs-theme-options))))
  (when ergoemacs-mode
    (ergoemacs-mode -1)
    (ergoemacs-mode 1)))

(defun ergoemacs-theme-toggle-option (option)
  "Toggles theme OPTION."
  (if (ergoemacs-theme-option-enabled-p option)
      (ergoemacs-theme-option-off option)
    (ergoemacs-theme-option-on option)))

(defun ergoemacs-theme-option-enabled-p (option)
  "Determines if OPTION is enabled."
  (let ((plist (gethash ergoemacs-theme ergoemacs-theme-hash))
        options-on options-off)
    (setq options-on (plist-get plist ':optional-on)
          options-off (plist-get plist ':optional-off))
    (or (and (member option options-on)
             (not (member (list option 'off) ergoemacs-theme-options)))
        (and (member option options-off)
             (member (list option 'on) ergoemacs-theme-options)))))

(defun ergoemacs-keymap-menu-theme-options (theme)
  "Gets the options menu for THEME."
  (let ((plist (gethash theme ergoemacs-theme-hash))
        (menu-list '())
        (menu-pre '())
        (options-on '())
        (options-off '())
        (menu-options '())
        (options-list '())
        (options-alist '())
        (i 0))
    (setq options-on (plist-get plist ':optional-on)
          options-off (plist-get plist ':optional-off)
          menu-list (plist-get plist ':options-menu))
    (if (= 0 (length (append options-on options-off))) nil
      (mapc
       (lambda(elt)
         (let ((menu-name (nth 0 elt))
               (menu-items (nth 1 elt))
               desc plist2
               (ret '()))
           (mapc
            (lambda(option)
              (when (memq option (append options-on options-off))
                ;; (setq plist2 (gethash (concat (symbol-name option) ":plist") ergoemacs-theme-component-hash))
                ;; (setq desc (plist-get plist2 ':description))
                (setq desc (ergoemacs-theme-get-component-description (symbol-name option)))
                (push option menu-options)
                (push
                 `(,option
                   menu-item ,desc
                   (lambda()
                     (interactive)
                     (ergoemacs-theme-toggle-option ',option)
                     (ergoemacs-mode -1)
                     (ergoemacs-mode 1))
                   :button (:toggle . (ergoemacs-theme-option-enabled-p ',option)))
                 ret)))
            (reverse menu-items))
           (unless (eq ret '())
             (setq ret
                   `(,(intern (format "options-menu-%s" i))
                     menu-item ,menu-name
                     (keymap ,@ret)))
             (setq i (+ i 1))
             (push ret menu-pre))))
       (reverse menu-list))
      (mapc
       (lambda(option)
         (unless (member option menu-options)
           (let ((desc (ergoemacs-theme-get-component-description (symbol-name option))))
             (push desc options-list)
             (push (list desc option) options-alist))))
       (append options-on options-off))
      `(ergoemacs-theme-options
        menu-item "Theme Options"
        (keymap
         ,@menu-pre
         ,@(mapcar
            (lambda(desc)
              (let ((option (car (cdr (assoc desc options-alist)))))
                `(,option
                  menu-item ,desc
                  (lambda()
                    (interactive)
                    (ergoemacs-theme-toggle-option ',option)
                    (ergoemacs-mode -1)
                    (ergoemacs-mode 1))
                  :button (:toggle . (ergoemacs-theme-option-enabled-p ',option)))))
            (sort options-list 'string<)))))))

(defun ergoemacs-keymap-menu-theme-version (theme)
  "Gets version menu for THEME"
  (let ((theme-versions (ergoemacs-theme-versions theme)))
    (if (not theme-versions) nil
      `(ergoemacs-versions
        menu-item "Theme Versions"
        (keymap
         (ergoemacs-current-version
          menu-item "Current Version"
          (lambda()
            (interactive)
            (ergoemacs-theme-set-version nil)
            (ergoemacs-mode -1)
            (ergoemacs-mode 1))
          :button (:radio . (equal (ergoemacs-theme-get-version) nil)))
         ,@(mapcar
            (lambda(version)
              `(,(intern version) menu-item ,version
                (lambda() (interactive)
                  (ergoemacs-theme-set-version ,version)
                  (ergoemacs-mode -1)
                  (ergoemacs-mode 1))
                :button (:radio . (equal (ergoemacs-theme-get-version) ,version))))
            theme-versions))))))

(declare-function ergoemacs-get-layouts-menu "ergoemacs-layouts.el")
(defun ergoemacs-keymap-menu (theme)
  "Defines menus for current THEME."
  `(keymap
    ,(ergoemacs-get-layouts-menu)
    (ergoemacs-theme-sep "--")
    (ergoemacs-themes
     menu-item "Themes"
     (keymap
      ,@(mapcar
         (lambda(theme)
           `(,(intern theme) menu-item ,(concat theme " - " (plist-get (gethash theme ergoemacs-theme-hash) ':description))
             (lambda() (interactive)
               (ergoemacs-set-default 'ergoemacs-theme ,theme))
             :button (:radio . (string= ergoemacs-theme ,theme))))
         (sort (ergoemacs-get-themes) 'string<))))
    ,(ergoemacs-keymap-menu-theme-options theme)
    ,(ergoemacs-keymap-menu-theme-version theme)
    (ergoemacs-c-x-sep "--")
    (ergoemacs-c-x-c-c
     menu-item "Ctrl+C and Ctrl+X behavior"
     (keymap
      (c-c-c-x-emacs
       menu-item "Ctrl+C and Ctrl+X are for Emacs Commands"
       (lambda()
         (interactive)
         (set-default 'ergoemacs-handle-ctl-c-or-ctl-x 'only-C-c-and-C-x))
       :button (:radio . (eq ergoemacs-handle-ctl-c-or-ctl-x 'only-C-c-and-C-x)))
      (c-c-c-x-cua
       menu-item "Ctrl+C and Ctrl+X are only Copy/Cut"
       (lambda()
         (interactive)
         (set-default 'ergoemacs-handle-ctl-c-or-ctl-x 'only-copy-cut))
       :button (:radio . (eq ergoemacs-handle-ctl-c-or-ctl-x 'only-copy-cut)))
      (c-c-c-x-both
       menu-item "Ctrl+C and Ctrl+X are both Emacs Commands & Copy/Cut"
       (lambda()
         (interactive)
         (set-default 'ergoemacs-handle-ctl-c-or-ctl-x 'both))
       :button (:radio . (eq ergoemacs-handle-ctl-c-or-ctl-x 'both)))
      (c-c-c-x-timeout
       menu-item "Customize Ctrl+C and Ctrl+X Cut/Copy Timeout"
       (lambda() (interactive)
         (customize-variable 'ergoemacs-ctl-c-or-ctl-x-delay)))))
    (c-v
     menu-item "Paste behavior"
     (keymap
      (c-v-multiple
       menu-item "Repeating Paste pastes multiple times"
       (lambda()
         (interactive)
         (set-default 'ergoemacs-smart-paste nil))
       :button (:radio . (eq ergoemacs-smart-paste 'nil)))
      (c-v-cycle
       menu-item "Repeating Paste cycles through previous pastes"
       (lambda()
         (interactive)
         (set-default 'ergoemacs-smart-paste t))
       :button (:radio . (eq ergoemacs-smart-paste 't)))
      (c-v-kill-ring
       menu-item "Repeating Paste starts browse-kill-ring"
       (lambda()
         (interactive)
         (set-default 'ergoemacs-smart-paste 'browse-kill-ring))
       :enable (condition-case err (interactive-form 'browse-kill-ring)
                 (error nil))
       :button (:radio . (eq ergoemacs-smart-paste 'browse-kill-ring)))))
    (ergoemacs-sep-bash "--")
    (ergoemacs-bash
     menu-item "Make Bash aware of ergoemacs keys"
     (lambda () (interactive)
       (call-interactively 'ergoemacs-bash)))
    (ergoemacs-ahk
     menu-item "Make Windows aware of ergoemacs keys (Requires Autohotkey)"
     (lambda () (interactive)
       (call-interactively 'ergoemacs-gen-ahk)))
    (ergoemacs-sep-menu "--")
    (ergoemacs-cheat
     menu-item "Generate/Open Key binding Cheat Sheet"
     (lambda()
       (interactive)
       (call-interactively 'ergoemacs-display-current-svg)))
    (ergoemacs-menus
     menu-item "Use Menus"
     (lambda() (interactive)
       (setq ergoemacs-use-menus (not ergoemacs-use-menus))
       (if ergoemacs-use-menus
           (progn
             (require 'ergoemacs-menus)
             (ergoemacs-menus-on))
         (when (featurep 'ergoemacs-menus)
           (ergoemacs-menus-off))))
     :button (:radio . ergoemacs-use-menus))
    (ergoemacs-save
     menu-item "Save Settings for Future Sessions"
     (lambda ()
       (interactive)
       (customize-save-variable 'ergoemacs-smart-paste ergoemacs-smart-paste)
       (customize-save-variable 'ergoemacs-use-menus ergoemacs-use-menus)
       (customize-save-variable 'ergoemacs-theme ergoemacs-theme)
       (customize-save-variable 'ergoemacs-keyboard-layout ergoemacs-keyboard-layout)
       (customize-save-variable 'ergoemacs-ctl-c-or-ctl-x-delay ergoemacs-ctl-c-or-ctl-x-delay)
       (customize-save-variable 'ergoemacs-handle-ctl-c-or-ctl-x ergoemacs-handle-ctl-c-or-ctl-x)
       (customize-save-variable 'ergoemacs-use-menus ergoemacs-use-menus)
       (customize-save-variable 'ergoemacs-theme-options ergoemacs-theme-options)
       (customize-save-customized)))
    (ergoemacs-customize
     menu-item "Customize ErgoEmacs"
     (lambda ()
       (interactive)
       (customize-group 'ergoemacs-mode)))
    (ergoemacs-mode-exit
     menu-item "Exit ergoemacs-mode"
     (lambda() (interactive) (ergoemacs-mode -1)))))

(defun ergoemacs-get-variable-layout ()
  "Get the old-style variable layout list for `ergoemacs-extras'."
  (if (and ergoemacs-theme--object (not ergoemacs-get-variable-layout))
      (setq ergoemacs-get-variable-layout
            (ergoemacs-variable-layout-list ergoemacs-theme--object))
    (setq ergoemacs-get-variable-layout nil))  
  'ergoemacs-get-variable-layout)

(defun ergoemacs-get-fixed-layout ()
  "Get the old-style fixed layout list for `ergoemacs-extras'."
  (if (and ergoemacs-theme--object (not ergoemacs-get-fixed-layout))
      (setq ergoemacs-get-fixed-layout
            (ergoemacs-fixed-layout-list ergoemacs-theme--object))
    (setq ergoemacs-get-fixed-layout nil)))

(defun ergoemacs-rm-key (keymap key)
  "Removes KEY from KEYMAP even if it is an ergoemacs composed keymap.
Also add global overrides from the current global map, if necessary.
Returns new keymap."
  (if keymap
      (if (listp key)
          (dolist (rm-key key)
            (ergoemacs-rm-key keymap rm-key))
        (let ((new-keymap (copy-keymap keymap)))
          (cond
           ((keymapp (nth 1 new-keymap))
            (pop new-keymap)
            (setq new-keymap
                  (mapcar
                   (lambda(map)
                     (if (not (ignore-errors (keymapp map))) map
                       (let ((lk (lookup-key map key)) lk2 lk3)
                         (cond
                          ((integerp lk)
                           (setq lk2 (lookup-key (current-global-map) key))
                           (setq lk3 (lookup-key map (substring key 0 lk)))
                           (when (and (or (commandp lk2) (keymapp lk2)) (not lk3))
                             (define-key map key lk2)))
                          (lk
                           (define-key map key nil)))))
                     map)
                   new-keymap))
            (push 'keymap new-keymap)
            new-keymap)
           (t
            (define-key new-keymap key nil)
            new-keymap))))))

(defvar ergoemacs-M-x "M-x ")

(defvar ergoemacs-theme-hash (make-hash-table :test 'equal))

(defun ergoemacs-theme-refresh-customize ()
  "Refreshes the customize interface to `ergoemacs-theme'."
  (eval
   (macroexpand
    `(defcustom ergoemacs-theme (if (and (boundp 'ergoemacs-variant) ergoemacs-variant)
                                    ergoemacs-variant
                                  (if (and (boundp 'ergoemacs-theme) ergoemacs-theme)
                                      ergoemacs-theme
                                    (if (getenv "ERGOEMACS_THEME")
                                        (getenv "ERGOEMACS_THEME")
                                      nil)))
       ,(concat "Ergoemacs Themes\n"
                (ergoemacs-get-themes-doc t))
       :type `,(ergoemacs-get-themes-type t)
       :set 'ergoemacs-set-default
       :group 'ergoemacs-mode))))



(make-obsolete-variable 'ergoemacs-variant 'ergoemacs-theme
                        "ergoemacs-mode 5.8.0.1")



(defun ergoemacs-get-themes-doc (&optional silent)
  "Gets the list of all known themes and the documentation associated with the themes."
  (mapconcat
   (lambda(theme)
     (concat theme " - " (plist-get (gethash theme ergoemacs-theme-hash) ':description)))
   (sort (ergoemacs-get-themes silent) 'string<) "\n"))

(defun ergoemacs-get-themes (&optional silent)
  "Gets the list of themes.
When SILENT is true, also include silent themes"
  (let (ret)
    ;; All this is done to copy lists so that sorts will not
    ;; destroy the final list.  Please keep this here so that errors
    ;; will not be introduced (seems silly)
    (setq ret
          (mapcar
           (lambda(x)
             x)
           (or (and silent
                    (append (gethash "defined-themes" ergoemacs-theme-hash)
                            (gethash "silent-themes" ergoemacs-theme-hash)))
               (gethash "defined-themes" ergoemacs-theme-hash))))
    ret))

(defun ergoemacs-get-themes-type (&optional silent)
  "Gets the customization types for `ergoemacs-theme'"
  `(choice
    ,@(mapcar
       (lambda(theme)
         `(const :tag ,(concat theme " - "
                               (plist-get (gethash theme ergoemacs-theme-hash) ':description)) :value ,theme))
       (sort (ergoemacs-get-themes silent) 'string<))
    (symbol :tag "Other")))

;; FIXME
;;;###autoload
(defun ergoemacs-key (key function &optional desc only-first fixed-key)
  "Defines KEY in ergoemacs keyboard based on QWERTY and binds to FUNCTION.
DESC is ignored, as is FIXED-KEY."
  ;; (let* ((key (or
  ;;              (and (vectorp key) key)
  ;;              (read-kbd-macro key t)))
  ;;        (ergoemacs-force-just-first only-first)
  ;;        (ergoemacs-force-variable-reg t))
  ;;   (ergoemacs-theme-component--global-set-key key function))
  )

(defun ergoemacs-fixed-key (key function &optional desc)
  "Defines fixed KEY in ergoemacs  and binds to FUNCTION."
  ;; (let* ((key (or
  ;;              (and (vectorp key) key)
  ;;              (read-kbd-macro key t)))
  ;;        (ergoemacs-force-just-first nil)
  ;;        (ergoemacs-force-variable-reg nil))
  ;;   (ergoemacs-theme-component--global-set-key key function))
  )

(provide 'ergoemacs-theme-engine)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ergoemacs-theme-engine.el ends here
