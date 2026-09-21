#lang racket

;; Chapter 8. Lambda the Ultimate
;;
;; Functions that make functions: currying, function adapters, and
;; the single insert-g from which insertL/insertR/subst/rember all
;; fall out. Then the collectors: continuation-passing style, where
;; "what to do next" is itself a function argument.
;; The Ninth Commandment: abstract common patterns with a new
;; function.
;; The Tenth Commandment: build functions to collect more than one
;; value at a time.

(provide atom? rember-f eq?-c insertL-f insertR-f insert-g
         seqL seqR seqS seqrem insertL insertR subst rember
         value 1st-sub-exp operator atom-to-function
         multirember-f multiremberT multirember&co
         a-friend last-friend
         multiinsertLR&co
         evens-only* evens-only*&co the-last-friend)

(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

;; rember-f: function -> function
;; The curried rember: it takes the equality test FIRST and returns
;; the remover.
(define rember-f
  (lambda (test?)
    (lambda (a l)
      (cond
        ((null? l) '())
        ((test? a (car l)) ((rember-f test?) a (cdr l)))
        (else (cons (car l) ((rember-f test?) a (cdr l))))))))

;; eq?-c: atom -> function
;; The function adapter: specialise eq? by pre-binding one argument.
(define eq?-c
  (lambda (a)
    (lambda (x) (eq? x a))))

(define insertL-f
  (lambda (test?)
    (lambda (new old lat)
      (cond
        ((null? lat) '())
        ((test? old (car lat)) (cons new lat))
        (else (cons (car lat)
                    ((insertL-f test?) new old (cdr lat))))))))

(define insertR-f
  (lambda (test?)
    (lambda (new old lat)
      (cond
        ((null? lat) '())
        ((test? old (car lat))
         (cons (car lat) (cons new (cdr lat))))
        (else (cons (car lat)
                    ((insertR-f test?) new old (cdr lat))))))))

;; The sequences: what to do at the point of a match. All the
;; difference between insertL, insertR, subst and rember lives here.
(define seqL
  (lambda (new old l)
    (cons new (cons old l))))

(define seqR
  (lambda (new old l)
    (cons old (cons new l))))

(define seqS
  (lambda (new old l)
    (cons new l)))

(define seqrem
  (lambda (new old l)
    l))

;; insert-g: seq -> function
;; insertL, insertR, subst and rember are ONE function.
(define insert-g
  (lambda (seq)
    (lambda (new old lat)
      (cond
        ((null? lat) '())
        ((eq? old (car lat))
         (seq new old ((insert-g seq) new old (cdr lat))))
        (else (cons (car lat)
                    ((insert-g seq) new old (cdr lat))))))))

(define insertL (insert-g seqL))
(define insertR (insert-g seqR))
(define subst  (insert-g seqS))
;; rember only needs to remove, so new is irrelevant: pass #f.
(define rember
  (lambda (a l)
    ((insert-g seqrem) #f a l)))

;; --- The Chapter 6 evaluator, one more time ------------------------
;; Selectors for prefix arithmetic expressions.
(define 1st-sub-exp
  (lambda (aexp) (car (cdr aexp))))

(define 2nd-sub-exp
  (lambda (aexp) (car (cdr (cdr aexp)))))

(define operator
  (lambda (aexp) (car aexp)))

;; atom-to-function: atom -> function
;; The table that turns the operator SYMBOL into the operator
;; FUNCTION - so value no longer needs three almost-identical
;; clauses.
(define atom-to-function
  (lambda (x)
    (cond
      ((eq? x '+) +)
      ((eq? x '*) *)
      (else expt))))

(define value
  (lambda (nexp)
    (cond
      ((atom? nexp) nexp)
      (else
       ((atom-to-function (operator nexp))
        (value (1st-sub-exp nexp))
        (value (2nd-sub-exp nexp)))))))

;; --- Collectors: continuation-passing style -------------------------

;; multirember-f: function -> function
(define multirember-f
  (lambda (test?)
    (lambda (a lat)
      (cond
        ((null? lat) '())
        ((test? a (car lat))
         ((multirember-f test?) a (cdr lat)))
        (else (cons (car lat)
                    ((multirember-f test?) a (cdr lat))))))))

;; multiremberT: function lat -> lat
;; Like multirember-f test?, but takes the tester directly.
(define multiremberT
  (lambda (test? lat)
    (cond
      ((null? lat) '())
      ((test? (car lat)) (multiremberT test? (cdr lat)))
      (else (cons (car lat) (multiremberT test? (cdr lat)))))))

;; multirember&co: symbol lat collector -> any
;; Recurs over lat while BUILDING two continuations: one carrying
;; the atoms that are NOT a, one carrying those that are. At the end
;; the collector is called with both lists.
(define multirember&co
  (lambda (a lat col)
    (cond
      ((null? lat) (col '() '()))
      ((eq? (car lat) a)
       (multirember&co a (cdr lat)
         (lambda (newlat seen)
           (col newlat (cons (car lat) seen)))))
      (else
       (multirember&co a (cdr lat)
         (lambda (newlat seen)
           (col (cons (car lat) newlat) seen)))))))

(define a-friend
  (lambda (x y)
    (null? y)))

(define last-friend
  (lambda (x y)
    (length x)))

;; multiinsertLR&co: symbol symbol symbol lat collector -> any
;; Inserts new left of oldL and right of oldR, and tells the
;; collector how many of each it inserted.
(define multiinsertLR&co
  (lambda (new oldL oldR lat col)
    (cond
      ((null? lat) (col '() 0 0))
      ((eq? (car lat) oldL)
       (multiinsertLR&co new oldL oldR (cdr lat)
         (lambda (newlat L R)
           (col (cons new (cons oldL newlat)) (add1 L) R))))
      ((eq? (car lat) oldR)
       (multiinsertLR&co new oldL oldR (cdr lat)
         (lambda (newlat L R)
           (col (cons oldR (cons new newlat)) L (add1 R)))))
      (else
       (multiinsertLR&co new oldL oldR (cdr lat)
         (lambda (newlat L R)
           (col (cons (car lat) newlat) L R)))))))

;; evens-only*: list -> list
;; Keeps only the even numbers, preserving tree structure.
(define evens-only*
  (lambda (l)
    (cond
      ((null? l) '())
      ((atom? (car l))
       (cond
         ((even? (car l))
          (cons (car l) (evens-only* (cdr l))))
         (else (evens-only* (cdr l)))))
      (else
       (cons (evens-only* (car l))
             (evens-only* (cdr l)))))))

;; evens-only*&co: list collector -> any
;; The collector receives the even tree, the product of the even
;; numbers, and the sum of the odd ones.
(define evens-only*&co
  (lambda (l col)
    (cond
      ((null? l) (col '() 1 0))
      ((atom? (car l))
       (cond
         ((even? (car l))
          (evens-only*&co (cdr l)
            (lambda (newl product sum)
              (col (cons (car l) newl)
                   (* (car l) product)
                   sum))))
         (else
          (evens-only*&co (cdr l)
            (lambda (newl product sum)
              (col newl product (+ (car l) sum)))))))
      (else
       (evens-only*&co (car l)
         (lambda (al ap as)
           (evens-only*&co (cdr l)
             (lambda (bl bp bs)
               (col (cons al bl)
                    (* ap bp)
                    (+ as bs))))))))))

(define the-last-friend
  (lambda (newl product sum)
    (cons sum (cons product newl))))
