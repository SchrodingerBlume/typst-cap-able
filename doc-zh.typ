// ============================================================
// cap-able 包文档 (cap-able Package Documentation)
// ============================================================
//
// 本文件是 cap-able 包的完整文档，使用 mantys 模板排版，
// 并通过 tidy 自动从源码文档字符串生成 API 参考。
//
// This file is the complete documentation for cap-able,
// typeset with the mantys template and auto-generated API
// reference via tidy from source docstrings.
//
// 编译方式：
//   typst compile doc.typ
//
// ============================================================

#import "@preview/tidy:0.4.3"
#import "@preview/mantys:1.0.2": *
#import "cap-able/0.0.1/lib.typ": *

// ============================================================
// 文档元数据
// ============================================================

#show: mantys(
  name: "cap-able",
  version: "0.0.1",
  authors: (
    "Schrödinger Blume",
  ),
  license: "MIT",
  description: "一个功能完善的 Typst 包，用于在学术文档中创建专业的三线表和图表，支持双语题注、续表/续图、子图以及灵活的自定义选项。",
  repository: "https://github.com/SchrodingerBlume/typst-cap-able",

  title: "cap-able",
  subtitle: "让 Typst 更能（able）处理题注（caption）
  —— 这就叫做有能力（cap-able）",
  date: datetime.today(),

  abstract: [
    *`cap-able`* 是一个专为学术文档设计的 Typst 宏包，提供以下核心功能：

    - *三线表* — 符合学术规范的三线表格（顶线、中线、底线）
    - *双语标题* — 自动排版双语标题（中英、德英等任意语言/英语组合）
    - *续表/续图* — 跨页表格和图片，自动继承原始编号
    - *子图布局* — 灵活的多图网格排列，支持覆盖标签和子标题
    - *表注/图注* — 自动宽度匹配的注释文字
    - *多语言支持* — 25+ 种语言（含 RTL 语言）的本地化文本
    - *统一配置系统* — 通过 `cap-style` 同时配置表与图，或用 `captab-style` / `capfig-style` 单独覆盖

    本包特别适合需要专业排版和多语言支持的学术论文、毕业论文和技术报告。
  ],
)

#set par(first-line-indent: (amount: 2em, all: true))

// ============================================================
// 第一章：简介
// ============================================================
#set text(font:("Noto Serif CJK SC", "Devanagari Sangam MN"))
#show raw: set text(font: "LXGW WenKai Mono")

// mantys 的 show ref 规则对普通 figure（kind: image/table）走入分支后无输出，
// 导致 @fig:xxx 变成空白。此处为这类引用恢复默认 link 行为。
#show ref: it => {
  if it.element != none and it.element.func() == figure and it.element.kind not in ("cmd", "arg", "type") {
    let loc = it.element.location()
    let num = numbering(
      it.element.numbering,
      ..counter(figure.where(kind: it.element.kind)).at(loc),
    )
    link(loc, [#it.element.supplement #num])
  } else {
    it
  }
}

= 简介

*`cap-able`* 为 Typst 带来了专业的表格和图片处理能力，遵循学术出版规范和最佳实践。

包名 "`cap-able`" 是 "caption"（标题）和 "able"（能力）的双关语——让你的文档更有能力处理复杂的标题，非常 capable（有能力）！

== 设计理念

本包遵循以下设计原则：

+ *声明式配置*：在文档开头配置一次，处处生效
+ *合理默认值*：最少配置即可开箱即用
+ *语言感知*：根据文档语言自动调整格式
+ *学术标准*：遵循学术出版的成熟规范

== 依赖

本包运行时依赖：

- ```typ @preview/tablem:0.3.0``` — Markdown 风格的表格语法支持

文档生成依赖（仅用于编译本文档）：

- ```typ @preview/tidy:0.4.3``` — 从文档字符串自动生成 API 参考
- ```typ @preview/mantys:1.0.2``` — 文档模板

// ============================================================
// 第二章：安装
// ============================================================
= 安装

== 从 Typst Universe 安装

发布到 Typst Universe 后，可直接导入：

```typst
#import "@preview/cap-able:0.0.1": *
```

== 手动安装

从仓库下载文件后：

+ 将 `cap-able` 文件夹放入项目目录
+ 使用相对路径导入

```typst
#import "cap-able/0.0.1/lib.typ": *
```

// ============================================================
// 第三章：快速入门
// ============================================================
= 快速入门

本章通过最常见的用例快速展示核心功能。

== 基础三线表

最简单的用法是使用 Markdown 风格语法创建表格：

```typst
#captab(
  caption: [样本数据],
)[
  | 姓名 | 年龄 | 分数 |
  | ---- | ---- | ---- |
  | 张三 | 25   | 95   |
  | 李四 | 30   | 87   |
]
```

#captab(
  caption: [样本数据],
)[
  | 姓名 | 年龄 | 分数 |
  | -----| ---- | ---- |
  | 张三 | 25   | 95   |
  | 李四 | 30   | 87   |
]

表格自动具有以下特征：
- 占满文本宽度
- 1.5 磅顶线
- 表头下方 0.5 磅中线
- 1.5 磅底线
- 内容居中，间距合理

== 基础图片

创建图片同样简单：

```typst
#capfig(
  rect(width: 15%, height: 1.15cm, fill: blue.lighten(80%)),
  caption: [一个简单矩形],
)
```

#capfig(
  rect(width: 15%, height: 1.15cm, fill: blue.lighten(80%)),
  caption: [一个简单矩形],
)

== 双语标题

对于需要双语标题的文档，只需添加 `caption-en` 参数：

```typst
#set text(lang: "zh") // 必须设置文档为非英语语言

#captab(
  caption: [实验参数],
  caption-en: [Experimental Parameters],
)[
  | 参数名 | 数值 | 单位 |
  | ------ | ---- | ---- |
  | 温度   | 25   | ℃   |
  | 气压   | 1    | atm  |
]
```

#set text(lang: "zh")

#captab(
  caption: [实验参数],
  caption-en: [Experimental Parameters],
)[
  | 参数名 | 数值 | 单位 |
  | ------ | ---- | ---- |
  | 温度   | 25   | ℃   |
  | 气压   | 1    | atm  |
]

#set text(lang: "en")

本包会自动：
- 检测文档语言
- 以该语言格式化主标题
- 当 `enable-english-caption: true` 时，在下方添加英文副标题

注意：当文档语言为英文（`#set text(lang: "en")`）时，若同时提供了 `caption` 和 `caption-en`，则只显示 `caption-en` 的内容作为单语标题，`caption` 会被忽略——因为此时文档本身就是英文，无需双语。

// ============================================================
// 第四章：表格详解
// ============================================================
= 表格详解

== 表格语法

`captab` 使用 `tablem` 包解析 Markdown 风格的表格语法，无需繁琐的 Typst 原生语法。


=== 基础语法

```
#captab(
  caption: [基础语法示例],
)[
  | 表头1   | 表头2   | 表头3   |
  | ------- | ------- | ------- |
  | 单元格1 | 单元格2 | 单元格3 |
  | 单元格4 | 单元格5 | 单元格6 |
]
```

