(define-module (routes home)
  #:use-module (sxml simple)
  #:use-module ((templates sxml) #:prefix template:)
  #:export (route-home))

(define (page-home)
  `(,template:head
    (main
     (p "Welcome to the mafia"))))

(define (route-home)
  (page-home))
