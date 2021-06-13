;;; zprint.el --- Zprint in Emacs  -*- lexical-binding: t; -*-

;; Author: Shi Tianshu
;; Keywords: clojure
;; Package-Requires: ((emacs "27.1"))
;; Version: 0.0.1
;; URL: https://www.github.com/DogLooksGood/zprint.el
;;
;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Format Clojure buffer with zprint(binary).
;; How to use:
;; 1. Manually format via shortcut:
;;
;;     (define-key clojure-mode-map (kbd "C-c p") 'zprint)
;;
;; 2. Automatically format before save:
;;
;;     (add-hook 'clojure-mode-hook 'zprint-mode)
;;
;;; Code:

(defvar zprint-bin-path "zprint"
  "The path to zprint binary.")

(defvar zprint-lighter " zp"
  "The lighter displayed in modeline.")

(defun zprint ()
  "Reformat code using zprint."
  (interactive)
  (let* ((contents (buffer-string))
         (orig-buf (current-buffer))
         (formatted-contents
          (with-temp-buffer
            (insert contents)
            (let ((buf (current-buffer))
                  (retcode (call-process-region
                            (point-min)
                            (point-max)
                            zprint-bin-path
                            t
                            (current-buffer)
                            nil)))
              (if (zerop retcode)
                  (with-current-buffer orig-buf
                    (replace-buffer-contents buf))
                (error "zprint failed: %s" (string-trim-right (buffer-string))))))))))

;;;###autoload
(define-minor-mode zprint-mode
  "Format code before save."
  :lighter zprint-lighter
  (if zprint-mode
      (add-hook 'before-save-hook 'zprint nil t)
    (remove-hook 'before-save-hook 'zprint t)))

(provide 'zprint)
;;; zprint.el ends here
