(add-to-load-path (dirname (current-filename)))

(use-modules (web server)
             ((routes) #:prefix routes:))

(run-server routes:router)
