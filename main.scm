(use-modules (web server)
             (web request)
             (web response)
             (web uri))
(use-modules (sxml simple))
(use-modules (ice-9 receive))
(use-modules (srfi srfi-1))

(load "git/git.scm")
(load "server.scm")

(define (not-found request)
  (respond #:status 404))

; html parts
(define heygit-head
  `(header
     (h1 "Hey Git!")
     (nav
      (a (@ (href "/")) "Home")
      (a (@ (href "/explore")) "Explore")
      (a (@ (href "/join")) "Join"))))

(define page-home
  `(,heygit-head
    (main
     (p "Welcome to the mafia"))))

(define page-explore
  `(,heygit-head
    (main
     (p "Welcome to the exploration zone")
     (ul
      ,(map
        (lambda (repository)
          `(a (@ (href ,(string-append "/repository/" repository)))
                 (li ,repository)))
        list-repositories)))))

(define (page-repository repository)
  `(,heygit-head
    (main
     (p "this is a repository!")
     ,(map
       (lambda (file)
         `((a (@ (href ,file)) ,file)
           (br)))
       (get-repository-files repository)))))

(define (site request body)
  (let ((url (uri-path (request-uri request))))
    (cond
     ((equal? url "/")
      (respond page-home))
     ((equal? url "/explore")
      (respond page-explore))
     ((equal? (first (get-page-sections url)) "repository")
      (respond (page-repository (last (get-page-sections url)))))
     (else (not-found request)))))


(define (get-page-sections url)
  (drop (string-split url #\/) 1))

(run-server site)
