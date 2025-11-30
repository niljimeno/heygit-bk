(load "shell.scm")

(define list-repositories
  (string-split
   (run-command
     (command-append "ls" "-1a" "/var/git/"))
   #\newline))

(define (get-repository-info name)
  (list
   (list 'files (get-repository-files name))))

(define (get-repository-files name)
  (string-split
   (run-command
    (command-append
     "git" "-C" (string-append "/var/git/" name)
     "ls-tree" "--name-only" "main" "-r"))
   #\newline))


; list all commits
; git log --oneline --all

; list all files in a specific commit, only its name, recursively
; git ls-tree --name-only 045deb3 -r

; list all changed files of a commit
; git diff-tree --no-commit-id --name-only bd61ad98 -r
; git diff-tree

; show the contents of a file in a branch or a specific commit
; git show main:test/torture.sl
; git show 045deb3:test/torture.sl

; get branches without asterisks
; git --format "%(refname:short)

; get main branch name
; basename $(git symbolic-ref refs/remotes/origin/HEAD)
