(defun nix-prefetch-url-unpack (url)
  "Runs nix-prefetch-url --unpack and returns the hash"
  ; TODO: sensible error handling
  (let ((last-nonempty (lambda ()
                         "Jumps to last non-empty line"
                         (goto-char (point-max))
                         (while (= (line-beginning-position)
                                   (line-end-position))
                           (forward-line -1)))))
    (with-temp-buffer
      (call-process
       "nix-prefetch-url"
       nil t nil
       "--unpack" "--type" "sha256" url)
      (funcall last-nonempty)
      (buffer-substring-no-properties
       (line-beginning-position)
       (line-end-position)))))

(defun nix-prefetch-yank-hash (prefetcher-fn)
  (if-let ((url (url-get-url-at-point)))
    (progn
      (message "Prefetching url for nix: %s" url)
      (let ((hash (funcall prefetcher-fn url)))
        (kill-new hash)
        (message "Hash %s copied to kill-ring" hash)))
    (message "No url at point!")))

(provide 'nix-prefetch)
