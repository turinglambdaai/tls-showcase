#lang racket

;; Chapter 3. Cons the Magnificent
;;
;; Building new lists while recurring: rember, firsts, the insert/
;; subst family, and their multi- variants.
;; The Second Commandment: use cons to build lists.
;; The Third Commandment: when building a list with cons, return ()
;; for the termination case.
;; The Fourth Commandment: always change at least one argument while
;; recurring, and test it with null?.

(provide rember firsts insertR insertL subst subst2
         multirember multiinsertR multiinsertL multisubst)

;; rember: symbol lat -> lat
;; Removes the first occurrence of a.
(define rember
  (lambda (a lat)
    (cond
      ((null? lat) '())
      ((eq? a (car lat)) (cdr lat))
      (else (cons (car lat) (rember a (cdr lat)))))))

;; firsts: list-of-lists -> lat
;; Takes the first element of each inner list.
(define firsts
  (lambda (l)
    (cond
      ((null? l) '())
      (else (cons (car (car l)) (firsts (cdr l)))))))

;; insertR: symbol symbol lat -> lat
;; Inserts new to the right of the first old.
(define insertR
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? old (car lat)) (cons old (cons new (cdr lat))))
      (else (cons (car lat) (insertR new old (cdr lat)))))))

;; insertL: symbol symbol lat -> lat
;; Inserts new to the left of the first old.
(define insertL
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? old (car lat)) (cons new lat))
      (else (cons (car lat) (insertL new old (cdr lat)))))))

;; subst: symbol symbol lat -> lat
;; Replaces the first occurrence of old with new.
(define subst
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? old (car lat)) (cons new (cdr lat)))
      (else (cons (car lat) (subst new old (cdr lat)))))))

;; subst2: symbol symbol symbol lat -> lat
;; Replaces the first occurrence of old1 or old2 with new.
(define subst2
  (lambda (new old1 old2 lat)
    (cond
      ((null? lat) '())
      ((eq? old1 (car lat)) (cons new (cdr lat)))
      ((eq? old2 (car lat)) (cons new (cdr lat)))
      (else (cons (car lat) (subst2 new old1 old2 (cdr lat)))))))

;; multirember: symbol lat -> lat
;; Removes all occurrences of a.
(define multirember
  (lambda (a lat)
    (cond
      ((null? lat) '())
      ((eq? a (car lat)) (multirember a (cdr lat)))
      (else (cons (car lat) (multirember a (cdr lat)))))))

;; multiinsertR: symbol symbol lat -> lat
;; Inserts new to the right of every old.
(define multiinsertR
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? old (car lat))
       (cons old (cons new (multiinsertR new old (cdr lat)))))
      (else (cons (car lat) (multiinsertR new old (cdr lat)))))))

;; multiinsertL: symbol symbol lat -> lat
;; Inserts new to the left of every old.
(define multiinsertL
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? old (car lat))
       (cons new (cons old (multiinsertL new old (cdr lat)))))
      (else (cons (car lat) (multiinsertL new old (cdr lat)))))))

;; multisubst: symbol symbol lat -> lat
;; Replaces every occurrence of old with new.
(define multisubst
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? old (car lat))
       (cons new (multisubst new old (cdr lat))))
      (else (cons (car lat) (multisubst new old (cdr lat)))))))
