(use-modules (web server))
(use-modules (web request)
             (web response)
             (web uri)
             (sxml simple))
(use-modules (ice-9 receive))

(load "git/git.scm")


; basics provided by Robert McAtee
; (github.com/robertmcatee/guile-web-server-example)
(define (templatize title body)
  `(html (@ (lang "en")) (head (title ,title))
         (body ,@body)))

(define* (respond #:optional body #:key
                  (status 200)
                  (title "Hey Git!")
                  (doctype "<!DOCTYPE html>\n")
                  (content-type-params '((charset . "utf-8")))
                  (content-type 'text/html)
                  (extra-headers '())
                  (sxml (and body (templatize title body))))
  (values (build-response
           #:code status
           #:headers `((content-type
                        . (,content-type ,@content-type-params))
                       ,@extra-headers))
          (lambda (port)
            (if sxml
                (begin
                  (if doctype (display doctype port))
                  (sxml->xml sxml port))))))

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

(define var1 "Hey Git!")

(define explore-page
  `(,heygit-head
     (main
      (p "Welcome to the mafia"))))

(define page-404
  `(h1 "404 - not found"))

(define (not-found request)
  (values (build-response #:code 404)
          (string-append "Resource not found: "
                         (uri->string (request-uri request)))))

(define (site request body)
  (let ((url (uri-path (request-uri request))))
    (display url)
    (cond
     ((equal? url "/") (respond page-home))
     ((equal? url "/explore") (respond explore-page))
     (else (not-found request)))))

(run-server site)

; (display get-repositories)
; (display (get-repository-info "hello"))
