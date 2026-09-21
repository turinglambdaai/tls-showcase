#lang racket

;; Chapter 9. ...and Again, and Again, and Again...
;;
;; Partial functions: looking may or may not return; align and
;; shuffle may or may not terminate; will-stop? cannot exist at all
;; (the halting problem). The escape from the paradox is to stop
;; naming recursion with define - and out falls the applicative-order
;; Y combinator, recursion built from pure lambdas.

(provide atom? pick looking keep-looking eternity
         a-pair? first second build revpair
         shift align length* weight* shuffle
         C A Y length)

(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

;; pick: number lat -> any
(define pick
  (lambda (n lat)
    (cond
      ((zero? (sub1 n)) (car lat))
      (else (pick (sub1 n) (cdr lat))))))

;; looking: symbol lat -> bool
;; Treats numbers in lat as 1-based pointers into lat, and follows
;; them until it lands on a non-number. Is it total? Nobody knows a
;; priori - that is the point.
(define looking
  (lambda (a lat)
    (keep-looking a (pick 1 lat) lat)))

(define keep-looking
  (lambda (a sorn lat)
    (cond
      ((number? sorn) (keep-looking a (pick sorn lat) lat))
      (else (eq? sorn a)))))

;; The function that never returns.
(define eternity
  (lambda (x)
    (eternity x)))

;; --- Staging: align vs shuffle --------------------------------------

(define a-pair?
  (lambda (x)
    (cond
      ((atom? x) #f)
      ((null? x) #f)
      ((null? (cdr x)) #f)
      ((null? (cdr (cdr x))) #t)
      (else #f))))

(define first
  (lambda (p) (car p)))

(define second
  (lambda (p) (car (cdr p))))

(define build
  (lambda (s1 s2) (cons s1 (cons s2 '()))))

(define revpair
  (lambda (pair)
    (build (second pair) (first pair))))

;; shift takes a pair whose first is also a pair and moves part of
;; it to the right: ((a b) c) -> (a (b c))
(define shift
  (lambda (pair)
    (build (first (first pair))
           (build (second (first pair)) (second pair)))))

;; align: pora -> pora
;; Shift left while the left side is a pair, otherwise recur right.
;; That second clause is what makes align terminate; shuffle (swap
;; instead of shift) does not have it, and loops forever on inputs
;; like ((a b) (c d)).
(define align
  (lambda (pora)
    (cond
      ((atom? pora) pora)
      ((a-pair? (first pora)) (align (shift pora)))
      (else (build (first pora)
                   (align (second pora)))))))

;; Termination measures for align.
(define length*
  (lambda (pora)
    (cond
      ((atom? pora) 1)
      ((a-pair? pora)
       (+ (length* (first pora))
          (length* (second pora))))
      (else 0))))

(define weight*
  (lambda (pora)
    (cond
      ((atom? pora) 1)
      ((a-pair? pora)
       (+ (* (weight* (first pora)) 2)
          (weight* (second pora))))
      (else 0))))

(define shuffle
  (lambda (pora)
    (cond
      ((atom? pora) pora)
      ((a-pair? (first pora)) (shuffle (revpair pora)))
      (else (build (first pora)
                   (shuffle (second pora)))))))

;; --- Total? Partial? ----------------------------------------------

;; C: number -> number
;; The Collatz conjecture: always reaches 1? Believed yes, unproven.
(define C
  (lambda (n)
    (cond
      ((= n 1) 1)
      ((even? n) (C (/ n 2)))
      (else (C (add1 (* 3 n)))))))

;; A: number number -> number
;; The Ackermann function: total, yet grows faster than any
;; primitive-recursive function.
(define A
  (lambda (n m)
    (cond
      ((zero? n) (add1 m))
      ((zero? m) (A (sub1 n) 1))
      (else (A (sub1 n) (A n (sub1 m)))))))

;; will-stop? cannot be defined: if it existed, last-try would both
;; stop and not stop on '(). This is the halting problem.
;;
;;   (define will-stop? ...)                  ; impossible
;;   (define last-try
;;     (lambda (x)
;;       (and (will-stop? last-try)
;;            (eternity x))))

;; --- The applicative-order Y combinator ------------------------------
;; Derivation in the book: length0 knows only the empty list;
;; length<=1 knows one element; length<=2 knows two... Each is
;; (define length<N+1>
;;   (lambda (l)
;;     (cond ((null? l) 0)
;;           (else (add1 (length<N> (cdr l)))))))
;;
;; Factor out the almost-identical part, hand it the next-worst
;; length as an argument, and apply the trick twice so that the
;; function can hand ITSELF to itself:

(define length
  ((lambda (le)
     ((lambda (mk-length)
        (mk-length mk-length))
      (lambda (mk-length)
        (le (lambda (x)
              ((mk-length mk-length) x))))))
   (lambda (length)
     (lambda (l)
       (cond
         ((null? l) 0)
         (else (add1 (length (cdr l)))))))))

;; The same trick, named: Y turns any "one-step" function like
;; (lambda (length) (lambda (l) ...)) into the real recursive one,
;; without a single define.
(define Y
  (lambda (le)
    ((lambda (f)
       (f f))
     (lambda (f)
       (le (lambda (x) ((f f) x)))))))
