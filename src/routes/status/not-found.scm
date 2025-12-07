(define-module (routes status not-found)
  #:use-module (git)
  #:use-module (sxml simple)
  #:use-module (templates server)
  #:export (route-not-found))

(define (route-not-found request)
  (respond #:status 404))
