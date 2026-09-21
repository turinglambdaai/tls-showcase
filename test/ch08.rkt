#lang racket

;; Tests for Chapter 8. Lambda the Ultimate

(require rackunit
         (prefix-in tls: "../ch08-lambda-the-ultimate.rkt"))

;; The curried rember takes the equality test first.
(check-equal? ((tls:rember-f =) 5 '(6 2 5 3)) '(6 2 3))
(check-equal? ((tls:rember-f eq?) 'jelly '(jelly beans are good))
              '(beans are good))
(check-equal? ((tls:rember-f equal?) '(pop corn)
               '(lemonade (pop corn) and (cake)))
              '(lemonade and (cake)))

;; The adapter eq?-c specialises eq? by pre-binding one argument.
(check-true  ((tls:eq?-c 'salad) 'salad))
(check-false ((tls:eq?-c 'salad) 'tuna))

(check-equal? ((tls:insertL-f eq?) 'hello 'there '(there matt))
              '(hello there matt))
(check-equal? ((tls:insertR-f eq?) 'there 'hello '(hello matt))
              '(hello there matt))

;; insertL, insertR, subst and rember are one function: insert-g.
(check-equal? (tls:insertL 'x 'y '(a y b)) '(a x y b))
(check-equal? (tls:insertR 'x 'y '(a y b)) '(a y x b))
(check-equal? (tls:subst 'n 'o '(o a o)) '(n a n))
(check-equal? (tls:rember 'b '(a b c)) '(a c))

;; value, dispatched through atom-to-function (prefix expressions).
(check-equal? (tls:value '(+ 1 3)) 4)
(check-equal? (tls:value '(* 2 (+ 1 3))) 8)
(check-equal? (tls:value '(^ 2 3)) 8)

(check-equal? ((tls:multirember-f eq?) 'tuna '(tuna salad tuna is good))
              '(salad is good))
(check-equal? (tls:multiremberT (lambda (x) (eq? x 'tuna))
                                '(tuna salad tuna))
              '(salad))

;; Collectors: the continuation receives both partitions.
(check-true  (tls:multirember&co 'tuna '() tls:a-friend))
(check-false (tls:multirember&co 'tuna '(and tuna) tls:a-friend))
(check-false (tls:multirember&co 'tuna '(strawberries tuna and swordfish)
                                 tls:a-friend))
(check-equal? (tls:multirember&co 'tuna '(strawberries tuna and swordfish)
                                  tls:last-friend)
              3)

;; The collector receives the new lat and both insertion counts.
(check-equal?
 (tls:multiinsertLR&co 'x 'a 'b '(a b c b) list)
 '((x a b x c b x) 1 2))

(check-equal?
 (tls:evens-only* '((9 1 2 8) 3 10 ((9 9) 7 6) 2))
 '((2 8) 10 (() 6) 2))

;; sum of odds = 38, product of evens = 1920, then the even tree.
(check-equal?
 (tls:evens-only*&co '((9 1 2 8) 3 10 ((9 9) 7 6) 2) tls:the-last-friend)
 '(38 1920 (2 8) 10 (() 6) 2))