#captab(
  caption: [基础语法示例],
)[
  | 表头1   | 表头2   | 表头3   |
  | ------- | ------- | ------- |
  | 单元格1 | 单元格2 | 单元格3 |
  | 单元格4 | 单元格5 | 单元格6 |
]

#captnote[注：分隔行（`| --- |`）用于标记表头与表体的分界线。]

=== 列对齐

通过分隔行中的冒号控制对齐方式：

```
  | 左对齐 | 居中    | 右对齐 |
  | :----- | :-----: | -----: |
  | L      | C       | R      |
```

#captab(
  caption: [列对齐示例],
)[
  | 左对齐 | 居中    | 右对齐 |
  | :----- | :-----: | -----: |
  | L      | C       | R      |
]

#pagebreak()

=== 单元格合并

- 使用 `<` 与左侧单元格合并（横向合并）
- 使用 `^` 与上方单元格合并（纵向合并）

```
| A    | B    |
| ---- | ---- |
| 横跨 | <    |
| C    | 纵跨 |
| D    | ^    |
```

#captab(
  caption: [单元格合并示例],
)[
  | A    | B    |
  | ---- | ---- |
  | 横跨 | <    |
  | C    | 纵跨 |
  | D    | ^    |
]

== 列宽配置

通过 `cols` 参数自定义列宽。

*列宽规则：*

- 不指定 `cols`（自动模式）：各列按内容自适应，内容过长时可能溢出文本区。
- 仅绝对单位（如 `cm`、`pt`）：表格宽度为各列之和，可能窄于或超出文本区。
- 含 `fr` 单位：表格按比例展开至文本区宽度。`fr` 与绝对单位可以混用——绝对列先占据固定宽度，剩余空间再按 `fr` 比例分配。

`cols` 参数接受一个长度数组，例如：
```typst
  cols: (8cm, 2cm, 2cm)       // 绝对单位
  cols: (3fr, 1fr, 1fr)       // 相对单位
  cols: (3fr, 2cm, 1fr)       // 混用
```

=== *自动模式 `cols: ()`*

#captab(
  caption: [自动列宽],
)[
  | 描述 | 数值 | 单位 |
  | ---- | ---- | ---- |
  | 很长很长、真的真的、特别特别长的描述文字 | 42 | m/s |
]

=== 绝对单位 `cols: (8cm, 3cm, 2cm)`

#captab(
  cols: (8cm, 3cm, 2cm),
  caption: [绝对列宽],
)[
  | 描述 | 数值 | 单位 |
  | ---- | ---- | ---- |
  | 很长很长、真的真的、特别特别长的描述文字 | 42 | m/s |
]

=== fr 单位 `cols: (3fr, 1fr, 1fr)` ——第一列是其他列宽度的三倍

#captab(
  cols: (3fr, 1fr, 1fr),
  caption: [比例列宽],
)[
  | 描述 | 数值 | 单位 |
  | ---- | ---- | ---- |
  | 很长很长、真的真的、特别特别长的描述文字 | 42 | m/s |
]

=== 混用 `cols: (5fr, 3cm, 1fr)`——数值列固定 3cm，描述列与单位列按 5:1 分配剩余宽度

#captab(
  cols: (5fr, 3cm, 1fr),
  caption: [混用列宽],
)[
| 描述 | 数值 | 单位 |
  | ---- | ---- | ---- |
  | 很长很长、真的真的、特别特别长的描述文字 | 42 | m/s |
]

== 额外线条

对于复杂表格，可添加额外的横线或竖线：

```typst
#captab(
  hlines: ((row: 3, stroke: 1pt),),   // 在第3行后添加 1 磅横线
  vlines: ((col: 1, start: 1),),      // 在第1列右侧添加竖线（从第1行起）
  caption: [含额外线条的表格],
)[...]
```

#captab(
  hlines: ((row: 3, stroke: 1pt),),
  vlines: ((col: 1, start: 1),),
  caption: [含额外线条的表格],
)[
  | A | B | C |
  | - | - | - |
  | 1 | 2 | 3 |
  | 4 | 5 | 6 |
  | 7 | 8 | 9 |
]

#pagebreak()

== 表注

在表格下方添加注释文字：

```typst
#captab(caption: [统计结果])[
  | 变量 | 均值  | SD  |
  | ---- | ----- | --- |
  | X    | 3.2\* | 0.5 |
  | Y    | 4.1   | 0.8 |
]
#captnote[
  注：$\*p < 0.05$；SD 代表标准差。
]
```

#captab(caption: [统计结果])[
  | 变量 | 均值  | SD  |
  | ---- | ----- | --- |
  | X    | 3.2\* | 0.5 |
  | Y    | 4.1   | 0.8 |
]
#captnote[
  注：$\*p < 0.05$；SD 代表标准差。
]


== 续表

对于跨页表格，使用 `refer-to` 参数引用原表：

```typst
#set text(lang: "zh")

// 原表
#captab(
  caption: [长数据表],
  caption-en: [Long Data Table],
  label: <tab:long>,        // 设置标签，供续表引用
)[...]

// 续表
#captab(
  caption: [长数据表],        // 可提供相同标题，也可省略
  caption-en: [Long Data Table],
  refer-to: <tab:long>,       // 引用原表获取编号
)[...]
```

#set text(lang: "zh")

#captab(
  caption: [长数据表],
  caption-en: [Long Data Table],
  label: <tab:long>,
)[
  | ID | 数值 |
  | -- | ---- |
  | 1  | 100  |
]

#captab(
  caption: [长数据表],
  caption-en: [Long Data Table],
  refer-to: <tab:long>,
)[
  | ID | 数值 |
  | -- | ---- |
  | 2  | 200  |
]

#set text(lang: "en")

续表会自动：

- 使用与原表相同的编号
- 添加"续表X"或"表X（续）"前缀/后缀
- 不在目录中新建条目

=== 续表模式

通过 `continued-mode` 参数控制续表样式：

- `"prefix"`（默认）：前缀模式，如"续表1"
- `"suffix"`：后缀模式，如"表1（续）"

// ============================================================
// 第五章：图片详解
// ============================================================
= 图片详解

== 单图片

使用 `capfig` 创建带双语标题的单个图片：

```typst
#set text(lang: "zh")
#capfig(
  image("example.png", width: 30%),
  caption: [Typst 图标],
  caption-en: [Typst Logo],
  label: <fig:typst-logo>,
)
```

#set text(lang: "zh")
#capfig(
  image("example.png", width: 30%),
  caption: [Typst 图标],
  caption-en: [Typst Logo],
  label: <fig:typst-logo>,
)

#set text(lang: "en")

== 子图

`capsubfig` 函数创建多图并排布局：


```typst
#set text(lang: "zh")
#capsubfig(
  (
    (content: rect(width: 3cm, height: 2cm, fill: red.lighten(70%)),
     subcaption: [红色]),
    (content: rect(width: 3cm, height: 2cm, fill: green.lighten(70%)),
     subcaption: [绿色]),
    (content: rect(width: 3cm, height: 2cm, fill: blue.lighten(70%)),
     subcaption: [蓝色]),
  ),
  columns: 3,
  show-subcaption: true,        // 显示子标题
  caption: [颜色对比],
  caption-en: [Color Comparison],
)
```

