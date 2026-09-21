#lang racket

;; Tests for Chapter 1. Toys

(require rackunit
         (prefix-in tls: "../ch01-toys.rkt"))

(check-true  (tls:atom? 'atom))
(check-true  (tls:atom? 14))
(check-true  (tls:atom? 'ux))
(check-false (tls:atom? '(atom)))
(check-false (tls:atom? '(atom atom)))
(check-false (tls:atom? '()))
(check-false (tls:atom? '(atom (atom))))
