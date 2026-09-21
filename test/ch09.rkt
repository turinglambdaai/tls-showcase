#lang racket

;; Tests for Chapter 9. ...and Again, and Again, and Again...
;; Only terminating cases are tested: looking and shuffle both have
;; inputs on which they never return - that is the chapter's point.

(require rackunit
         (prefix-in tls: "../ch09-and-again.rkt"))

(check-true  (tls:looking 'caviar '(6 2 4 caviar 5 7 3)))
(check-false (tls:looking 'caviar '(6 2 grits caviar 5 7 3)))
; (tls:looking 'caviar '(6 2 4 5 7 3)) never terminates

(check-equal? (tls:shift '((a b) c)) '(a (b c)))
(check-equal? (tls:shift '((a b) (c d))) '(a (b (c d))))

(check-equal? (tls:align 'a) 'a)
(check-equal? (tls:align '(a b)) '(a b))
(check-equal? (tls:align '((a b) c)) '(a (b c)))
(check-equal? (tls:align '(((a b) c) d)) '(a (b (c d))))

(check-equal? (tls:length* 'a) 1)
(check-equal? (tls:length* '((a b) c)) 3)
(check-equal? (tls:weight* 'a) 1)
(check-equal? (tls:weight* '((a b) c)) 7)

(check-equal? (tls:shuffle '(a (b c))) '(a (b c)))
(check-equal? (tls:shuffle '((a b) c)) '(c (a b)))
; (tls:shuffle '((a b) (c d))) never terminates

(check-equal? (tls:C 27) 1)
(check-equal? (tls:C 1) 1)

(check-equal? (tls:A 1 0) 2)
(check-equal? (tls:A 1 1) 3)
(check-equal? (tls:A 2 2) 7)

;; length built from pure lambdas (the book's final derivation),
;; and the named generalisation Y.
(check-equal? (tls:length '()) 0)
(check-equal? (tls:length '(a b c d e)) 5)

(check-equal?
 ((tls:Y (lambda (fact)
           (lambda (n)
             (cond
               ((zero? n) 1)
               (else (* n (fact (sub1 n))))))))
  5)
 120)