#set text(lang: "zh")
#capsubfig(
  (
    (content: rect(width: 3cm, height: 2cm, fill: red.lighten(70%)),
     subcaption: [红色]),
    (content: rect(width: 3cm, height: 2cm, fill: green.lighten(70%)),
     subcaption: [绿色]),
    (content: rect(width: 3cm, height: 2cm, fill: blue.lighten(70%)),
     subcaption: [蓝色]),
  ),
  columns: 3,
  show-subcaption: true,        // 显示子标题
  caption: [颜色对比],
  caption-en: [Color Comparison],
)
#set text(lang: "en")

== 覆盖标签

使用覆盖标签模式可以在图片上直接叠加 (a)、(b) 等标签，视觉更简洁：

```typst
#capsubfig(
  (
    (content: rect(width: 4cm, height: 3cm, fill: orange.lighten(70%))),
    (content: rect(width: 4cm, height: 3cm, fill: purple.lighten(70%))),
  ),
  columns: 2,
  caption: [覆盖标签示例],
  label-mode: "overlay",        // 启用覆盖模式
  label-style: "(a)",           // 标签样式
  label-bg: white.transparentize(20%),  // 半透明白色背景
  label-offset: (5pt, 5pt),     // 从左上角计算偏移值
)
```

#capsubfig(
  (
    (content: rect(width: 4cm, height: 3cm, fill: orange.lighten(70%))),
    (content: rect(width: 4cm, height: 3cm, fill: purple.lighten(70%))),
  ),
  columns: 2,
  caption: [覆盖标签示例],
  label-mode: "overlay",        // 启用覆盖模式
  label-style: "(a)",           // 标签样式
  label-bg: white.transparentize(20%),  // 半透明白色背景
  label-offset: (5pt, 5pt),     // 从左上角计算偏移值
)


=== 标签样式参考

`label-style` 参数支持多种格式：

#table(
  columns: (1fr, 1fr, 1fr),
  stroke: none,
  inset: 6pt,
  table.hline(stroke: 1.5pt),
  table.header[*样式*][*示例*][*描述*],
  table.hline(stroke: 0.5pt),
  [`"(a)"`], [(a), (b), (c)], [括号小写字母],
  [`"(A)"`], [(A), (B), (C)], [括号大写字母],
  [`"(1)"`], [(1), (2), (3)], [括号数字],
  [`"(i)"`], [(i), (ii), (iii)], [括号小写罗马数字],
  [`"(I)"`], [(I), (II), (III)], [括号大写罗马数字],
  [`"a)"`], [a), b), c)], [仅后括号],
  [`"图a"`], [图a, 图b, 图c], [中文前缀],
  [`"Fig. A"`], [Fig. A, Fig. B], [英文前缀],
  table.hline(stroke: 1.5pt),
)

== 子图交叉引用

为每个子图设置 `label` 后，可通过 `@` 语法引用：

```typst
#capsubfig(
  (
    (content: rect(fill: gray), label: <fig:sub-a>),
    (content: rect(fill: gray), label: <fig:sub-b>),
  ),
  label-mode: "overlay",
  caption: [子图引用示例],
  label: <fig:subref-main>,
)

详见@fig:sub-a 和@fig:sub-b (整体见@fig:subref-main)。
```

#capsubfig(
  (
    (content: rect(fill: gray), label: <fig:sub-a>),
    (content: rect(fill: gray), label: <fig:sub-b>),
  ),
  label-mode: "overlay",
  caption: [子图引用示例],
  label: <fig:subref-main>,
)

详见@fig:sub-a 和@fig:sub-b (整体见@fig:subref-main)。

// ============================================================
// 第六章：配置详解
// ============================================================
= 配置详解

== 统一配置

`cap-style` 可一次性为表格和图片设置共享样式（编号、标题、语言、注释等）。之后再调用 `captab-style` (用于设置表格样式）或 `capfig-style` (用于设置图片样式）可按类型覆盖。


```typst
#show: cap-style.with(
  numbering-format: "1.1",
  use-chapter: true,
  caption-weight: "regular",
  enable-english-caption: true,
)

// 之后仍可单独覆盖图片（或表格）
#show: capfig-style.with(
  label-mode: "overlay",
  label-style: "(a)",
)
```

== 表格全局配置

使用 `captab-style` 配置所有表格相关样式。通常在文档开头通过 `#show:` 调用：

```typst
#show: captab-style.with(
  // 编号配置
  numbering-format: "1.1",      // 章节.序号格式
  use-chapter: true,            // 包含章节号

  // 题注样式
  caption-size: 10.5pt,         // 题注字号
  caption-weight: "regular",    // 或 "bold"

  // 间距
  caption-above: 1em,           // 题注上方间距
  caption-below: 0.95em,        // 题注与表体间距

  // 语言
  lang: auto,                   // 自动检测
  enable-english-caption: true, // 启用英文副标题

  // 表格内容
  body-size: 10.5pt,
  cell-inset: (x: 3pt, y: 6.5pt),

  // 续表
  continued-mode: "prefix",     // "prefix" 或 "suffix"
)
```

== 图片全局配置

使用 `capfig-style` 配置图片和子图的样式：

```typst
#show: capfig-style.with(
  // 编号
  numbering-format: "1.1",

  // 子图默认值
  label-mode: "overlay",        // 默认覆盖标签模式
  label-style: "(a)",
  gutter: 1em,
  subcaption-pos: "bottom",

  // 题注
  enable-english-caption: true,
)
```

== 表格宽度

通过百分比调整表格相对于文本区的宽度：

```typst
#set-table-width(percentage: 50)   // 表格占文本区宽度的 50%

#captab(caption: [窄表格])[...]

#set-table-width(percentage: 100)  // 重置为满宽
```

#set-table-width(percentage: 50)   // 表格占文本区宽度的 50%

#captab(caption: [窄表格])[
  |A|B|
  |C|D|
]

#set-table-width(percentage: 100)  // 重置为满宽

== 双语目录

当表格或图片使用了双语标题时，默认只有主语言标题出现在目录中。通过 `outline-bilingual` 参数可以让目录同时显示两种语言的标题。

```typst
#show: captab-style.with(
  outline-bilingual: true,       // 启用双语目录
  outline-separator: " / ",      // 主语言与英文标题之间的分隔符
  outline-newline: false,        // false: 同行显示；true: 英文另起一行
)
```

三个相关参数：

- `outline-bilingual`：是否在目录中显示双语标题（默认 `false`）
- `outline-separator`：主语言与英文标题之间的分隔符（默认 `" / "`）
- `outline-newline`：英文标题是否另起一行显示（默认 `false`）

`captab-style`、`capfig-style`、`cap-style` 三个配置函数均支持这三个参数。使用 `cap-style` 可以同时为表格和图片启用双语目录。

// ============================================================
// 第七章：多语言支持
// ============================================================
= 多语言支持

本包支持 25+ 种语言的自动本地化。只需设置文档语言，本包即可自动使用正确的文本。

```typst
#set text(lang: "de")   // 切换到德文

#captab(
  caption: [Experimentelle Ergebnisse],
  caption-en: [Experimental Results],
)[
  |A|B|
  |C|D|
]
```

#set text(lang: "de")   // 切换到德文

#captab(
  caption: [Experimentelle Ergebnisse],
  caption-en: [Experimental Results],
)[
  |A|B|
  |C|D|
]

