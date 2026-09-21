#lang racket

;; Chapter 2. Do It, Do It Again, and Again, and Again...
;;
;; The first recursive functions: lat? and member?.
;; The First Commandment: when recurring on a list of atoms, ask
;; two questions - (null? lat) and something else.

(provide atom? lat? member?)

;; Helper from Chapter 1.
(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

;; lat?: list -> bool
;; Is l a list of atoms?
(define lat?
  (lambda (l)
    (cond
      ((null? l) #t)
      ((atom? (car l)) (lat? (cdr l)))
      (else #f))))

;; member?: symbol lat -> bool
(define member?
  (lambda (a lat)
    (cond
      ((null? lat) #f)
      ((eq? a (car lat)) #t)
      (else (member? a (cdr lat))))))
