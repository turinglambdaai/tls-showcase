#lang racket

;; Tests for Chapter 7. Friends and Relations

(require rackunit
         (prefix-in tls: "../ch07-friends-and-relations.rkt"))

(check-true  (tls:set? '(a b c)))
(check-true  (tls:set? '()))
(check-false (tls:set? '(a b a)))

(check-equal? (tls:makeset '(apple peach pear peach plum apple lemon))
              '(apple peach pear plum lemon))

(check-true  (tls:subset? '(5 chicken wings)
                          '(5 hamburgers 2 pieces fried chicken and light duckling wings)))
(check-false (tls:subset? '(4 wings) '(5 hamburgers 2 pieces fried chicken)))

(check-true  (tls:eqset? '(a b c) '(c b a)))
(check-false (tls:eqset? '(a b c) '(a b)))

(check-true  (tls:intersect? '(stewed tomatoes and macaroni)
                             '(macaroni and cheese)))
(check-false (tls:intersect? '(a b) '(c d)))

(check-equal? (tls:intersect '(a b c d e) '(b d f)) '(b d))
(check-equal? (tls:union '(a b c) '(c d e)) '(a b c d e))

(check-equal? (tls:intersectall '((a b c) (b c d e) (c d e))) '(c))
(check-equal? (tls:intersectall '((plums) (plums))) '(plums))

(check-true  (tls:a-pair? '(a b)))
(check-true  (tls:a-pair? '((a b) c)))
(check-false (tls:a-pair? '(a b c)))
(check-false (tls:a-pair? '(a)))
(check-false (tls:a-pair? 'atom))

(check-equal? (tls:build 'a 'b) '(a b))
(check-equal? (tls:first '(a b)) 'a)
(check-equal? (tls:second '(a b)) 'b)

(check-true  (tls:fun? '((a 1) (b 2))))
(check-false (tls:fun? '((a 1) (b 2) (a 3))))

(check-equal? (tls:revrel '((a 1) (b 2))) '((1 a) (2 b)))

(check-true  (tls:fullfun? '((a 1) (b 2))))
(check-false (tls:fullfun? '((a 1) (b 1))))