== 支持语言列表

#table(
  columns: (1fr, 1fr, 1fr, 1fr),
  stroke: none,
  inset: 5pt,
  table.hline(stroke: 1.5pt),
  table.header[*代码*][*语言*][*代码*][*语言*],
  table.hline(stroke: 0.5pt),
  [`en`], [英文], [`zh`], [中文],
  [`de`], [德文], [`fr`], [法文],
  [`es`], [西班牙文], [`it`], [意大利文],
  [`pt`], [葡萄牙文], [`ru`], [俄文],
  [`ja`], [日文], [`ko`], [韩文],
  [`ar`], [阿拉伯文 ↵], [`he`], [希伯来文 ↵],
  [`fa`], [波斯文 ↵], [`ur`], [乌尔都文 ↵],
  [`nl`], [荷兰文], [`pl`], [波兰文],
  [`cs`], [捷克文], [`sv`], [瑞典文],
  [`da`], [丹麦文], [`no`], [挪威文],
  [`fi`], [芬兰文], [`tr`], [土耳其文],
  [`el`], [希腊文], [`hi`], [印地文],
  [`th`], [泰文], [`vi`], [越南文],
  table.hline(stroke: 1.5pt),
)

#captnote[注：↵ 代表从右到左书写的语言；繁体中文通过 `region` 参数区分。]

== 简繁中文区分

本包支持区分简体中文（`zh`）和繁體中文（`zh-TW`）。通过 Typst 的 `text.region` 参数来切换：

```typst
// 简体中文（默认）
#set text(lang: "zh")

// 繁體中文
#set text(lang: "zh", region: "TW")
```

简繁中文的差异主要体现在以下文本：

#table(
  columns: (1fr, 1fr, 1fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*项目*][*简体*][*繁體*],
  table.hline(stroke: 0.5pt),
  [表格前缀], [表], [表],
  [图片前缀], [图], [圖],
  [续表前缀], [续表], [續表],
  [续图前缀], [续图], [續圖],
  [续表后缀], [（续）], [（續）],
  table.hline(stroke: 1.5pt),
)

#set text(lang: "zh", region: "TW")

#captab(
  caption: [繁體中文測試表格],
  caption-en: [Traditional Chinese Test Table],
  label: <tab:zh-tw>
)[
  | 項目   | 數值 |
  | ------ | ---- |
  | 測試 2 | 100  |
]

#captab(
  caption: [繁體中文測試表格],
  caption-en: [Traditional Chinese Test Table],
  refer-to: <tab:zh-tw>
)[
  | 項目   | 數值 |
  | ------ | ---- |
  | 測試 2 | 200  |
]

#capfig(
  rect(width: 15%, height: 1.35cm, fill: green.lighten(80%)),
  caption: [繁體中文測試圖片],
  caption-en: [Traditional Chinese Test Figure],
)

#set text(lang: "zh")

== RTL 语言支持

对于从右到左书写的语言（阿拉伯文、希伯来文、波斯文、乌尔都文），本包会自动：

- 调整双语标题的行顺序（RTL 语言在前，英文在后）
- 为 RTL 语言内容使用 `box[]` 包装防止方向混乱
- 为英文行强制设置 `dir: ltr` 方向

#set text(lang: "ar")

#captab(
  caption: [أهم المدن في العالم العربي],
  caption-en: [Major Cities in the Arab World]
)[
  | المدينة | الدولة | عدد السكان (مليون) |
  | القاهرة | مصر | 20.9 |
  | بغداد | العراق | 7.5 |
  | الرياض | المملكة العربية السعودية | 7.2 |
  | الخرطوم | السودان | 5.8 |
  | الدار البيضاء | المغرب | 3.7 |
  | الجزائر | الجزائر | 3.5 |
  | دمشق | سوريا | 2.5 |
  | عمّان | الأردن | 4.0 |
  | بيروت | لبنان | 2.4 |
  | تونس | تونس | 2.3 |
]

#set text(lang: "en")

== 各语言格式差异

不同语言有不同的分隔符和间距规则：

- *中文/日文*：前缀与编号紧排（无空格），编号与标题用全角空格
- *法文*：冒号前有空格（"Tableau 1 : Titre"）
- *西班牙/意大利文*：用点号分隔（"Tabla 1. Título"）
- *英文/德文*：用冒号加空格（"Table 1: Title"）

// ============================================================
// 第八章：完整用法清单
// ============================================================
= 完整用法清单

本章系统列出 `cap-able` 所有公开函数的全部参数、所有取值、所有别名和所有行为细节，作为参考。

== 公开 API 概览

#table(
  columns: (1.2fr, 0.8fr, 2fr),
  stroke: none,
  inset: 5pt,
  table.hline(stroke: 1.5pt),
  table.header[*函数*][*类别*][*用途*],
  table.hline(stroke: 0.5pt),
  [`cap-style`], [配置], [统一配置表与图共享样式],
  [`captab-style`], [配置], [全局表格样式配置],
  [`capfig-style`], [配置], [全局图片样式配置],
  [`set-table-width`], [配置], [全局表格宽度百分比],
  [`captab`], [表格], [三线表],
  [`capfig`], [图片],  [单图],
  [`capsubfig`], [图片], [多子图布局],
  [`captnote`], [注释], [表注],
  [`capfnote`], [注释], [图注],
  [`bicap`], [标题], [独立双语标题],
  table.hline(stroke: 1.5pt),
)

== `set-table-width` 完整参数

#table(
  columns: (1fr, 1fr, 3fr),
  stroke: none,
  inset: 5pt,
  table.hline(stroke: 1.5pt),
  table.header[*参数*][*类型*][*说明*],
  table.hline(stroke: 0.5pt),
  [`percentage`], [`int` (1–100)], [表格占文本区宽度的百分比],
  table.hline(stroke: 1.5pt),
)

```typst
#set-table-width(percentage: 80)   // 80% 宽度
#set-table-width(percentage: 100)  // 恢复满宽
```

== `cap-style` 完整参数

`cap-style` 是统一配置入口，将所有共享参数同时写入 `captab-style-config` 与 `capfig-style-config`，等价于先后调用 `captab-style.with(...)` 和 `capfig-style.with(...)`。在它之后再单独调用 `captab-style` 或 `capfig-style` 仍可按类型覆盖。


