# TLS Showcase

[English](README.md) | [中文](README.zh-CN.md)

*The Little Schemer*（Daniel P. Friedman 与 Matthias Felleisen 合著）一书代码示例的 DrRacket（Racket）实现。

*The Little Schemer* 通过苏格拉底式对话引导读者掌握递归思维。每一章在前一章的基础上递进，从基本的列表操作讲到 Y 组合子和 Scheme 解释器。本仓库包含各章关键函数的可运行 Racket 实现。

## 章节

| 文件 | 章节 | 主题 |
|------|------|------|
| `1.toys.rkt` | 1. Toys | 原子、列表、基本谓词（`atom?`） |
| `2.recursion.rkt` | 2. Do It, Do It Again, and Again, and Again... | `lat?`、`member?` |
| `3.cons.rkt` | 3. Cons the Magnificent | `rember`、`firsts`、`insertR`、`insertL`、`subst`、`multirember`、`multiinsertR`、`multiinsertL`、`multisubst` |
| `4.numbers.rkt` | 4. Numbers Games | 从零开始构建算术：`+`、`-`、`*`、`^`、`/`、`<`、`>`、`=`、`length`、`pick`、`rempick`、`occur` |
| `5.stars.rkt` | 5. *Oh My Gawd*: It's Full of Stars | 嵌套列表的递归操作：`rember*`、`insertR*`、`occur*`、`subst*`、`member*`、`leftmost`、`eqlist?`、`equal?` |
| `6.shadows.rkt` | 6. Shadows | 算术表达式与 `value`（前缀/中缀表示法求值器） |
| `7.relations.rkt` | 7. Friends and Relations | 集合与关系：`set?`、`makeset`、`subset?`、`eqset?`、`intersect?`、`intersect`、`union`、`intersectall`、`fun?`、`revrel`、`fullfun?` |
| `8.lambda.rkt` | 8. Lambda the Ultimate | 高阶函数与延续（continuation） |
| `9.again.rkt` | 9. ... and Again, and Again, and Again, ... | 停机问题与 Y 组合子 |
| `10.value.rkt` | 10. What Is the Value of All of This? | 构建 Scheme 解释器 |

> **注意：** 第 8、9、10 章在本仓库中为占位文件。

## 环境要求

- [Racket](https://racket-lang.org/) 7.0 或更高版本

## 使用方法

在 DrRacket 中打开任意 `.rkt` 文件，点击 **Run**（或按 F5）即可运行。部分文件依赖于前面的章节：

- `6.shadows.rkt` 依赖 `1.toys.rkt`
- `7.relations.rkt` 依赖 `2.recursion.rkt` 和 `3.cons.rkt`

使用 `provide` 导出的函数供后续章节调用。

## 关于《The Little Schemer》

*The Little Schemer*（MIT Press, 1996）是递归编程与计算机科学基础知识的经典入门读物。全书以师生对话形式编写，涵盖：

- 递归列表处理
- 从基本原理构建算术运算
- 高阶函数与延续
- 停机问题
- 用 Scheme 编写 Scheme 解释器

本书使用 Scheme 的一个子集。本仓库将代码适配为在现代 Racket 中以 `#lang racket` 运行。
