(define-module (git shell)
  #:use-module (ice-9 popen)
  #:use-module (srfi srfi-26)
  #:use-module (ice-9 rdelim)
  #:use-module (srfi srfi-1)
  #:export (run-command)
  #:export (command-append))

(define (run-command command)
  (let ((old (current-input-port))
        (pipe (open-input-pipe command)))
    (dynamic-wind
      (cute set-current-input-port pipe)
      read-string
      (lambda ()
        (set-current-input-port old)
        (close-pipe pipe)))))

(define (command-append . commands)
  (fold-right
   (lambda (str prev)
     (string-append str " " prev))
   ""
   commands))