#table(
  columns: (1.8fr, 1fr, 2.5fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*参数*][*默认*][*说明*],
  table.hline(stroke: 0.5pt),
  [`numbering-format`], [`"1"`], [编号格式],
  [`use-chapter`], [`false`], [编号是否含章节号],
  [`supplement`], [`auto`], [主语言前缀词（文档语言为英语时同样用此参数，后不再赘述）],
  [`supplement-en`], [`auto`], [英文前缀词（非英语文档）],
  [`continued-prefix`], [`auto`], [续表/图前缀（主语言）],
  [`continued-prefix-en`], [`auto`], [续表/图前缀（英文）],
  [`continued-suffix`], [`auto`], [续表/图后缀（主语言）],
  [`continued-suffix-en`], [`auto`], [续表/图后缀（英文）],
  [`continued-mode`], [`"prefix"`], [续表/图模式 `"prefix"`],
  [`continued-show-caption`], [`auto`], [续表/图是否显示标题文本],
  [`caption-size`], [`10.5pt`], [标题字号],
  [`caption-weight`], [`"regular"`], [标题字重],
  [`caption-leading`], [`0.5em`], [标题行距],
  [`caption-above`], [`1.5em`], [题注上方间距],
  [`pre-supplement-number-spacing`], [`auto`], [前缀与编号间距],
  [`post-supplement-number-spacing`], [`auto`], [编号与后缀间距],
  [`number-title-spacing`], [`auto`], [编号与主语言标题间距],
  [`number-title-spacing-en`], [`auto`], [编号与英文标题间距],
  [`lang`], [`auto`], [语言代码覆盖],
  [`enable-english-caption`], [`true`], [是否生成英文副标题],
  [`outline-bilingual`], [`false`], [目录双语显示],
  [`outline-separator`], [`" / "`], [目录双语分隔符],
  [`outline-newline`], [`false`], [目录双语是否换行],
  [`after-indent`], [`auto`], [块后首行缩进修复],
  [`note-above`], [`0.7em`], [注释上方间距],
  [`note-below`], [`1em`], [注释下方间距],
  [`note-size`], [`10.5pt`], [注释字号],
  [`note-leading`], [`6.5pt`], [注释行距],
  [`note-justify`], [`true`], [注释是否两端对齐],
  table.hline(stroke: 1.5pt),
)

*未在 `cap-style` 列出的参数* —— 表体（`body-size` / `body-leading` / `cell-inset` / `table-below`）和图片专属（`figure-above` / `figure-below` / `subcaption-*` / `gutter` / 子图标签 `label-*`）—— 仍需通过 `captab-style` / `capfig-style` 单独配置。

#pagebreak()

== `captab-style` 完整参数

以下是 `captab-style` 的所有参数及默认值。`auto` 表示按文档语言自动选择。

#table(
  columns: (1.8fr, 1fr, 2.5fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*参数*][*默认*][*说明*],
  table.hline(stroke: 0.5pt),
  [`caption-above`], [`1.5em`], [题注块上方间距],
  [`caption-below`], [`0.5em`], [题注与表体之间间距],
  [`table-below`], [`0.5em`], [整个表格下方间距],
  [`caption-leading`], [`0.5em`], [题注行距（影响双语两行）],
  [`numbering-format`], [`"1"`], [编号格式，如 `"1"`、`"1.1"`、`"A.1"`、`"I.1"`],
  [`use-chapter`], [`true`], [编号中是否含章节号],
  [`supplement`], [`auto`], [主语言前缀词（如 `"表"`）],
  [`supplement-en`], [`auto`], [英文前缀词],
  [`continued-prefix`], [`auto`], [续表前缀（主语言）],
  [`continued-prefix-en`], [`auto`], [续表前缀（英文）],
  [`continued-suffix`], [`auto`], [续表后缀（主语言）],
  [`continued-suffix-en`], [`auto`], [续表后缀（英文）],
  [`continued-mode`], [`"prefix"`], [续表样式 `"prefix"` / `"suffix"`],
  [`continued-show-caption`], [`auto`], [续表是否显示标题（`auto` / `true` / `false`）],
  [`caption-size`], [`10.5pt`], [题注字号],
  [`caption-weight`], [`"regular"`], [题注字重 `"regular"` / `"bold"`],
  [`pre-supplement-number-spacing`], [`auto`], [前缀与编号间距],
  [`post-supplement-number-spacing`], [`auto`], [编号与后缀间距],
  [`number-title-spacing`], [`auto`], [编号与主语言标题间距],
  [`number-title-spacing-en`], [`auto`], [编号与英文标题间距],
  [`lang`], [`auto`], [语言代码覆盖（`auto` 跟随 `text.lang`）],
  [`enable-english-caption`], [`true`], [是否生成英文副标题],
  [`body-size`], [`10.5pt`], [表格内容字号],
  [`body-leading`], [`0.45em`], [表格内容行距],
  [`cell-inset`], [`(x: 5pt, y: 5pt)`], [单元格内边距（字典或标量）],
  [`note-above`], [`0.5em`], [表注上方间距],
  [`note-below`], [`1em`], [表注下方间距],
  [`note-size`], [`10.5pt`], [表注字号],
  [`note-leading`], [`6.5pt`], [表注行距],
  [`note-justify`], [`true`], [表注是否两端对齐],
  [`outline-bilingual`], [`false`], [目录双语显示],
  [`outline-separator`], [`" / "`], [目录双语分隔符],
  [`outline-newline`], [`false`], [目录双语是否换行],
  [`after-indent`], [`auto`], [表格后首行缩进修复（`auto` 按语言）],
  table.hline(stroke: 1.5pt),
)

*间距参数可以是长度或内容*：任何 `*-spacing` 或 `pre/post-supplement-number-spacing` 支持长度（如 `0.5em`）或直接内容（如 `[\u{3000}]` 全角空格）。

== `capfig-style` 完整参数

`capfig-style` 合并了图片样式配置、图片间距和子图默认值，一次性更新全部图片相关状态。

*题注/编号/语言部分*

#table(
  columns: (1.8fr, 1fr, 2.5fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*参数*][*默认*][*说明*],
  table.hline(stroke: 0.5pt),
  [`numbering-format`], [`"1"`], [编号格式],
  [`use-chapter`], [`false`], [编号是否含章节号],
  [`supplement`], [`auto`], [主语言前缀词],
  [`supplement-en`], [`auto`], [英文前缀词],
  [`continued-prefix`], [`auto`], [续图前缀（主语言）],
  [`continued-prefix-en`], [`auto`], [续图前缀（英文）],
  [`continued-suffix`], [`auto`], [续图后缀（主语言）],
  [`continued-suffix-en`], [`auto`], [续图后缀（英文）],
  [`continued-mode`], [`"prefix"`], [续图模式 `"prefix"` / `"suffix"`],
  [`continued-show-caption`], [`auto`], [续图是否显示标题文本],
  [`caption-size`], [`10.5pt`], [题注字号],
  [`caption-weight`], [`"regular"`], [题注字重],
  [`caption-leading`], [`0.5em`], [题注行距],
  [`pre-supplement-number-spacing`], [`auto`], [前缀与编号间距],
  [`post-supplement-number-spacing`], [`auto`], [编号与后缀间距],
  [`number-title-spacing`], [`auto`], [编号与主语言标题间距],
  [`number-title-spacing-en`], [`auto`], [编号与英文标题间距],
  [`lang`], [`auto`], [语言代码覆盖],
  [`enable-english-caption`], [`true`], [是否生成英文副标题],
  [`outline-bilingual`], [`false`], [目录双语显示],
  [`outline-separator`], [`" / "`], [目录双语分隔符],
  [`outline-newline`], [`false`], [目录双语是否换行],
  [`after-indent`], [`auto`], [块后首行缩进修复],
  [`note-above`], [`0.7em`], [图注上方间距],
  [`note-below`], [`1em + 1.5pt`], [图注下方间距],
  [`note-size`], [`10.5pt`], [图注字号],
  [`note-leading`], [`6.5pt`], [图注行距],
  [`note-justify`], [`true`], [图注是否两端对齐],
  table.hline(stroke: 1.5pt),
)

