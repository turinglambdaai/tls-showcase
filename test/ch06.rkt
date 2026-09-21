#lang racket

;; Tests for Chapter 6. Shadows

(require rackunit
         (prefix-in tls: "../ch06-shadows.rkt"))

(check-true  (tls:numbered? '(1 + 2)))
(check-true  (tls:numbered? '(1 + (3 * 4))))
(check-true  (tls:numbered? '((2 ^ 3) + (4 * 5))))
(check-false (tls:numbered? '(a + 2)))
(check-true  (tls:numbered? 42))

(check-equal? (tls:infix-value '(1 + 2)) 3)
(check-equal? (tls:infix-value '(1 + (3 * 4))) 13)
(check-equal? (tls:infix-value '((2 ^ 3) + (4 * 5))) 28)

(check-equal? (tls:value '(+ 1 3)) 4)
(check-equal? (tls:value '(+ 1 (* 3 4))) 13)
(check-equal? (tls:value '(^ 2 3)) 8)
(check-equal? (tls:value '(* 2 (+ 1 3))) 8)
(check-equal? (tls:value 42) 42)

;; Numbers as tallies: () is zero, (()) is one, (() ()) is two.
(check-true  (tls:sero? '()))
(check-false (tls:sero? '(())))
(check-equal? (tls:edd1 '()) '(()))
(check-equal? (tls:zub1 '(() ())) '(()))
(check-equal? (tls:add '(() ()) '(())) '(() () ()))
(check-true (tls:sero? (tls:add '() '())))
