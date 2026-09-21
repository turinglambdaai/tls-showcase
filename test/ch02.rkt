#lang racket

;; Tests for Chapter 2. Do It, Do It Again, and Again, and Again...

(require rackunit
         (prefix-in tls: "../ch02-recursion.rkt"))

(check-true  (tls:lat? '(Jack Sprat could eat no chicken fat)))
(check-false (tls:lat? '((Jack) Sprat could eat no chicken fat))) ; classic trap
(check-true  (tls:lat? '()))
(check-false (tls:lat? '(bacon (and eggs))))

(check-true  (tls:member? 'meat '(mashed potatoes and meat gravy)))
(check-false (tls:member? 'liver '(bagels and lox)))
(check-false (tls:member? 'x '()))
