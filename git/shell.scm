(use-modules (ice-9 popen)
             (srfi srfi-26)
             (ice-9 rdelim))

(define (with-input-from-pipe command thunk)
  (let ((old (current-input-port))
        (pipe (open-input-pipe command)))
    (dynamic-wind
      (cute set-current-input-port pipe)
      thunk
      (lambda ()
        (set-current-input-port old)
        (close-pipe pipe)))))
