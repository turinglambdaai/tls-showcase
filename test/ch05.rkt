#lang racket

;; Tests for Chapter 5. *Oh My Gawd*: It's Full of Stars

(require rackunit
         (prefix-in tls: "../ch05-oh-my-gawd.rkt"))

(check-equal?
 (tls:rember* 'cup '((coffee) cup ((tea) cup) (and (hickory) cup)))
 '((coffee) ((tea)) (and (hickory))))

(check-equal?
 (tls:insertR* 'roast 'chuck
               '((how much (wood)) could ((a) (chuck)) chuck (((wood))) chuck))
 '((how much (wood)) could ((a) (chuck roast)) chuck roast (((wood))) chuck roast))

(check-equal? (tls:insertL* 'x 'a '((a) (b (a c))))
              '((x a) (b (x a c))))

(check-equal?
 (tls:occur* 'banana
             '((banana)
               (split ((((banana ice))) (cream (banana)) sherbet))
               (banana)
               (bread)
               (banana brandy)))
 5)

(check-equal?
 (tls:subst* 'orange 'banana
             '((banana)
               (split ((((banana ice))) (cream (banana)) sherbet))
               (banana)
               (bread)
               (banana brandy)))
 '((orange)
   (split ((((orange ice))) (cream (orange)) sherbet))
   (orange)
   (bread)
   (orange brandy)))

(check-true  (tls:member* 'chips '((potato) (chips ((with) fish) (chips)))))
(check-false (tls:member* 'fish '()))

(check-equal? (tls:leftmost '((hot dogs) (and) (hamburger))) 'hot)
(check-equal? (tls:leftmost '(((a) b) c)) 'a)

(check-true  (tls:eqan? 'a 'a))
(check-true  (tls:eqan? 1 1))
(check-false (tls:eqan? 'a 1))

(check-true  (tls:equal? 'a 'a))
(check-true  (tls:equal? '(a (b c)) '(a (b c))))
(check-false (tls:equal? '(a b) '(a (b))))
(check-false (tls:equal? '(1 2) '(1 2 3)))

(check-true  (tls:eqlist? '(a b c) '(a b c)))
(check-false (tls:eqlist? '(a b) '(a b c)))
(check-true  (tls:eqlist? '() '()))

(check-equal? (tls:rember '(pop corn) '(lemonade (pop corn) and (cake)))
              '(lemonade and (cake)))