*图片间距部分*

#table(
  columns: (1.8fr, 1fr, 2.5fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*参数*][*默认*][*说明*],
  table.hline(stroke: 0.5pt),
  [`figure-above`], [`1em`], [图片上方间距],
  [`figure-below`], [`1em`], [图片下方间距],
  [`caption-above`], [`0.5em`], [图片与题注间距],
  [`subcaption-above`], [`0.3em`], [子标题与子图间距],
  [`subcaption-below`], [`0.5em`], [子标题下方间距],
  table.hline(stroke: 1.5pt),
)

*子图默认值部分*

#table(
  columns: (1.8fr, 1fr, 2.5fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*参数*][*默认*][*说明*],
  table.hline(stroke: 0.5pt),
  [`gutter`], [`1em`], [子图水平间距],
  [`subcaption-pos`], [`"bottom"`], [子标题位置 `"top"` / `"bottom"`],
  [`show-subcaption`], [`false`], [默认显示子标题],
  [`show-subcaption-label`], [`true`], [子标题含标签],
  [`align`], [`"horizon"`], [垂直对齐 `"top"` / `"horizon"` / `"bottom"`],
  [`label-mode`], [`none`], [标签模式 `none` / `"overlay"`],
  [`label-style`], [`"(a)"`], [标签样式（见标签样式参考节）],
  [`label-font`], [`("Arial",)`], [标签字体列表],
  [`label-size`], [`12pt`], [标签字号],
  [`label-offset`], [`(4pt, 4pt)`], [标签偏移 `(dx, dy)`],
  [`label-text-color`], [`black`], [标签文字颜色],
  [`label-stroke`], [`none`], [标签描边],
  [`label-bg`], [`none`], [标签背景色],
  [`label-bg-shape`], [`"rect"`], [背景形状 `"rect"` / `"circle"`],
  [`label-bg-radius`], [`2pt`], [矩形圆角],
  [`label-bg-inset`], [`3pt`], [背景内边距],
  [`label-sep`], [`auto`], [子图引用分隔符（`auto`：数字 → `"."`，字母 → `""`）],
  table.hline(stroke: 1.5pt),
)

== `captab` 完整参数

#table(
  columns: (1fr, 1.2fr, 2.5fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*参数*][*类型*][*说明*],
  table.hline(stroke: 0.5pt),
  [`cols`], [`auto` / `int` / `array`], [列配置（`auto` 或长度数组，支持 `fr` 与绝对单位）],
  [`size`], [`auto` / `length`], [内容字号（`auto` 取全局 `body-size`）],
  [`leading`], [`auto` / `length`], [内容行距（`auto` 取全局 `body-leading`）],
  [`inset`], [`auto` / `length` / `dictionary`], [单元格内边距],
  [`caption`], [`none` / `content`], [主语言标题],
  [`caption-en`], [`none` / `content`], [英文标题],
  [`refer-to`], [`none` / `label`], [续表引用的原表标签],
  [`show-caption`], [`auto` / `bool`], [续表是否显示标题文本],
  [`hlines`], [`array` of `dictionary`], [额外横线数组],
  [`vlines`], [`array` of `dictionary`], [额外竖线数组],
  [`label`], [`none` / `label`], [本表标签],
  [`content`], [`content`（位置参数）], [Markdown 风格表格体],
  table.hline(stroke: 1.5pt),
)

*`hlines` / `vlines` 字典结构*：

#table(
  columns: (1fr, 1fr, 1fr, 3fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*键*][*hlines 默认*][*vlines 默认*][*说明*],
  table.hline(stroke: 0.5pt),
  [`row` / `col`], [`2`], [`1`], [横线在第 N 行上方 / 竖线在第 N 列右侧],
  [`start`], [`0`], [`0`], [起始列/行索引],
  [`end`], [`none`], [`none`], [结束索引（`none` 表示末尾）],
  [`stroke`], [`0.5pt`], [`0.5pt`], [线条描边],
  table.hline(stroke: 1.5pt),
)

```typst
#captab(
  hlines: (
    (row: 2, stroke: 1pt),
    (row: 4, start: 1, end: 3, stroke: 0.3pt + red),
  ),
  vlines: (
    (col: 1, start: 1, stroke: 0.5pt),
  ),
  caption: [复杂线条],
)[...]
```

#captab(
  hlines: (
    (row: 2, stroke: 1pt),
    (row: 4, start: 1, end: 3, stroke: 0.3pt + red),
  ),
  vlines: (
    (col: 1, start: 1, stroke: 0.5pt),
  ),
  caption: [复杂线条],
)[
  | A | B | C | D |
  | - | - | - | - |
  | 1 | 2 | 3 | 4 |
  | 5 | 6 | 7 | 8 |
  | 9 | 0 | 1 | 2 |
]

=== 续表模式示例

*前缀模式*（默认）：显示 `"续表 1.1"`

*后缀模式*：显示 `"表 1.1（续）"`

```typst
#show: captab-style.with(continued-mode: "suffix")

#captab(caption: [长表], label: <tab:long2>)[...]
#captab(refer-to: <tab:long2>)[...]  // 显示 "表 1.1（续）"
```

*强制显示或隐藏标题文本*：

```typst
// 强制显示
#captab(
  refer-to: <tab:original>,
  caption: [原标题],
  show-caption: true,
)[...]

// 强制隐藏（即使提供了 caption）
#captab(
  refer-to: <tab:original>,
  show-caption: false,
)[...]
```

== `bicap` 独立标题函数

`bicap` 是 `cap-able` 的核心标题生成函数，可独立于 `captab` / `capfig` 使用，用于自定义布局或在 Typst 原生 table/figure 中嵌入双语标题。


#table(
  columns: (1.2fr, 1.2fr, 2.6fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*参数*][*类型*][*说明*],
  table.hline(stroke: 0.5pt),
  [`caption`], [`none` / `content`], [主语言标题],
  [`caption-en`], [`none` / `content`], [英文标题],
  [`refer-to`], [`none` / `label`], [续表/图引用的原标签],
  [`label`], [`none` / `label`], [本标题绑定的标签],
  [`kind`], [`"table"` / `"figure"`], [类别（决定计数器与配置源）],
  [`show-caption`], [`auto` / `bool`], [续表/图是否显示标题文本],
  [`config`], [`auto` / `dictionary`], [`auto` 按 `kind` 读取全局配置；否则用给定字典],
  table.hline(stroke: 1.5pt),
)

```typst
// 独立为图片生成双语标题
#align(center)[
  #rect(width: 6cm, height: 3cm, fill: gray.lighten(70%))
  #bicap(
    caption: [自定义图片],
    caption-en: [Custom Figure],
    kind: "figure",
    label: <fig:custom>,
  )
]
```

== `capfig` 完整参数

