#lang racket

;; Chapter 7. Friends and Relations
;;
;; Sets (represented as lists of atoms) and relations (lists of
;; pairs). This is the first chapter that builds on earlier ones:
;; member? comes from Chapter 2, multirember and firsts from Chapter 3.
;; The Sixth Commandment: simplify a function only after it is correct.

(require "ch02-recursion.rkt"
         "ch03-cons-the-magnificent.rkt")

(provide set? makeset subset? eqset? intersect? intersect union
         intersectall a-pair? first second build fun? revrel revpair
         seconds fullfun?)

(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

;; set?: lat -> bool
;; Does lat contain no repeated atoms?
(define set?
  (lambda (lat)
    (cond
      ((null? lat) #t)
      ((member? (car lat) (cdr lat)) #f)
      (else (set? (cdr lat))))))

;; makeset: lat -> set
(define makeset
  (lambda (lat)
    (cond
      ((null? lat) '())
      (else
       (cons (car lat)
             (makeset (multirember (car lat) (cdr lat))))))))

;; subset?: set set -> bool
(define subset?
  (lambda (set1 set2)
    (cond
      ((null? set1) #t)
      (else
       (and (member? (car set1) set2)
            (subset? (cdr set1) set2))))))

;; eqset?: set set -> bool
(define eqset?
  (lambda (set1 set2)
    (and (subset? set1 set2)
         (subset? set2 set1))))

;; intersect?: set set -> bool
(define intersect?
  (lambda (set1 set2)
    (cond
      ((null? set1) #f)
      (else
       (or (member? (car set1) set2)
           (intersect? (cdr set1) set2))))))

;; intersect: set set -> set
(define intersect
  (lambda (set1 set2)
    (cond
      ((null? set1) '())
      ((member? (car set1) set2)
       (cons (car set1) (intersect (cdr set1) set2)))
      (else (intersect (cdr set1) set2)))))

;; union: set set -> set
(define union
  (lambda (set1 set2)
    (cond
      ((null? set1) set2)
      ((member? (car set1) set2)
       (union (cdr set1) set2))
      (else (cons (car set1)
                  (union (cdr set1) set2))))))

;; intersectall: list-of-sets -> set
;; Assumes a non-empty list of sets.
(define intersectall
  (lambda (l-set)
    (cond
      ((null? (cdr l-set)) (car l-set))
      (else
       (intersect (car l-set)
                  (intersectall (cdr l-set)))))))

;; a-pair?: any -> bool
;; Is x a list of exactly two elements?
(define a-pair?
  (lambda (x)
    (cond
      ((atom? x) #f)
      ((null? x) #f)
      ((null? (cdr x)) #f)
      ((null? (cdr (cdr x))) #t)
      (else #f))))

(define first
  (lambda (p)
    (car p)))

(define second
  (lambda (p)
    (car (cdr p))))

(define build
  (lambda (s1 s2)
    (cons s1 (cons s2 '()))))

;; fun?: rel -> bool
;; Is the relation a function (no repeated firsts)?
(define fun?
  (lambda (rel)
    (set? (firsts rel))))

(define revpair
  (lambda (pair)
    (build (second pair) (first pair))))

;; revrel: rel -> rel
;; Reverses every pair of the relation.
(define revrel
  (lambda (rel)
    (cond
      ((null? rel) '())
      (else (cons (revpair (car rel))
                  (revrel (cdr rel)))))))

(define seconds
  (lambda (l)
    (cond
      ((null? l) '())
      (else (cons (second (car l)) (seconds (cdr l)))))))

;; fullfun?: rel -> bool
;; Is the relation one-to-one (no repeated seconds)?
(define fullfun?
  (lambda (fun)
    (set? (seconds fun))))
