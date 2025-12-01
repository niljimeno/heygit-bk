(use-modules (web server)
             (web request)
             (web response)
             (web uri)
             (sxml simple))
             (ice-9 receive)
             (srfi srfi-1))

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

; do not use 'respond on 404!!! otherwise html will load
; use this instead
(define (not-found request)
  (values (build-response #:code 404)
          (string-append "Resource not found: "
                         (uri->string (request-uri request)))))

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
    (display url)
    (cond
     ((equal? url "/")
      (respond page-home))
     ((equal? url "/explore")
      (respond page-explore))
     ((equal? (first (get-page-sections url)) "repository")
      (respond (page-repository (last (get-page-sections url)))))
     (else (not-found request)))))

(define (slice l offset n)
  (take (drop l offset) n))


(define (get-page-sections url)
  (drop (string-split url #\/) 1))

(run-server site)

; (display list-repositories)
; (display (get-repository-files "sl"))