#table(
  columns: (1.1fr, 1fr, 2.8fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*参数*][*类型*][*说明*],
  table.hline(stroke: 0.5pt),
  [`content`], [`content`（位置参数）], [图片内容（通常 `image(...)`）],
  [`caption`], [`none` / `content`], [主语言标题],
  [`caption-en`], [`none` / `content`], [英文标题],
  [`label`], [`none` / `label`], [图片标签],
  [`refer-to`], [`none` / `label`], [续图原图标签],
  [`show-caption`], [`auto` / `bool`], [续图是否显示标题文本],
  [`figure-above`], [`auto` / `length`], [图片上方间距（`auto` 取全局值）],
  [`figure-below`], [`auto` / `length`], [图片下方间距（`auto` 取全局值）],
  [`caption-above`], [`auto` / `length`], [图片与题注间距（`auto` 取全局值）],
  [`caption-leading`], [`auto` / `length`], [题注行距（`auto` 取全局值）],
  table.hline(stroke: 1.5pt),
)

图片内容和标题始终包裹在不换页 block 中；标题始终位于图片下方；若 `capfig-style` 的 `lang` 为 `auto` 且 `captab-style` 的 `lang` 不为 `auto`，则继承后者。

== `capsubfig` 完整参数

=== 子图字典结构

`subfigs` 参数为字典数组，每项支持以下键：


#table(
  columns: (1.2fr, 1fr, 2.8fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*键*][*必须*][*说明*],
  table.hline(stroke: 0.5pt),
  [`content`], [必须], [子图内容（通常 `image()` 或 `rect()`）],
  [`subcaption`], [条件], [子标题（`show-subcaption: true` 时使用）],
  [`label`], [可选], [子图标签，`@label` 引用得到如 `图1.1a`],
  [`label-style-override`], [可选], [覆盖模式下单个子图的样式覆盖字典],
  table.hline(stroke: 1.5pt),
)

=== `label-style-override` 字典键

#table(
  columns: (1fr, 3fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*键*][*覆盖的全局参数*],
  table.hline(stroke: 0.5pt),
  [`text-color`], [`label-text-color` — 标签文字颜色],
  [`stroke`],     [`label-stroke` — 标签描边],
  [`bg`],         [`label-bg` — 标签背景色],
  [`bg-shape`],   [`label-bg-shape` — 背景形状],
  [`bg-radius`],  [`label-bg-radius` — 矩形圆角],
  [`bg-inset`],   [`label-bg-inset` — 背景内边距],
  table.hline(stroke: 1.5pt),
)

=== 函数参数

除 `subfigs` 外，所有参数皆可为 `auto`（表示继承 `capfig-style` 全局值）：

- `columns`（`auto` / `int`）：每行列数；`auto` 表示所有子图在一行。
- `caption` / `caption-en` / `label` / `refer-to` / `show-caption`：与 `capfig` 同义。
- `gutter`、`subcaption-pos`、`show-subcaption`、`show-subcaption-label`、`align`、`label-mode`、`label-style`、`label-font`、`label-size`、`label-offset`、`label-text-color`、`label-stroke`、`label-bg`、`label-bg-shape`、`label-bg-radius`、`label-bg-inset`、`label-sep`：覆盖 `capfig-style` 的同名子图默认值。
- `figure-above`、`figure-below`、`caption-above`、`subcaption-above`、`subcaption-below`：间距覆盖。

=== 标签样式字符串解析规则

解析器从左到右扫描 `label-style` 字符串，找到 *第一个* 格式字符（`a`/`A`/`1`/`i`/`I`），其前为前缀，其后为后缀；若找不到格式字符，则整串作为前缀，默认格式为 `"a"`。

- 罗马数字编号仅支持 1–20（`i..xx` / `I..XX`）；超过后回退为阿拉伯数字。
- `label-sep` `auto` 规则：数字格式 → `"."`（如 `"图1.1.2"`），字母/罗马格式 → `""`（如 `"图1.1a"`）。

=== 覆盖标签含圆形背景

```typst
#capsubfig(
  (
    (content: rect(width: 4cm, height: 2.5cm, fill: yellow.lighten(70%))),
    (content: rect(width: 4cm, height: 2.5cm, fill: red.lighten(70%)),
     label-style-override: (bg: green, text-color: white)),
  ),
  columns: 2,
  label-mode: "overlay",
  label-style: "(1)",
  label-bg: blue.lighten(60%),
  label-bg-shape: "circle",
  label-size: 10pt,
  caption: [圆形背景与单项覆盖],
)
```

=== 多行子图

设置 `columns: N`，当子图数多于 N 时会自动换行；最后一行不满时按实际数量渲染。

```typst
#capsubfig(
  (
    (content: rect(width: 2cm, height: 2cm, fill: red)),
    (content: rect(width: 2cm, height: 2cm, fill: green)),
    (content: rect(width: 2cm, height: 2cm, fill: blue)),
    (content: rect(width: 2cm, height: 2cm, fill: orange)),
    (content: rect(width: 2cm, height: 2cm, fill: purple)),
  ),
  columns: 3,                 // 3 列：首行3个，次行2个
  label-mode: "overlay",
  caption: [五子图],
)
```

== `captnote` 完整参数

#table(
  columns: (1fr, 1.2fr, 3fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*参数*][*类型*][*说明*],
  table.hline(stroke: 0.5pt),
  [`width`], [`auto` / `ratio` / `length`], [宽度（三种模式见下）],
  [`justify`], [`auto` / `bool`], [两端对齐（`auto` 取全局 `note-justify`）],
  [`content`], [`content`（位置参数）], [表注内容],
  table.hline(stroke: 1.5pt),
)

*三种宽度模式*：

- `width: auto`（默认）：读取 `table-width-config`，与最近的 `captab` 宽度保持一致。
- `width: 80%` 等 `ratio`：以指定百分比缩窄并居中。
- `width: 10cm` 等 `length`：固定宽度，居中显示。

```typst
#captnote[自动匹配表格宽度]
#captnote(width: 70%)[70% 宽度居中]
#captnote(width: 8cm)[固定 8cm]
#captnote(justify: false)[不强制两端对齐]
```

== `capfnote` 完整参数

#table(
  columns: (1fr, 1.2fr, 3fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*参数*][*类型*][*说明*],
  table.hline(stroke: 0.5pt),
  [`width`], [`ratio` / `length`], [默认 `100%`；不支持 `auto`],
  [`justify`], [`auto` / `bool`], [两端对齐（`auto` 取全局 `capfig-style.note-justify`）],
  [`content`], [`content`], [图注内容],
  table.hline(stroke: 1.5pt),
)

```typst
#capfig(image("chart.png"), caption: [结果])
#capfnote(width: 90%)[
  数据来源：2024 年调查。
]
```

== 多语言完整规则

下表列出每种语言的前缀词和间距规则（`pre` = `pre-supplement-number-spacing`，`sep` = `number-title-spacing`）：

