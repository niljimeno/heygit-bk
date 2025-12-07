(define-module (templates sxml head)
  #:export (head))

(define head
  `(header
     (h1 "Hey Git!")
     (nav
      (a (@ (href "/")) "Home")
      (a (@ (href "/explore")) "Explore")
      (a (@ (href "/join")) "Join"))))
