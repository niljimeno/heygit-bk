(define-module (routes explore)
  #:use-module (srfi srfi-1)
  #:use-module (sxml simple)
  #:use-module ((git) #:prefix git:)
  #:use-module ((templates sxml) #:prefix template:)
  #:export (route-explore))

(define (page-explore repositories)
  `(,template:head
    (main
     (p "Welcome to the exploration zone")
     (ul
      ,(map
        (lambda (repository)
          `(a (@ (href ,(string-append "/repository/" repository)))
                 (li ,repository)))
        repositories)))))

(define (route-explore)
  (page-explore (git:get-repository-list)))
