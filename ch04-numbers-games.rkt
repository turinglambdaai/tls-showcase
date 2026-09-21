#lang racket

;; Chapter 4. Numbers Games
;;
;; Arithmetic rebuilt from three primitives: zero?, add1 and sub1.
;; The Fourth Commandment (numbers): always change at least one
;; argument while recurring, and make it smaller with sub1.
;; The Fifth Commandment: when building a value with +, return 0 for
;; the termination case.
;;
;; Note: zero? is NOT redefined here - it is one of our primitives.
;; (Redefining it in terms of =, which is defined in terms of < and >,
;; which use zero?, would loop forever.)

(provide + - * / ^ addtup tup+ < > = length pick rempick
         no-nums all-nums eqan? occur one?)

(define +
  (lambda (a b)
    (cond
      ((zero? b) a)
      (else (add1 (+ a (sub1 b)))))))

;; The tail-recursive shape of + (an accumulator grows instead of the
;; result being wrapped on the way back up):
;;   (define +
;;     (lambda (a b)
;;       (cond
;;         ((zero? b) a)
;;         (else (+ (add1 a) (sub1 b))))))

(define -
  (lambda (a b)
    (cond
      ((zero? b) a)
      (else (sub1 (- a (sub1 b)))))))

;; addtup: tup -> number
;; Sums a tuple (list of numbers).
(define addtup
  (lambda (tup)
    (cond
      ((null? tup) 0)
      (else (+ (car tup) (addtup (cdr tup)))))))

(define *
  (lambda (n m)
    (cond
      ((zero? m) 0)
      (else (+ n (* n (sub1 m)))))))

;; tup+: tup tup -> tup
;; Adds two tuples element-wise; the longer tuple's tail is kept.
(define tup+
  (lambda (tup1 tup2)
    (cond
      ((null? tup1) tup2)
      ((null? tup2) tup1)
      (else (cons (+ (car tup1) (car tup2))
                  (tup+ (cdr tup1) (cdr tup2)))))))

(define <
  (lambda (n m)
    (cond
      ((zero? m) #f)
      ((zero? n) #t)
      (else (< (sub1 n) (sub1 m))))))

;; n > m is m < n with the arguments exchanged. (Defining > with the
;; same zero?-clauses as < would make (3 > 3) true.)
(define >
  (lambda (n m)
    (< m n)))

(define =
  (lambda (n m)
    (cond
      ((> n m) #f)
      ((< n m) #f)
      (else #t))))

;; ^: number number -> number
(define ^
  (lambda (n m)
    (cond
      ((zero? m) 1)
      (else (* n (^ n (sub1 m)))))))

;; Truncating division, defined by repeated subtraction.
(define /
  (lambda (n m)
    (cond
      ((< n m) 0)
      (else (add1 (/ (- n m) m))))))

;; length: lat -> number
;; Yes, this shadows Racket's length - rebuilding it is the point.
(define length
  (lambda (lat)
    (cond
      ((null? lat) 0)
      (else (add1 (length (cdr lat)))))))

;; pick: number lat -> symbol
;; Returns the n-th element (1-based).
(define pick
  (lambda (n lat)
    (cond
      ((zero? (sub1 n)) (car lat))
      (else (pick (sub1 n) (cdr lat))))))

;; one?: number -> bool
(define one?
  (lambda (n)
    (cond
      ((zero? n) #f)
      (else (zero? (sub1 n))))))

;; rempick: number lat -> lat
;; Removes the n-th element, using one? this time.
(define rempick
  (lambda (n lat)
    (cond
      ((null? lat) '())
      ((one? n) (cdr lat))
      (else (cons (car lat)
                  (rempick (sub1 n) (cdr lat)))))))

;; no-nums: lat -> lat
;; Keeps the non-numbers.
(define no-nums
  (lambda (lat)
    (cond
      ((null? lat) '())
      ((number? (car lat)) (no-nums (cdr lat)))
      (else (cons (car lat) (no-nums (cdr lat)))))))

;; all-nums: lat -> tup
;; Keeps the numbers.
(define all-nums
  (lambda (lat)
    (cond
      ((null? lat) '())
      ((number? (car lat)) (cons (car lat) (all-nums (cdr lat))))
      (else (all-nums (cdr lat))))))

;; eqan?: atom atom -> bool
;; Equality that works for both symbols and numbers.
(define eqan?
  (lambda (a1 a2)
    (cond
      ((and (number? a1) (number? a2)) (= a1 a2))
      ((or (number? a1) (number? a2)) #f)
      (else (eq? a1 a2)))))

;; occur: symbol lat -> number
;; Counts the occurrences of a in lat.
(define occur
  (lambda (a lat)
    (cond
      ((null? lat) 0)
      ((eqan? a (car lat)) (add1 (occur a (cdr lat))))
      (else (occur a (cdr lat))))))
