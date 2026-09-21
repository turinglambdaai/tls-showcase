#lang racket

;; Chapter 6. Shadows
;;
;; Arithmetic expressions as data. First value reads infix
;; expressions like (1 + (3 * 4)); the final version reads prefix
;; expressions like (+ 1 (* 3 4)) with the help of selector
;; functions. Then numbers are re-imagined as lists ("tallies"),
;; showing that arithmetic is only a convention.
;; The Seventh Commandment: recur on subexpressions of the same
;; nature (both sides of an arithmetic expression).

(provide atom? numbered? value infix-value
         1st-sub-exp 2nd-sub-exp operator
         sero? edd1 zub1 add)

(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

;; numbered?: aexp -> bool
;; Is aexp an arithmetic expression (infix) containing only numbers?
(define numbered?
  (lambda (aexp)
    (cond
      ((atom? aexp) (number? aexp))
      (else
       (and (numbered? (car aexp))
            (numbered? (car (cdr (cdr aexp)))))))))

;; infix-value: infix-aexp -> number
;; The first version: the operator sits BETWEEN the operands, so the
;; selectors are written out explicitly. expt is Racket's integer
;; exponentiation (the book writes it as an up-arrow).
(define infix-value
  (lambda (aexp)
    (cond
      ((atom? aexp) aexp)
      ((eq? (car (cdr aexp)) '+)
       (+ (infix-value (car aexp))
          (infix-value (car (cdr (cdr aexp))))))
      ((eq? (car (cdr aexp)) '*)
       (* (infix-value (car aexp))
          (infix-value (car (cdr (cdr aexp))))))
      (else
       (expt (infix-value (car aexp))
             (infix-value (car (cdr (cdr aexp)))))))))

;; Selectors for PREFIX arithmetic expressions: (+ 1 3)
(define 1st-sub-exp
  (lambda (aexp) (car (cdr aexp))))

(define 2nd-sub-exp
  (lambda (aexp) (car (cdr (cdr aexp)))))

(define operator
  (lambda (aexp) (car aexp)))

;; value: prefix-aexp -> number
;; The same function, now with the abstraction of selectors.
(define value
  (lambda (nexp)
    (cond
      ((atom? nexp) nexp)
      ((eq? (operator nexp) '+)
       (+ (value (1st-sub-exp nexp))
          (value (2nd-sub-exp nexp))))
      ((eq? (operator nexp) '*)
       (* (value (1st-sub-exp nexp))
          (value (2nd-sub-exp nexp))))
      (else
       (expt (value (1st-sub-exp nexp))
             (value (2nd-sub-exp nexp)))))))

;; --- Shadows: numbers as tallies ----------------------------------
;; () is zero, (() ()) is two, and so on. Arithmetic still works,
;; which shows it was never about the numerals.

(define sero?
  (lambda (n)
    (null? n)))

(define edd1
  (lambda (n)
    (cons '() n)))

(define zub1
  (lambda (n)
    (cdr n)))

(define add
  (lambda (n m)
    (cond
      ((sero? m) n)
      (else (edd1 (add n (zub1 m)))))))
