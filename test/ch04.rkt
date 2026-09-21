#lang racket

;; Tests for Chapter 4. Numbers Games
;; The prefixed names (tls:+ ...) are the arithmetic rebuilt here,
;; not Racket's.

(require rackunit
         (prefix-in tls: "../ch04-numbers-games.rkt"))

(check-equal? (tls:+ 3 4) 7)
(check-equal? (tls:+ 46 12) 58)
(check-equal? (tls:- 12 4) 8)
(check-equal? (tls:- 12 12) 0)
(check-equal? (tls:* 3 4) 12)
(check-equal? (tls:* 12 3) 36)
(check-equal? (tls:^ 2 3) 8)
(check-equal? (tls:^ 5 1) 5)
(check-equal? (tls:/ 15 4) 3)
(check-equal? (tls:/ 3 4) 0)

(check-equal? (tls:addtup '(3 5 2 8)) 18)
(check-equal? (tls:addtup '()) 0)
(check-equal? (tls:tup+ '(3 7) '(4 6)) '(7 13))
(check-equal? (tls:tup+ '(3 7 8) '(4 6)) '(7 13 8))
(check-equal? (tls:tup+ '(3 7) '(4 6 8 1)) '(7 13 8 1))

(check-true  (tls:< 2 5))
(check-false (tls:< 5 2))
(check-false (tls:< 3 3))
(check-true  (tls:> 5 2))
(check-false (tls:> 2 5))
(check-false (tls:> 3 3))
(check-true  (tls:= 4 4))
(check-false (tls:= 4 5))

(check-equal? (tls:length '(hot dogs with mustard)) 4)
(check-equal? (tls:length '()) 0)

(check-equal? (tls:pick 4 '(lasagna spaghetti ravioli macaroni meatball))
              'macaroni)
(check-equal? (tls:rempick 3 '(lasagna spaghetti ravioli macaroni meatball))
              '(lasagna spaghetti macaroni meatball))

(check-equal? (tls:no-nums '(5 pears 6 prunes 9 dates))
              '(pears prunes dates))
(check-equal? (tls:all-nums '(5 pears 6 prunes 9 dates))
              '(5 6 9))

(check-true  (tls:eqan? 3 3))
(check-true  (tls:eqan? 'a 'a))
(check-false (tls:eqan? 3 'a))
(check-false (tls:eqan? 3 4))

(check-equal? (tls:occur 'x '(a x b x c x x d)) 4)
(check-equal? (tls:occur 'x '()) 0)

(check-true  (tls:one? 1))
(check-false (tls:one? 0))
(check-false (tls:one? 2))
