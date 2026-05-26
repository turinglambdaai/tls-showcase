# TLS Showcase

[English](README.md) | [中文](README.zh-CN.md)

Code examples from *The Little Schemer* by Daniel P. Friedman and Matthias Felleisen, implemented in DrRacket (Racket).

*The Little Schemer* introduces recursive thinking through a series of Socratic dialogues. Each chapter builds on the previous one, guiding the reader from basic list operations to the Y combinator and a Scheme interpreter. This repository contains runnable Racket implementations of the key functions from each chapter.

## Chapters

| File | Chapter | Topic |
|------|---------|-------|
| `1.toys.rkt` | 1. Toys | Atoms, lists, basic predicates (`atom?`) |
| `2.recursion.rkt` | 2. Do It, Do It Again, and Again, and Again... | `lat?`, `member?` |
| `3.cons.rkt` | 3. Cons the Magnificent | `rember`, `firsts`, `insertR`, `insertL`, `subst`, `multirember`, `multiinsertR`, `multiinsertL`, `multisubst` |
| `4.numbers.rkt` | 4. Numbers Games | Arithmetic from scratch: `+`, `-`, `*`, `^`, `/`, `<`, `>`, `=`, `length`, `pick`, `rempick`, `occur` |
| `5.stars.rkt` | 5. *Oh My Gawd*: It's Full of Stars | Recursive operations on nested lists: `rember*`, `insertR*`, `occur*`, `subst*`, `member*`, `leftmost`, `eqlist?`, `equal?` |
| `6.shadows.rkt` | 6. Shadows | Arithmetic expressions and `value` (an evaluator for prefix/infix notation) |
| `7.relations.rkt` | 7. Friends and Relations | Sets and relations: `set?`, `makeset`, `subset?`, `eqset?`, `intersect?`, `intersect`, `union`, `intersectall`, `fun?`, `revrel`, `fullfun?` |
| `8.lambda.rkt` | 8. Lambda the Ultimate | Higher-order functions and continuations |
| `9.again.rkt` | 9. ... and Again, and Again, and Again, ... | The halting problem and the Y combinator |
| `10.value.rkt` | 10. What Is the Value of All of This? | Building a Scheme interpreter |

> **Note:** Chapters 8, 9, and 10 are placeholders in this repository.

## Requirements

- [Racket](https://racket-lang.org/) 7.0 or later

## Usage

Open any `.rkt` file in DrRacket and click **Run** (or press F5). Some files depend on earlier chapters:

- `6.shadows.rkt` requires `1.toys.rkt`
- `7.relations.rkt` requires `2.recursion.rkt` and `3.cons.rkt`

Functions marked with `provide` are exported for use in later chapters.

## About The Little Schemer

*The Little Schemer* (MIT Press, 1996) is a classic introduction to recursive programming and computer science fundamentals. Written as a dialogue between a teacher and a student, it covers:

- Recursive list processing
- Building arithmetic from first principles
- Higher-order functions and continuations
- The halting problem
- Writing a Scheme interpreter in Scheme

The book uses a subset of Scheme. This repository adapts the code to run in modern Racket with `#lang racket`.
