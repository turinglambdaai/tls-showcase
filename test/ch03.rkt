#lang racket

;; Tests for Chapter 3. Cons the Magnificent

(require rackunit
         (prefix-in tls: "../ch03-cons-the-magnificent.rkt"))

(check-equal? (tls:rember 'mint '(lamb chops and mint jelly))
              '(lamb chops and jelly))
(check-equal? (tls:rember 'mint '(lamb chops and mint flavored mint jelly))
              '(lamb chops and flavored mint jelly))
(check-equal? (tls:rember 'toast '(bacon lettuce and tomato))
              '(bacon lettuce and tomato))

(check-equal? (tls:firsts '((a b) (c d) (e f)))
              '(a c e))
(check-equal? (tls:firsts '())
              '())
(check-equal? (tls:firsts '((five plums) (four) (eleven green oranges)))
              '(five four eleven))

(check-equal? (tls:insertR 'jalapeno 'and '(tacos tamales and salsa))
              '(tacos tamales and jalapeno salsa))
(check-equal? (tls:insertL 'x 'y '(a y b))
              '(a x y b))
(check-equal? (tls:insertL 'topping 'fudge '(ice cream with fudge for dessert))
              '(ice cream with topping fudge for dessert))

(check-equal? (tls:subst 'banana 'fig '(fig newton fig))
              '(banana newton fig))
(check-equal? (tls:subst2 'vanilla 'chocolate 'banana
                          '(banana ice with chocolate topping))
              '(vanilla ice with chocolate topping))

(check-equal? (tls:multirember 'cup '(coffee cup tea cup and cup hickory))
              '(coffee tea and hickory))
(check-equal? (tls:multiinsertR 'x 'b '(a b c b))
              '(a b x c b x))
(check-equal? (tls:multiinsertL 'x 'b '(a b c b))
              '(a x b c x b))
(check-equal? (tls:multisubst 'x 'b '(a b c b))
              '(a x c x))
