(load "shell.scm")

(define get-repositories
  (with-input-from-pipe
    (string-append "ls" " " "/var/git/")
    read-string))

(define (get-repository-info text)
  (with-input-from-pipe
    (string-append "ls" " " "/var/git/" text)
    read-string))
