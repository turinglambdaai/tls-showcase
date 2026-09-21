# The Little Schemer, in Racket

Complete, runnable Racket implementations of **all ten chapters** of *The Little Schemer* — from `lat?` to the Y combinator and a Scheme interpreter — with 204 rackunit checks keeping every function honest.

[![CI](https://github.com/turinglambdaai/tls-showcase/actions/workflows/ci.yml/badge.svg)](https://github.com/turinglambdaai/tls-showcase/actions/workflows/ci.yml) ![Racket](https://img.shields.io/badge/Racket-9F1D20?logo=racket&logoColor=white) [![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

**English** · [中文](README.zh-CN.md)

## Chapters

| File | Chapter | What you meet |
|------|---------|---------------|
| `ch01-toys.rkt` | 1. Toys | `atom?`, the primitive toys, The Laws of Car and Cdr |
| `ch02-recursion.rkt` | 2. Do It, Do It Again... | `lat?`, `member?`, the First Commandment |
| `ch03-cons-the-magnificent.rkt` | 3. Cons the Magnificent | `rember`, `firsts`, insert/subst family and their `multi-` variants |
| `ch04-numbers-games.rkt` | 4. Numbers Games | `+ - * / ^ < > =` rebuilt from `zero?`/`add1`/`sub1` |
| `ch05-oh-my-gawd.rkt` | 5. *Oh My Gawd*: It's Full of Stars | `rember*`, `subst*`, `member*`, `leftmost`, `equal?`/`eqlist?` by mutual recursion |
| `ch06-shadows.rkt` | 6. Shadows | the `value` evaluator (infix, then prefix with selectors), numbers as tallies |
| `ch07-friends-and-relations.rkt` | 7. Friends and Relations | sets and relations: `set?`, `makeset`, `union`, `intersect`, `fun?`, `revrel` |
| `ch08-lambda-the-ultimate.rkt` | 8. Lambda the Ultimate | currying, `insert-g` (four functions in one), CPS collectors (`multirember&co`, `evens-only*&co`) |
| `ch09-and-again.rkt` | 9. ...and Again, and Again... | partial functions (`looking`, `shuffle`), Collatz, Ackermann, the **Y combinator** derivation |
| `ch10-what-is-the-value.rkt` | 10. What Is the Value of All of This? | a **Scheme interpreter in Scheme**: tables, closures, six dispatch actions |

Each chapter is a standalone file you can open and run on its own; only Chapter 7 builds on Chapters 2 and 3, the way the book does. The `test/` directory mirrors the chapters one-to-one and pins down the book's classic examples (did `tup+` keep the longer tuple's tail? does `(shuffle '((a b) c))` terminate? yes it does).

## Quick start

```bash
git clone https://github.com/turinglambdaai/tls-showcase.git
cd tls-showcase
raco test .        # run all 204 checks
```

Or open any chapter file in DrRacket and hit **Run**, then play in the REPL:

```racket
> (require "ch10-what-is-the-value.rkt")
> (value '((lambda (x) (cons x (quote ()))) 13))
'(13)
> (value '(cond ((atom? (quote a)) (quote yes)) (else (quote no))))
'yes
```

```racket
> (require "ch09-and-again.rkt")
> (length '(a b c d e))       ; recursion without define: the Y derivation
5
```

## Notes on fidelity

- Definitions follow the book's final versions; buggy intermediate drafts are left out, with a comment whenever the interesting *why* would be lost.
- Chapter 4 deliberately shadows `+`, `-`, `*`, `/`, `<`, `>`, `=`, `length` — rebuilding them is the chapter's whole point. Test files import chapters with a `tls:` prefix so both versions stay usable side by side. `zero?` is *not* redefined: it is one of the chapter's primitives.
- Chapter 9 tests only the terminating cases: `looking` and `shuffle` have inputs on which they never return — that is precisely the chapter's subject. `will-stop?` appears only as a comment, because it cannot exist.
- Chapter 10 evaluates a small language: numbers, booleans, the ten primitives, `quote`, identifiers, `lambda`, `cond` and applications. Closures carry their defining table, so lexical scoping and shadowing work as expected.

## About the book

*The Little Schemer* (Daniel P. Friedman & Matthias Felleisen, 4th ed., MIT Press) teaches recursive thinking through Socratic dialogue. This repository is an independent companion, not affiliated with the authors or the publisher — the book is short, wonderful, and copyrighted: **read it, then come here to run things.**

## License

Licensed under the [MIT License](LICENSE).
