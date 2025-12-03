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
