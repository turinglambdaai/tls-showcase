#lang racket

;; Chapter 1. Toys
;;
;; The primitive toys: car, cdr, cons, null?, eq? and atom?.
;; The Law of Car: car is defined only for non-empty lists.
;; The Law of Cdr: cdr is defined only for non-empty lists.

(provide atom?)

;; Is x an atom? In this book, anything that is neither a pair
;; nor the empty list - symbols and numbers are atoms.
(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))