#table(
  columns: (0.5fr, 0.8fr, 0.8fr, 0.5fr, 0.6fr, 1.2fr),
  stroke: none,
  inset: 3.5pt,
  table.hline(stroke: 1.5pt),
  table.header[*lang*][*table*][*figure*][*pre*][*sep*][*续表后缀*],
  table.hline(stroke: 0.5pt),
  [en], [Table],    [Figure],    [`" "`], [`": "`],    [(continued)],
  [zh], [表],        [图],         [`0em`], [`U+3000`],  [（续）],
  [zh-TW], [表],     [圖],         [`0em`], [`U+3000`],  [（續）],
  [de], [Tabelle],  [Abbildung], [`" "`], [`": "`],    [(Fortsetzung)],
  [fr], [Tableau],  [Figure],    [`" "`], [`" : "`],   [(suite)],
  [es], [Tabla],    [Figura],    [`" "`], [`". "`],    [(continuación)],
  [it], [Tabella],  [Figura],    [`" "`], [`". "`],    [(continua)],
  [pt], [Tabela],   [Figura],    [`" "`], [`": "`],    [(continuação)],
  [ru], [Таблица],  [Рисунок],   [`" "`], [`". "`],    [(продолжение)],
  [ja], [表],        [図],         [`0em`], [`U+3000`],  [（続き）],
  [ko], [표],        [그림],       [`" "`], [`". "`],    [(계속)],
  [ar ↵], [جدول],   [شكل],       [`" "`], [`": "`],    [(تابع)],
  [nl], [Tabel],    [Figuur],    [`" "`], [`": "`],    [(vervolg)],
  [pl], [Tabela],   [Rysunek],   [`" "`], [`". "`],    [(cd.)],
  [cs], [Tabulka],  [Obrázek],   [`" "`], [`": "`],    [(pokračování)],
  [sv], [Tabell],   [Figur],     [`" "`], [`". "`],    [(forts.)],
  [da], [Tabel],    [Figur],     [`" "`], [`": "`],    [(fortsat)],
  [no], [Tabell],   [Figur],     [`" "`], [`": "`],    [(forts.)],
  [fi], [Taulukko], [Kuva],      [`" "`], [`". "`],    [(jatkoa)],
  [tr], [Tablo],    [Şekil],     [`" "`], [`". "`],    [(devam)],
  [el], [Πίνακας],  [Σχήμα],     [`" "`], [`". "`],    [(συνέχεια)],
  [he ↵], [טבלה],   [תמונה],     [`" "`], [`": "`],    [(המשך)],
  [hi], [तालिका],    [चित्र],       [`" "`], [`": "`],    [(जारी)],
  [th], [ตาราง],    [รูป],        [`" "`], [`" "`],     [(ต่อ)],
  [vi], [Bảng],     [Hình],      [`" "`], [`". "`],    [(tiếp theo)],
  [fa ↵], [جدول],   [شکل],       [`" "`], [`": "`],    [(ادامه)],
  [ur ↵], [جدول],   [شکل],       [`" "`], [`": "`],    [(جاری)],
  table.hline(stroke: 1.5pt),
)

#captnote[注：↵ 代表从右到左书写的语言。]

*首行缩进修复*（`after-indent: auto`）自动启用的语言：`zh`、`ja`、`ko`、`fr`、`vi`、`th`。其他语言默认不触发修复；任何语言可通过显式设置 `after-indent: true` / `false` 覆盖。

*RTL 语言双语标题布局*：对 `ar` / `he` / `fa` / `ur`，主语言与英文行顺序会自动交换，英文行会被包在 `#text(dir: ltr)[...]` 中防止方向混乱；单语模式下主语言内容用 `box[]` 包装。

// ============================================================
// 第九章：API 参考
// ============================================================
= API 参考

本章通过 tidy 从源码文档字符串自动生成 API 参考文档。

== 配置模块

配置模块提供全局状态管理、多语言文本、辅助工具函数和两个主配置函数。


#tidy.show-module(
  tidy.parse-module(
    read("/cap-able/0.0.1/src/config.typ"),
    name: "config",
  ),
  show-module-name: false,
  omit-private-definitions: true,
)

== 独立标题模块

标题模块提供核心的双语标题生成引擎，支持主标题和续表/续图两种模式。


#tidy.show-module(
  tidy.parse-module(
    read("/cap-able/0.0.1/src/bicap.typ"),
    name: "bicap",
  ),
  show-module-name: false,
  omit-private-definitions: true,
)

== 三线表模块

三线表模块提供符合学术规范的三线表创建函数及其别名。


#tidy.show-module(
  tidy.parse-module(
    read("/cap-able/0.0.1/src/table.typ"),
    name: "table",
  ),
  show-module-name: false,
  omit-private-definitions: true,
)

== 注释模块

注释模块提供表注和图注功能，支持自动宽度匹配和多种宽度模式。


#tidy.show-module(
  tidy.parse-module(
    read("/cap-able/0.0.1/src/note.typ"),
    name: "note",
  ),
  show-module-name: false,
  omit-private-definitions: true,
)

== 图片模块

图片模块提供单图片和多子图布局函数，支持双语标题、覆盖标签和子标题。


#tidy.show-module(
  tidy.parse-module(
    read("/cap-able/0.0.1/src/figure.typ"),
    name: "figure",
  ),
  show-module-name: false,
  omit-private-definitions: true,
)

// ============================================================
// 第十章：常见问题
// ============================================================
= 常见问题

== 为什么使用 Markdown 语法？

Markdown 表格语法（通过 `tablem`）的优势：

- 大多数用户熟悉
- 易于阅读和编辑
- 快速输入
- 与许多编辑器兼容

== 如何创建无标题表格？

省略 `caption` 参数即可：

```typst
#captab()[
  | A | B |
  | - | - |
  | 1 | 2 |
]
```

== 如何使用 Typst 原生表格语法？

可以！直接用 `bicap` 为原生 Typst 表格生成标题：

```typst
#set text(lang: "zh")
#align(center)[
  #bicap(
      caption: [原生 Typst 表格],
      kind: "table",
  )
  #table(
    columns: 3,
    [A], [B], [C],
    [1], [2], [3],
  )
]
```

#set text(lang: "zh")
#align(center)[
  #bicap(
      caption: [原生 Typst 表格],
      kind: "table",
  )
  #table(
    columns: 3,
    [A], [B], [C],
    [1], [2], [3],
  )
]


== 如何引用表格和图片？

使用 Typst 标准的标签和引用语法：

```typst
#captab(caption: [...], label: <tab:example>)[...]

详见@tab:example 中的数据。
```

== 续表为什么不显示标题文本？

默认情况下，续表在未提供 `caption` 时只显示编号。强制显示标题文本：

```typst
#captab(
  refer-to: <tab:original>,
  caption: [原始标题],                      // 提供标题文本
  show-caption: true,                       // 或强制显示
)[...]
```

== 如何修复中文等语言中表格后的首行缩进丢失？

本包会自动检测语言并修复首行缩进（对中文、日文等语言）。
如果需要手动控制：


```typst
#show: captab-style.with(
  after-indent: true,   // 强制修复
  // 或
  after-indent: false,  // 禁用修复
)
```

== 如何在目录中显示双语标题？

```typst
#show: captab-style.with(
  outline-bilingual: true,      // 启用目录双语
  outline-separator: " / ",     // 分隔符
  outline-newline: false,       // true 换行，false 同行
)
```

// ============================================================
// 第十一章：变更日志
// ============================================================
= 变更日志

== 版本 0.0.1

首次发布，包含以下功能：

- `captab` 三线表支持
- 双语标题支持
- 续表和续图功能
- `capsubfig` 子图布局
- 表注和图注
- 25+ 种语言本地化
- RTL 语言（阿拉伯文、希伯来文、波斯文、乌尔都文）支持
- 全局配置系统
- `cap-style`（统一）、`captab-style`、`capfig-style`、`set-table-width` 配置函数