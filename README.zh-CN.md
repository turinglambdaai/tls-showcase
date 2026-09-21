# 用 Racket 读 The Little Schemer

*The Little Schemer* 全部十章的完整可运行 Racket 实现——从 `lat?` 一路到 Y 组合子与 Scheme 解释器——由 204 个 rackunit 检查保证每个函数都经得起验证。

[![CI](https://github.com/turinglambdaai/tls-showcase/actions/workflows/ci.yml/badge.svg)](https://github.com/turinglambdaai/tls-showcase/actions/workflows/ci.yml) ![Racket](https://img.shields.io/badge/Racket-9F1D20?logo=racket&logoColor=white) [![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

[English](README.md) · **中文**

## 章节

| 文件 | 章节 | 你会遇到什么 |
|------|------|-------------|
| `ch01-toys.rkt` | 1. Toys | `atom?`、基础玩具、Car 与 Cdr 定律 |
| `ch02-recursion.rkt` | 2. Do It, Do It Again... | `lat?`、`member?`、第一戒律 |
| `ch03-cons-the-magnificent.rkt` | 3. Cons the Magnificent | `rember`、`firsts`、insert/subst 家族及其 `multi-` 变体 |
| `ch04-numbers-games.rkt` | 4. Numbers Games | 从 `zero?`/`add1`/`sub1` 重建 `+ - * / ^ < > =` |
| `ch05-oh-my-gawd.rkt` | 5. *Oh My Gawd*: It's Full of Stars | `rember*`、`subst*`、`member*`、`leftmost`、互递归的 `equal?`/`eqlist?` |
| `ch06-shadows.rkt` | 6. Shadows | `value` 求值器（先中缀后前缀）、记号（tally）数字 |
| `ch07-friends-and-relations.rkt` | 7. Friends and Relations | 集合与关系：`set?`、`makeset`、`union`、`intersect`、`fun?`、`revrel` |
| `ch08-lambda-the-ultimate.rkt` | 8. Lambda the Ultimate | 柯里化、`insert-g`（一个函数即四个函数）、CPS 收集器（`multirember&co`、`evens-only*&co`） |
| `ch09-and-again.rkt` | 9. ...and Again, and Again... | 部分函数（`looking`、`shuffle`）、Collatz、Ackermann、**Y 组合子**推导 |
| `ch10-what-is-the-value.rkt` | 10. What Is the Value of All of This? | **用 Scheme 写的 Scheme 解释器**：表（环境）、闭包、六个分发动作 |

每章都是独立文件，可单独打开运行；只有第 7 章按书中的方式复用第 2、3 章的函数。`test/` 目录与章节一一对应，把书上的经典例子钉死（`tup+` 保留较长元组的尾部了吗？`(shuffle '((a b) c))` 会终止吗？会）。

## 快速开始

```bash
git clone https://github.com/turinglambdaai/tls-showcase.git
cd tls-showcase
raco test .        # 运行全部 204 个检查
```

也可以在 DrRacket 里打开任意章节文件点 **Run**，然后在 REPL 里玩：

```racket
> (require "ch10-what-is-the-value.rkt")
> (value '((lambda (x) (cons x (quote ()))) 13))
'(13)
> (value '(cond ((atom? (quote a)) (quote yes)) (else (quote no))))
'yes
```

```racket
> (require "ch09-and-again.rkt")
> (length '(a b c d e))       ; 不用 define 的递归：Y 组合子推导
5
```

## 忠实度说明

- 定义均采用书中最终版本；有 bug 的中间草稿不保留，但凡"为什么"有教学价值处都以注释说明。
- 第 4 章刻意遮蔽 `+`、`-`、`*`、`/`、`<`、`>`、`=`、`length`——重建它们正是这一章的意义。测试文件以 `tls:` 前缀引用各章，两套算术可以并存。`zero?` **不**重定义：它是本章的原始件之一。
- 第 9 章只测试会终止的情形：`looking` 与 `shuffle` 存在永不返回的输入——这正是本章的主题。`will-stop?` 只以注释出现，因为它不可能被定义。
- 第 10 章求值一个小语言：数字、布尔、十个原语、`quote`、标识符、`lambda`、`cond` 与函数应用。闭包随身携带定义处的表，词法作用域与遮蔽都符合预期。

## 关于本书

*The Little Schemer*（Daniel P. Friedman 与 Matthias Felleisen 著，第 4 版，MIT Press）以苏格拉底式对话教授递归思维。本仓库是独立的伴读实现，与作者及出版方无关联——书本身篇幅不长、精彩且有版权：**先读书，再来这里跑代码**。

## 许可证

基于 [MIT License](LICENSE) 开源。
