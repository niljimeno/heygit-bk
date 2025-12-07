(define-module (routes repository)
  #:use-module (sxml simple)
  #:use-module (git)
  #:use-module ((templates sxml) :prefix template:)
  #:export (route-repository))

(define (route-repository name)
  (page-repository (get-repository-files name)))

(define (page-repository files)
  `(,template:head
    (main
     (p "this is a repository!")
     ,(map
       (lambda (file)
         `((a (@ (href ,file)) ,file)
           (br)))
       files))))
