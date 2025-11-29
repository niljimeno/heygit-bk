(define (find value list)
  (if (pair? list)
      (if (equal? (car list) value)
        (begin (display "Found it!")
               (newline))
        (find value (cdr list)))
    (display "No?")))

(find 5 '(1 2 3 4 5 6))
