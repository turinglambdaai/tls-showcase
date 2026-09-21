#lang racket

;; Tests for Chapter 10. What Is the Value of All of This?
;; The interpreted language has: numbers, booleans, primitives
;; (cons car cdr null? eq? atom? zero? add1 sub1 number?), quote,
;; identifiers, lambda, cond and applications.

(require rackunit
         (prefix-in tls: "../ch10-what-is-the-value.rkt"))

(check-equal? (tls:value 13) 13)
(check-equal? (tls:value #t) #t)
(check-equal? (tls:value '(quote (a b c))) '(a b c))

;; primitives
(check-equal? (tls:value '(add1 6)) 7)
(check-equal? (tls:value '(sub1 8)) 7)
(check-true  (tls:value '(zero? 0)))
(check-false (tls:value '(zero? 3)))
(check-true  (tls:value '(number? 5)))
(check-true  (tls:value '(null? (quote ()))))
(check-equal? (tls:value '(car (quote (a b c)))) 'a)
(check-equal? (tls:value '(cdr (quote (a b c)))) '(b c))
(check-equal? (tls:value '(cons 1 (quote (2 3)))) '(1 2 3))
(check-true  (tls:value '(eq? (quote a) (quote a))))
(check-false (tls:value '(eq? (quote a) (quote b))))
(check-true  (tls:value '(atom? (quote a))))
(check-false (tls:value '(atom? (quote (a b)))))

;; closures
(check-equal? (tls:value '((lambda (x) x) 5)) 5)
(check-equal? (tls:value '((lambda (x y) (cons x (cons y (quote ())))) 1 2))
              '(1 2))
;; the closure remembers the table where it was created
(check-equal? (tls:value '((lambda (x) ((lambda (y) (cons x y)) (quote (b)))) (quote a)))
              '(a b))
;; inner bindings shadow outer ones
(check-equal? (tls:value '((lambda (x) ((lambda (x) (add1 x)) 2)) 10)) 3)

;; cond
(check-equal? (tls:value '(cond ((null? (quote ())) (quote empty))
                                (else (quote full))))
              'empty)
(check-equal? (tls:value '(cond ((eq? 1 2) (quote no))
                                ((atom? (quote a)) (quote yes))
                                (else (quote maybe))))
              'yes)

;; unbound identifiers hit initial-table and fail loudly
(check-exn exn:fail:contract? (lambda () (tls:value 'foo)))

;; entries and tables, directly
(check-equal? (tls:lookup-in-entry 'entree
                                   '((appetizer entree dessert) (pate boeuf spumoni))
                                   (lambda (name) 'not-found))
              'boeuf)
(check-equal? (tls:lookup-in-entry 'zzz
                                   '((appetizer entree) (pate boeuf))
                                   (lambda (name) 'not-found))
              'not-found)
(check-equal? (tls:lookup-in-table 'entree
                                   '(((entree dessert) (spaghetti spumoni))
                                     ((appetizer entree) (pate boeuf)))
                                   (lambda (name) 'not-found))
              'spaghetti)
