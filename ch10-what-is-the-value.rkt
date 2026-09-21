#lang racket

;; Chapter 10. What Is the Value of All of This?
;;
;; A Scheme interpreter in Scheme. The value of an expression
;; depends on a table (environment) of entries; dispatching on the
;; expression's shape routes it to one of six actions: *const,
;; *quote, *identifier, *lambda, *cond and *application. Closures
;; carry their defining table with them.

(provide new-entry lookup-in-entry extend-table lookup-in-table
         value meaning *const *quote *identifier *lambda *cond
         *application apply-closure atom-to-action list-to-action)

(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

;; An entry pairs a list of names with a list of values:
;;   ((appetizer entree dessert) (pate boeuf spumoni))
;; A table is a list of entries; lookup walks it back to front, so
;; inner scopes shadow outer ones.

(define build
  (lambda (s1 s2) (cons s1 (cons s2 '()))))

(define first
  (lambda (p) (car p)))

(define second
  (lambda (p) (car (cdr p))))

(define third
  (lambda (p) (car (cdr (cdr p)))))

(define new-entry build)

;; lookup-in-entry: name entry entry-f -> value
;; entry-f is the failure continuation, called with the name.
(define lookup-in-entry
  (lambda (name entry entry-f)
    (lookup-in-entry-help name
                          (first entry)
                          (second entry)
                          entry-f)))

(define lookup-in-entry-help
  (lambda (name names values entry-f)
    (cond
      ((null? names) (entry-f name))
      ((eq? name (car names)) (car values))
      (else (lookup-in-entry-help name
                                  (cdr names)
                                  (cdr values)
                                  entry-f)))))

(define extend-table cons)

;; lookup-in-table: name table table-f -> value
;; Note the lazily built continuation: only if the name is missing
;; from this entry do we try the rest of the table.
(define lookup-in-table
  (lambda (name table table-f)
    (cond
      ((null? table) (table-f name))
      (else
       (lookup-in-entry name
                        (car table)
                        (lambda (name)
                          (lookup-in-table name (cdr table) table-f)))))))

;; --- Dispatch -------------------------------------------------------

(define expression-to-action
  (lambda (e)
    (cond
      ((atom? e) (atom-to-action e))
      (else (list-to-action e)))))

(define atom-to-action
  (lambda (e)
    (cond
      ((number? e) *const)
      ((eq? e #t) *const)
      ((eq? e #f) *const)
      ((eq? e 'cons) *const)
      ((eq? e 'car) *const)
      ((eq? e 'cdr) *const)
      ((eq? e 'null?) *const)
      ((eq? e 'eq?) *const)
      ((eq? e 'atom?) *const)
      ((eq? e 'zero?) *const)
      ((eq? e 'add1) *const)
      ((eq? e 'sub1) *const)
      ((eq? e 'number?) *const)
      (else *identifier))))

(define list-to-action
  (lambda (e)
    (cond
      ((atom? (car e))
       (cond
         ((eq? (car e) 'quote) *quote)
         ((eq? (car e) 'lambda) *lambda)
         ((eq? (car e) 'cond) *cond)
         (else *application)))
      (else *application))))

;; --- The six actions -------------------------------------------------

;; value: expression -> value
;; Evaluate in the empty table.
(define value
  (lambda (e)
    (meaning e '())))

(define meaning
  (lambda (e table)
    ((expression-to-action e) e table)))

;; *const: numbers and booleans are themselves; primitive names are
;; tagged so `apply` can tell them from closures.
(define *const
  (lambda (e table)
    (cond
      ((number? e) e)
      ((eq? e #t) #t)
      ((eq? e #f) #f)
      (else (build 'primitive e)))))

;; *quote: (quote x) evaluates to x itself.
(define text-of second)

(define *quote
  (lambda (e table)
    (text-of e)))

;; *identifier: look the name up in the table.
;; initial-table fails loudly on unbound names.
(define *identifier
  (lambda (e table)
    (lookup-in-table e table initial-table)))

(define initial-table
  (lambda (name)
    (car '())))

;; *lambda: a closure is the formals and the body PAIRED WITH THE
;; TABLE WHERE THE LAMBDA WAS SEEN - that table is what makes
;; shadowing work later.
(define *lambda
  (lambda (e table)
    (build 'non-primitive (cons table (cdr e)))))

(define table-of first)
(define formals-of second)
(define body-of third)

;; *cond: evaluate questions until one is true or `else`.
(define *cond
  (lambda (e table)
    (evcon (cdr e) table)))

(define evcon
  (lambda (lines table)
    (cond
      ((else? (question-of (car lines)))
       (meaning (answer-of (car lines)) table))
      ((meaning (question-of (car lines)) table)
       (meaning (answer-of (car lines)) table))
      (else (evcon (cdr lines) table)))))

(define else?
  (lambda (x)
    (eq? x 'else)))

(define question-of first)
(define answer-of second)

;; *application: evaluate the operator and the operands, then apply.
(define *application
  (lambda (e table)
    (apply-meaning
     (meaning (function-of e) table)
     (evlis (arguments-of e) table))))

(define function-of car)
(define arguments-of cdr)

(define evlis
  (lambda (args table)
    (cond
      ((null? args) '())
      (else (cons (meaning (car args) table)
                  (evlis (cdr args) table))))))

;; apply-meaning: applies a primitive tag or a closure to the
;; evaluated arguments. (Named apply-meaning, not apply, to keep
;; Racket's apply available.)
(define apply-meaning
  (lambda (fun vals)
    (cond
      ((primitive? fun)
       (apply-primitive (second fun) vals))
      (else
       (apply-closure (second fun) vals)))))

(define primitive?
  (lambda (x)
    (eq? (car x) 'primitive)))

(define non-primitive?
  (lambda (x)
    (eq? (car x) 'non-primitive)))

(define apply-primitive
  (lambda (name vals)
    (cond
      ((eq? name 'cons) (cons (first vals) (second vals)))
      ((eq? name 'car) (car (first vals)))
      ((eq? name 'cdr) (cdr (first vals)))
      ((eq? name 'null?) (null? (first vals)))
      ((eq? name 'eq?) (eq? (first vals) (second vals)))
      ((eq? name 'atom?) (:atom? (first vals)))
      ((eq? name 'zero?) (zero? (first vals)))
      ((eq? name 'add1) (add1 (first vals)))
      ((eq? name 'sub1) (sub1 (first vals)))
      ((eq? name 'number?) (number? (first vals))))))

;; atom? inside the interpreted language must also accept closures
;; and primitives, which look like tagged lists.
(define :atom?
  (lambda (x)
    (cond
      ((atom? x) #t)
      ((null? x) #f)
      ((eq? (car x) 'primitive) #t)
      ((eq? (car x) 'non-primitive) #t)
      (else #f))))

(define apply-closure
  (lambda (closure vals)
    (meaning (body-of closure)
             (extend-table
              (new-entry (formals-of closure) vals)
              (table-of closure)))))
