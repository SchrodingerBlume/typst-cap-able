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
#import "cap-able/0.1.2/lib.typ": *

// ============================================================
// 文档元数据
// ============================================================

#show: mantys(
  name: "cap-able",
  version: "0.1.2",
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
#import "@preview/cap-able:0.1.2": *
```

== 手动安装

从仓库下载文件后：

+ 将 `cap-able` 文件夹放入项目目录
+ 使用相对路径导入

```typst
#import "cap-able/0.1.2/lib.typ": *
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
- 按内容宽度自然撑开（默认 `width: auto`；可通过 `width` 参数或 `set-table-width(...)` 改为定宽 / 百分比，详见"表格宽度配置"段落）
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

通过 `columns` 参数自定义列宽（也可继续使用旧名 `cols`，效果完全一致）。

*列宽规则：*

- 不指定 `columns`（自动模式）：各列按内容自适应，内容过长时可能溢出文本区。
- 仅绝对单位（如 `cm`、`pt`）：表格宽度为各列之和，可能窄于或超出文本区。
- 含 `fr` 单位：表格按比例展开至文本区宽度。`fr` 与绝对单位可以混用——绝对列先占据固定宽度，剩余空间再按 `fr` 比例分配。

`columns` 参数接受一个长度数组，例如：
```typst
  columns: (8cm, 2cm, 2cm)       // 绝对单位
  columns: (3fr, 1fr, 1fr)       // 相对单位
  columns: (3fr, 2cm, 1fr)       // 混用
```

=== *自动模式 `columns: ()`*

#captab(
  caption: [自动列宽],
)[
  | 描述 | 数值 | 单位 |
  | ---- | ---- | ---- |
  | 很长很长、真的真的、特别特别长的描述文字 | 42 | m/s |
]
#pagebreak()
=== 绝对单位 `columns: (8cm, 3cm, 2cm)`

#captab(
  columns: (8cm, 3cm, 2cm),
  caption: [绝对列宽],
)[
  | 描述 | 数值 | 单位 |
  | ---- | ---- | ---- |
  | 很长很长、真的真的、特别特别长的描述文字 | 42 | m/s |
]

=== fr 单位 `columns: (3fr, 1fr, 1fr)` ——第一列是其他列宽度的三倍

#captab(
  columns: (3fr, 1fr, 1fr),
  caption: [比例列宽],
)[
  | 描述 | 数值 | 单位 |
  | ---- | ---- | ---- |
  | 很长很长、真的真的、特别特别长的描述文字 | 42 | m/s |
]

=== 混用 `columns: (5fr, 3cm, 1fr)`——数值列固定 3cm，描述列与单位列按 5:1 分配剩余宽度

#captab(
  columns: (5fr, 3cm, 1fr),
  caption: [混用列宽],
)[
| 描述 | 数值 | 单位 |
  | ---- | ---- | ---- |
  | 很长很长、真的真的、特别特别长的描述文字 | 42 | m/s |
]

== 额外线条

对于复杂表格，可添加额外的横线或竖线。`hlines` / `vlines` 数组的每一项可以是 *`int` 简写*（只指定行/列号，其它走默认）或*完整 dict*：

```typst
// 简写：纯 int 列表
#captab(hlines: (2, 3), vlines: (1, 2), caption: [...])[ ... ]

// 完整 dict（自定义 stroke / start / end）
#captab(
  hlines: ((row: 3, stroke: 1pt),),   // 在第3行后添加 1 磅横线
  vlines: ((col: 1, start: 1),),      // 在第1列右侧添加竖线（从第1行起）
  caption: [含额外线条的表格],
)[...]

// 混合
#captab(hlines: (2, (row: 5, stroke: 1.5pt + red), 7), ...)[ ... ]
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

=== 全局默认 stroke `extra-rule`

如果整张表（或全文档）所有额外线都用同样的 stroke，与其每条都写一次，不如设全局默认：

```typst
#show: captab-style.with(extra-rule: 0.5pt + red)

#captab(
  hlines: ((row: 2,), (row: 3,)),     // 都跟随 0.5pt + red，无需重复
)[ ... ]
```

`extra-rule` 接受 *单值*（h、v 共用）或 *dict 形式*分别指定横/竖线：

```typst
#show: captab-style.with(
  extra-rule: (h: 1pt + blue, v: 0.3pt + gray),
)
```

per-line `stroke` 仍然能 *单独覆盖*（覆盖 > 全局）：

```typst
#captab(
  extra-rule: 0.5pt + green,
  hlines: (
    (row: 2,),                        // 0.5pt + green ← 跟随
    (row: 5, stroke: 1.5pt + orange), // 1.5pt + orange ← 覆盖
  ),
)
```

可在 `cap-style`/`captab-style` 全局或 `captab(extra-rule: ...)` per-call 设置。默认 `0.5pt` 与旧版一致。

== 三线粗细

可通过 `top-rule` / `middle-rule` / `bottom-rule` 自定义三线表的顶/中/底线。它们接受任何 Typst stroke 值——粗细、颜色、虚线都行：

```typst
#captab(
  caption: [自定义线条样式],
  top-rule: 2pt + red,             // 顶线 2pt 红色
  middle-rule: 0.5pt + gray,       // 中线灰色
  bottom-rule: stroke(thickness: 2pt, dash: "dashed"), // 底线虚线
)[
  | A | B | C |
  | - | - | - |
  | 1 | 2 | 3 |
]
```

#captab(
  caption: [自定义线条样式],
  top-rule: 2pt + red,
  middle-rule: 0.5pt + gray,
  bottom-rule: stroke(thickness: 2pt, dash: "dashed"),
)[
  | A | B | C |
  | - | - | - |
  | 1 | 2 | 3 |
]

也可在 `captab-style` 中全局配置三线样式：

```typst
#show: captab-style.with(
  top-rule: 1.2pt,
  middle-rule: 0.4pt,
  bottom-rule: 1.2pt,
)
```

`auto` 表示从全局 state 读取（默认顶/底 `1.5pt`、中 `0.5pt`）。

== 关闭三线表（`three-line-table: false`）

默认 `captab` 输出三线表（顶/中/底三条手画线，table 自身 `stroke: none`）。如果想要 *Typst 原生网格表*（每个单元格四边都画线），把 `three-line-table` 设为 `false`：

```typst
// 单次调用
#captab(
  caption: [Typst 默认网格表],
  three-line-table: false,
)[
  | 编号 | 名称 | 数值 |
  | ---- | ---- | ---- |
  | 1    | A    | 100  |
]

// 全局
#show: captab-style.with(three-line-table: false)
// 或
#show: cap-style.with(three-line-table: false)
```

`three-line-table: false` 时 `top-rule` / `middle-rule` / `bottom-rule` 全部不生效；`hlines` / `vlines` 用户自定义额外线条仍然有效。Typst 默认网格描边可以通过 `set table(stroke: ...)` 全局调整。

== 透传 `tablem` / `table` 高级用法

除了 captab 自己的命名参数（`columns` / `cols` / `align` / `size` / `leading` / `inset` / `caption…` / `…-rule` / `breakable` / `repeat-…` / `hlines` / `vlines` / `label` 等）以外，*任何其它命名参数*都会原样转发到底层 `table(...)` 调用，与 `tablem` 的 advanced usage 一致。可以用的参数包括：

- `fill: color | function`（背景色，可按 `(x, y)` 函数返回不同颜色）
- `stroke: stroke | function | dictionary`（按单元格控制描边）
- `gutter` / `column-gutter` / `row-gutter`
- `rows`
- 其它任何 Typst `table()` 接受的命名参数

```typst
#let frame(stroke) = (x, y) => (
  left: if x > 0 { 0pt } else { stroke },
  right: stroke,
  top: if y < 2 { stroke } else { 0pt },
  bottom: stroke,
)

#captab(
  caption: [月度阅读列表],
  three-line-table: false,                                // 用全网格而不是三线
  columns: (0.4fr, 1fr, 1fr),
  align: left,
  fill: (_, y) => if calc.odd(y) { rgb("EAF2F5") },        // 隔行底色
  stroke: frame(rgb("21222C")),                            // 自定义描边
)[
  | *Month*  | *Title*               | *Author*            |
  | -------- | --------------------- | ------------------- |
  | January  | The Great Gatsby      | F. Scott Fitzgerald |
  | February | To Kill a Mockingbird | Harper Lee          |
]
```

#let frame(stroke) = (x, y) => (
  left: if x > 0 { 0pt } else { stroke },
  right: stroke,
  top: if y < 2 { stroke } else { 0pt },
  bottom: stroke,
)

#captab(
  caption: [月度阅读列表],
  three-line-table: false,                                // 用全网格而不是三线
  columns: (0.4fr, 1fr, 1fr),
  align: left,
  fill: (_, y) => if calc.odd(y) { rgb("EAF2F5") },        // 隔行底色
  stroke: frame(rgb("21222C")),                            // 自定义描边
)[
  | *Month*  | *Title*               | *Author*            |
  | -------- | --------------------- | ------------------- |
  | January  | The Great Gatsby      | F. Scott Fitzgerald |
  | February | To Kill a Mockingbird | Harper Lee          |
]

== 跨页

0.1.0 起 `captab` 默认允许长表跨页。两个相关参数：

- `breakable`（bool，默认 `true`）—— 是否允许跨页。`false` 时整张表保持原子性，超长会被压在同一页。
- `repeat-header`（bool / int，默认 `true`）—— 跨页时重复表头行（基于 Typst 原生 `table.header(repeat: ..)`）。`true` 在每个续页都重复；传入正整数 `n` 表示只在前 `n` 个续页重复；`false` 关闭重复。
- `continued-caption`（bool，默认 `false`）—— 跨页时是否在每个续页顶部再渲染一次"续表 X.Y caption"（与 `refer-to` 模式同款格式）。第一页仍显示完整原标题。

```typst
#captab(
  caption: [长数据表],
  breakable: true,         // 允许跨页（默认）
  repeat-header: true,     // 跨页时重复表头（默认）
  continued-caption: true,    // 续页带"续表 X.Y"标题
)[
  | 编号 | 名称 | 数值 |
  | ---- | ---- | ---- |
  // ...
]
```

或在全局配置：

```typst
#show: captab-style.with(
  breakable: true,
  repeat-header: true,
  continued-caption: true,
)
```

#captab(
  caption: [长数据表],
  breakable: true,         // 允许跨页（默认）
  repeat-header: true,     // 跨页时重复表头（默认）
  continued-caption: true,    // 续页带"续表 X.Y"标题
)[
  | 编号 | 名称   | 数值  |
  | ---- | ------ | ----- |
  | 001  | 苹果   | 12.50 |
  | 002  | 香蕉   | 8.30  |
  | 003  | 橙子   | 15.00 |
  | 004  | 葡萄   | 22.80 |
  | 005  | 西瓜   | 35.60 |
  | 006  | 芒果   | 18.90 |
  | 007  | 菠萝   | 25.40 |
  | 008  | 草莓   | 28.70 |
  | 009  | 蓝莓   | 45.20 |
  | 010  | 桃子   | 16.40 |
  | 011  | 梨     | 10.80 |
  | 012  | 樱桃   | 52.30 |
  | 013  | 柚子   | 19.60 |
  | 014  | 火龙果 | 21.50 |
  | 015  | 猕猴桃 | 14.30 |
  | 016  | 哈密瓜 | 32.90 |
  | 017  | 椰子   | 26.80 |
  | 018  | 荔枝   | 38.40 |
  | 019  | 龙眼   | 24.70 |
  | 020  | 山竹   | 48.50 |
]

*实现说明*：`continued-caption` 不会重复登记 figure 编号——续页通过 `query(label)` 查询主表位置、读取计数器值、走 `_make_caption_content` 的 refer-to 分支生成"续表 X.Y …"。如果用户没传 `label`，cap-able 会自动合成一个隐藏 label（`__captab_repeat_<n>`）仅供内部检索。caption 行与表头行被放进两个独立的 `table.header`（用 `level: 1/2` 分层），所以 `continued-caption: true` 与 `repeat-header: false` 可以共存——caption 重复但表头不重复。

`refer-to` 显式续表（手动拆表）仍然保留，适合需要分别在不同位置/不同章节插入的"续表"。

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

cap-able 支持两种续表方式，按使用场景挑：

+ *自动跨页 + 续页重复题注（推荐，0.1.0 起）* —— 让 `captab` 自然跨页，每个续页顶部自动出现"续表 X.Y"。
+ *手动 `refer-to`（一直保留）* —— 手动把表拆成两段以上，第二段用 `refer-to` 引用原表。适合需要在两段之间插入文字、图片或其它续表逻辑的场景。

=== 自动跨页 + 续页重复题注

只要给 `captab` 加 `continued-caption: true`（`breakable` 默认就是 `true`），cap-able 会用 Typst 原生 `table.header(repeat: ...)` 在每个续页顶部重新输出"续表 X.Y"。编号锁定到主表，不重复登记 figure。

```typst
#captab(
  caption: [长数据表],
  caption-en: [Long Data Table],
  continued-caption: true,         // 续页带"续表 X.Y"标题
  // breakable: true,           // 默认就是 true
  // repeat-header: true,       // 默认表头也跟着重复
  label: <tab:long-auto>,
)[
  | ID | 数值 |
  | -- | ---- |
  | 1  | 100  |
  | 2  | 200  |
  | 3  | 300  |
  // ...
]
```

如果只想关掉 markdown 表头跨页重复但保留题注重复，传 `repeat-header: false`。如果连题注也不想重复（仅让表自然跨页），保持 `continued-caption: false`（默认）即可。

#block(
  fill: rgb("#ecfeff"),
  stroke: 0.5pt + rgb("#06b6d4"),
  radius: 4pt,
  inset: 8pt,
)[
  *推荐用途*：长数据表、需要全自动跨页的场景。一行 `continued-caption: true` 搞定，不需要手动拆表，也不需要写两遍 caption。
]

#block(
  fill: rgb("#fff7ed"),
  stroke: 0.5pt + rgb("#f97316"),
  radius: 4pt,
  inset: 8pt,
)[
  *已知限制*：`continued-caption: true` 与 `caption-position: bottom` 不兼容。前者依赖 `table.header(repeat: true)` 把续页题注嵌入表内顶部；要做到"每页底部"重复就只能用 `table.footer`，但那样题注会被锁在表的列宽里，视觉上"嵌进表内"，不符合"caption-position: bottom = 表外、表下方"的语义。

  这两者同时设置时，cap-able 会*静默关闭 repeat*——等同 `continued-caption: false`，原始题注仅在最后一页表格下方出现一次。如果需要每页底部都重复题注，请改用 `caption-position: top`。
]

=== 手动 `refer-to`（保留方式）

如果需要在原表和续表之间插入说明文字、注脚、或者额外的列结构调整，则用 `refer-to` 显式拆表：

```typst
#set text(lang: "zh")

// 原表
#captab(
  caption: [长数据表],
  caption-en: [Long Data Table],
  label: <tab:long>,        // 设置标签，供续表引用
)[
  | ID | 数值 |
  | -- | ---- |
  | 1  | 100  |
]

这里可以插入任意中间内容（说明文字、配图等）

// 续表（手动接续）
#captab(
  caption: [长数据表],        // 可提供相同标题，也可省略
  caption-en: [Long Data Table],
  refer-to: <tab:long>,       // 引用原表获取编号
)[
  | ID | 数值 |
  | -- | ---- |
  | 2  | 200  |
]
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

这里可以插入任意中间内容（说明文字、配图等）

#captab(
  caption: [长数据表],
  caption-en: [Long Data Table],
  refer-to: <tab:long>,
  show-caption: true,         // 强制显示标题文本（默认 auto 时 caption 不为空也会显示）
)[
  | ID | 数值 |
  | -- | ---- |
  | 2  | 200  |
]

#set text(lang: "en")

无论用哪种方式，续表都会自动：

- 使用与原表相同的编号
- 添加"续表 X"或"表 X（续）"前缀/后缀
- 不在目录中新建条目

=== 续表模式

通过 `continued-mode` 参数控制续表样式（两种续表方式都适用）：

- `"prefix"`（默认）：前缀模式，如"续表 1"
- `"suffix"`：后缀模式，如"表 1（续）"

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

=== overlay 与 subcaption 解耦：dict 形式的 `label-style`

默认情况下，*图上叠加的标签*（`label-mode: "overlay"`）和 *subcaption 前缀的编号* 共用同一份 `label-style`——传字符串就够了，两边永远保持一致。

如果想分别控制，把 `label-style` 写成字典：

```typst
#capsubfig(
  caption: [图上简洁，subcaption 完整],
  show-subcaption: true,
  label-mode: "overlay",
  label-style: (overlay: "a)", subcaption: "(a)"),    // 图上 "a)"，标题 "(a) caption"
  (
    (content: img1, subcaption: [子图说明 1]),
    (content: img2, subcaption: [子图说明 2]),
  ),
)
```

字典里 `overlay` 控制图上叠加的样式，`subcaption` 控制 subcaption 前缀的样式；缺失的键会回退到包默认 `"(a)"`。两边都缺则等价于默认值。

*交叉引用字母的来源*：跟随实际可见的那一侧——subcaption 可见时（`show-subcaption: true` 且 `show-subcaption-label: true`）以 subcaption 样式为准；否则若 `label-mode: "overlay"` 则用 overlay 样式；两者都没可见编号时回退 subcaption。这样保证"读者眼里看到的字母"与 `@fig:xxx` 渲染出的字母始终一致。

=== subcaption 编号与正文之间的间距

subcaption 前缀编号（如 `"(a)"`）和正文之间的间距由 `subcaption-number-title-spacing` 控制：

- 默认值 `auto`：继承大题注的 `number-title-spacing`（也就是默认配置里"图 1.1#h(0.5em)caption"那个分隔符），保持视觉一致。
- 全局可在 `capfig-style(subcaption-number-title-spacing: ...)` 一次性设置。
- per-call 可在 `capsubfig(subcaption-number-title-spacing: ...)` 单独覆盖。

```typst
#capsubfig(
  caption: [per-call 改成 " — "],
  show-subcaption: true,
  label-mode: "overlay",
  subcaption-number-title-spacing: [ — ],
  (...),
)
```

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

=== `subref-style`：让 `@ref` 跟随 `label-style` 装饰

默认 `subref-style: "letter"`——`@fig:sub-a` 渲染成 `图 1a`（仅字母）。

设为 `"full"` 后，*交叉引用同样保留 `label-style` 的前后缀装饰*：

```typst
#capsubfig(
  ...
  label-style: "(a)",
  subref-style: "full",        // ← 让 @ref 也带括号
)
```

渲染：`@fig:sub-a` → `图 1(a)`，与 subcaption 前缀样式视觉一致。

也支持中文前缀（`label-style: "图a"` + `"full"` → `图 1图a`）、方括号（`"[A]"` → `图 1[A]`）等。`label-sep` 在 `"full"` 模式下默认空字符串，因为装饰本身已提供视觉分隔；如果需要不同分隔符可显式覆盖。

可在 `capfig-style(subref-style: "full")` 全局，或 `capsubfig(subref-style: ...)` per-call 设置。

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

cap-able *默认不固定表宽*——`width: auto` 时表格按内容自然撑开，没多宽就没多宽，不会被强制拉到文本区宽度。具体逻辑由 `columns` 决定：

- *用户没传 `columns`*：默认列宽是 `(auto,) * N`，表按 *内容宽度* 排（一行 `| A | B | C |` 就只占三个字宽）。
- *用户传了 `columns`*：尊重用户写法。
  - `(1fr, 1fr, 1fr)` → fr 列依然撑开，但因为外层没有固定宽度的 block，受限于父容器，实际表现取决于上下文。
  - `(8cm, 4cm)` → 表 12cm 宽，居中。

要 *固定表宽*，三种方式：

```typst
// (1) 单次调用 captab(width: ...)
#captab(caption: [窄表], width: 60%)[ ... ]
#captab(caption: [绝对宽], width: 8cm)[ ... ]
#captab(caption: [小数百分比], width: 80.5%)[ ... ]

// (2) 全局 captab-style，之后的 captab 都跟随
#show: captab-style.with(width: 70%)

// (3) 全局 set-table-width，从这往后所有 captab 都跟随
#set-table-width(width: 50%)         // 新写法
#set-table-width(percentage: 50)     // 旧写法仍可用（int 1-100，自动转成 ratio）
```

固定表宽时（`width != auto`），如果用户没传 `columns`，cap-able 默认改用 `(1fr,) * N`，让表格自动填满 `width` 设定的宽度。

`width` 接受三种类型：

#table(
  columns: (1fr, 3fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*类型*][*说明 / 示例*],
  table.hline(stroke: 0.5pt),
  [`auto`], [不固定（默认）。表格按内容宽度自然撑开。],
  [`<length>`], [绝对宽度。例如 `8cm`、`120pt`。],
  [`<ratio>`], [文本宽度的百分比，支持小数。例如 `80%`、`80.5%`。],
  table.hline(stroke: 1.5pt),
)

优先级：*per-call `captab(width:)`* > *全局 state*（由 `captab-style` / `set-table-width` 写入） > *默认 `auto`*。

```typst
#show: captab-style.with(width: 70%)

#captab(caption: [跟随全局 70%])[ ... ]                  // 70% 宽
#captab(caption: [覆盖为 50%], width: 50%)[ ... ]        // 50% 宽
```

#captab(caption: [示例：50% 宽], width: 50%)[
  |A|B|
  |C|D|
]

== 自定义编号格式

`numbering-format` 接受任何 *Typst 原生 `numbering()`* 能消费的格式——大部分需求改一行就够。

=== 字符串格式

只要包含格式占位符（`1` 阿拉伯、`a/A` 字母、`i/I` 罗马），其余字符当作字面量原样输出：

#table(
  columns: (1fr, 2fr, 2fr),
  stroke: none,
  inset: 6pt,
  table.hline(stroke: 1.5pt),
  table.header[*格式串*][*渲染*][*用法*],
  table.hline(stroke: 0.5pt),
  [`"1"`],          [1, 2, 3, ...],          [纯阿拉伯（默认）],
  [`"(A)"`],        [(A), (B), (C), ...],    [字母 + 括号],
  [`"附 1"`],       [附 1, 附 2, ...],       [中文字面量 + 数字],
  [`"1.1"`],        [1.1, 1.2, 2.1, ...],    [章节.序号（需 `use-chapter: true`）],
  [`"I.A"`],        [I.A, I.B, II.A, ...],   [罗马章 + 字母编号],
  [`"§1-A"`],       [§1-A, §1-B, ...],       [符号 + 章 + 字母],
  table.hline(stroke: 1.5pt),
)

`use-chapter: true` 时格式串里 *最后一个* 占位符当作图/表自身编号，*前面 N-1 个* 当 heading 层级前缀（依次对应 `=`、`==`、`===` ...）。比如 `"I.1.1.A"` 在 `=== 2.3.4` 下第 5 张表渲染为 `II.3.4.E`。

=== 函数式格式（高阶）

`numbering-format` 也接受函数，跟 Typst 原生 `numbering((..nums) => ..., 1, 2)` 完全等价——所有 `numbering()` 能做到的它都能做：

```typst
#show: captab-style.with(
  use-chapter: false,
  numbering-format: (..nums) => {
    let n = nums.pos().last()
    [Tab§#n]                     // 输出 "Tab§1"、"Tab§2"...
  },
)
```

`use-chapter: true` 时，函数会收到 *所有 heading 层级编号 + 图/表自身编号* 作为参数（不会按格式串切片）：

```typst
#show: captab-style.with(
  use-chapter: true,
  numbering-format: (..nums) => {
    let arr = nums.pos()
    let chap = arr.slice(0, arr.len() - 1)   // 章节链
    let n = arr.last()                        // 图/表号
    [§#chap.map(str).join(".")—#n]           // "§2.3—5"
  },
)
```

=== 表与图分别 vs 统一

```typst
// 完全分开（推荐）
#show: captab-style.with(numbering-format: "1.1")    // 表用 1.1, 1.2
#show: capfig-style.with(numbering-format: "I.1")    // 图用 I.1, I.2

// 统一通过 cap-style
#show: cap-style.with(numbering-format: "1.1")       // 表图都是 1.1
```

=== 完全 bypass cap-able 的逃生通道

cap-able 通过 `set figure(numbering: ...)` 在 `captab-style` / `capfig-style` 内部配置编号回调。如果上面所有形式都不够用，*在 cap-style 调用之后* 自己写一遍 `set figure(...)` 就能完全替换：

```typst
#show: cap-style.with(...)
#set figure.where(kind: table): set figure(numbering: num => [#sym.section.bold #num])
```

但这样会绕过双语 supplement / continued 前缀等 cap-able 的 show rule，使用前先确认你不需要那些功能。

== 题注字体细粒度控制 `caption-text`

cap-able 的题注 *不是* 真正的 `figure.caption` 元素（为了支持双语布局，是 cap-able 自己手写 `text(...)` 渲染的），所以 `show figure.caption: set text(font: ...)` *无效*。要改题注字体/颜色/字距等，请用 `caption-text` 字段。

`caption-text` 接受 *Typst 原生 `text()` 的任何参数*（`font`、`fill`、`tracking`、`spacing`、`stretch` 等），并且支持 *扁平* 与 *分层* 两种形式：

=== 扁平形式 —— 整个题注

```typst
#show: cap-style.with(
  caption-text: (font: "Times New Roman", fill: blue),
)
```

整个题注（前缀 + 数字 + 正文）统一应用。

=== 分层形式 —— 按部件分别设置

只要字典里出现 `whole` / `prefix` / `supplement` / `number` / `body` 中*任一*键，就视为分层模式：

#table(
  columns: (1fr, 4fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*层*][*作用范围*],
  table.hline(stroke: 0.5pt),
  [`whole`],      [整个题注（外层默认）],
  [`prefix`],     [前缀块（supplement + 数字）],
  [`supplement`], [仅 supplement 词（"Table" / "图"）],
  [`number`],     [仅数字（"1" / "1.1" / "II.3.4.E" 等）],
  [`body`],       [仅正文（用户传入的标题文本）],
  table.hline(stroke: 1.5pt),
)

层间为 *嵌套覆盖*：内层覆盖外层。例：

```typst
#show: cap-style.with(
  caption-text: (
    whole:  (font: "Helvetica"),       // 外层默认 Helvetica
    number: (fill: red, weight: "bold"),  // 数字额外红色加粗
    body:   (font: "SimSun"),          // 正文换宋体
  ),
)
```

渲染结果：supplement 是 Helvetica；数字是 Helvetica 红色粗体；正文是宋体。

=== 常见用法

```typst
// 1. 整题注换字体
caption-text: (font: "Times New Roman")

// 2. 仅数字红色（"Table 1.1"，只 1.1 红）
caption-text: (number: (fill: red))

// 3. 编号粗体罗马，正文宋体常规
caption-text: (
  prefix: (font: "Times New Roman", weight: "bold"),
  body:   (font: "SimSun"),
)

// 4. supplement 等宽，数字 Times，正文 Helvetica
caption-text: (
  supplement: (font: "Courier"),
  number:     (font: "Times New Roman"),
  body:       (font: "Helvetica"),
)
```

=== 性质

- 默认 `(:)` 完全不影响现有渲染（不破坏老用户）
- 与 `caption-size` / `caption-weight` 同时存在时——dict 里同名键 *优先*（覆盖层）
- 暴露在 `cap-style` / `captab-style` / `capfig-style`
- *续表标题也生效*（包括 `continued-caption: true` 时的续页题注、`refer-to` 模式的续表题注）

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
  columns: (1fr, 1.4fr, 3fr),
  stroke: none,
  inset: 5pt,
  table.hline(stroke: 1.5pt),
  table.header[*参数*][*类型*][*说明*],
  table.hline(stroke: 0.5pt),
  [`width`], [`auto` / `length` / `ratio`], [新 API。`auto` = 不固定；`8cm` / `80%` / `80.5%` 等],
  [`percentage`], [`int` (1–100)], [旧 API（向后兼容）。会被转换为 `<int>%`],
  table.hline(stroke: 1.5pt),
)

同时传入时 `width` 优先。

```typst
#set-table-width(width: 80%)        // 新写法
#set-table-width(width: 8cm)        // 绝对宽度
#set-table-width(width: auto)       // 恢复不固定
#set-table-width(percentage: 80)    // 旧写法仍可用
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
  [`numbering-format`], [`"1"`], [编号格式：任何 Typst 原生 `numbering()` 接受的字符串（`"1.1"`、`"A.1"`、`"附 1"` 等）或函数形式 `(..nums) => content`],
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
  [`caption-text`], [`(:)`], [题注 `text(...)` 透传字典：扁平形式（如 `(font: "Times")`）作用于整体；分层形式（含 `whole`/`prefix`/`supplement`/`number`/`body` 任一键）按层覆盖。详见"题注字体细粒度控制"段落],
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
  [`caption-position`], [`auto`], [#raw("#bicap()[body]") 模式下题注位置（同时作用于 table/figure；`auto` = 各自保留 kind 默认）],
  [`caption-align`], [`auto`], [题注水平对齐：字符串 `"center"` / `"left"` / `"right"` / `"text-left"` / `"text-right"`，或 dict `(main: ..., continued: ...)` 拆分主与续],
  [`placement`], [`none`], [浮动定位：`none`（原地）/ `top` / `bottom`（浮到顶/底）/ `auto`（Typst 自动按距离选 top/bottom）；启用浮动时强制 `breakable: false`],
  table.hline(stroke: 1.5pt),
)

*未在 `cap-style` 列出的参数* —— 表格专属（`body-size` / `body-leading` / `cell-inset` / `inset` / `table-below` / `width` / `three-line-table` / `top-rule` / `middle-rule` / `bottom-rule` / `breakable` / `repeat-header` / `continued-caption`）和图片专属（`figure-above` / `figure-below` / `subcaption-*` / `gutter` / 子图标签 `label-*`）—— 仍需通过 `captab-style` / `capfig-style` 单独配置。

#pagebreak()

== `captab-style` 完整参数

以下是 `captab-style` 的所有参数及默认值。`auto` 表示按文档语言自动选择。

#block(
  fill: rgb("#eef6ff"),
  stroke: 0.5pt + rgb("#3b82f6"),
  radius: 4pt,
  inset: 8pt,
)[
  *patch 语义*：所有参数的实际默认值均为 `auto`，表示"保持当前 state 不变"。下表"默认"列展示的是首次未配置时的初始值。多次调用 `captab-style.with(...)` 时仅传入的字段会被覆盖，未传入字段会保留之前的设置 —— 因此可以连续 patch 多个不同维度的样式而不必每次重写所有参数。
]


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
  [`numbering-format`], [`"1"`], [编号格式：任何 Typst 原生 `numbering()` 接受的字符串（`"1.1"`、`"A.1"`、`"I.1"`、`"附 1"` 等含字面量）或函数 `(..nums) => content`（详见"自定义编号"段落）],
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
  [`caption-text`], [`(:)`], [题注 `text()` 透传字典；扁平形式作用整体，分层形式（`whole`/`prefix`/`supplement`/`number`/`body`）按层覆盖],
  [`pre-supplement-number-spacing`], [`auto`], [前缀与编号间距],
  [`post-supplement-number-spacing`], [`auto`], [编号与后缀间距],
  [`number-title-spacing`], [`auto`], [编号与主语言标题间距],
  [`number-title-spacing-en`], [`auto`], [编号与英文标题间距],
  [`lang`], [`auto`], [语言代码覆盖（`auto` 跟随 `text.lang`）],
  [`enable-english-caption`], [`true`], [是否生成英文副标题],
  [`body-size`], [`10.5pt`], [表格内容字号],
  [`body-leading`], [`0.45em`], [表格内容行距],
  [`cell-inset`], [`(x: 5pt, y: 5pt)`], [单元格内边距（字典或标量）；与 `inset` 互为别名，同时传入时 `cell-inset` 优先],
  [`inset`], [`auto`], [`cell-inset` 的别名（与 captab 形参的 `inset` 命名一致）],
  [`note-above`], [`0.5em`], [表注上方间距],
  [`note-below`], [`1em`], [表注下方间距],
  [`note-size`], [`10.5pt`], [表注字号],
  [`note-leading`], [`6.5pt`], [表注行距],
  [`note-justify`], [`true`], [表注是否两端对齐],
  [`outline-bilingual`], [`false`], [目录双语显示],
  [`outline-separator`], [`" / "`], [目录双语分隔符],
  [`outline-newline`], [`false`], [目录双语是否换行],
  [`after-indent`], [`auto`], [表格后首行缩进修复（`auto` 按语言）],
  [`width`], [`auto`], [表格宽度。`auto`=不固定（按内容撑开）；`<length>` 如 `8cm`；`<ratio>` 如 `80%` / `80.5%`],
  [`three-line-table`], [`true`], [是否使用三线表样式（`false` 时跳过手动三线，使用 Typst 默认 `table()` 网格描边）],
  [`top-rule`], [`1.5pt`], [三线表顶线 stroke（接受任何 stroke 值，如 `2pt + red`；仅 `three-line-table: true` 时生效）],
  [`middle-rule`], [`0.5pt`], [三线表中线 stroke],
  [`bottom-rule`], [`1.5pt`], [三线表底线 stroke],
  [`extra-rule`], [`0.5pt`], [`hlines` / `vlines` 中未单独指定 `stroke` 时的默认 stroke；接受单值或 dict `(h: ..., v: ...)` 拆分横/竖线],
  [`breakable`], [`true`], [表格能否跨页（外层 block 的 `breakable`）],
  [`repeat-header`], [`true`], [跨页时是否重复 markdown 表头行（`true` / `false` / 正整数 `n`）],
  [`show-continued-caption`], [`false`], [跨页时是否在每个续页顶部重复题注（"续表 X.Y"格式，复用 refer-to 渲染）。旧名 `continued-caption` 仍兼容，将于 0.2.0 移除],
  [`caption-position`], [`top`], [#raw("#bicap()[body]") 模式下题注相对 body 的位置（`top` / `bottom`）],
  [`caption-align`], [`"center"`], [题注水平对齐：`"center"` / `"left"` / `"right"`（表局部）/ `"text-left"` / `"text-right"`（正文宽）；或 dict `(main, continued)` 拆分主与续],
  [`placement`], [`none`], [浮动定位：`none` / `top` / `bottom` / `auto`（启用浮动时强制 `breakable: false`）],
  table.hline(stroke: 1.5pt),
)

*间距参数可以是长度或内容*：任何 `*-spacing` 或 `pre/post-supplement-number-spacing` 支持长度（如 `0.5em`）或直接内容（如 `[\u{3000}]` 全角空格）。

== `capfig-style` 完整参数

`capfig-style` 合并了图片样式配置、图片间距和子图默认值，一次性更新全部图片相关状态。

#block(
  fill: rgb("#eef6ff"),
  stroke: 0.5pt + rgb("#3b82f6"),
  radius: 4pt,
  inset: 8pt,
)[
  *patch 语义*：与 `captab-style` 一致，所有参数默认 `auto`，仅传入字段会覆盖之前的设置。下表"默认"列展示初始 state 字典中的值。
]


*题注/编号/语言部分*

#table(
  columns: (1.8fr, 1fr, 2.5fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*参数*][*默认*][*说明*],
  table.hline(stroke: 0.5pt),
  [`numbering-format`], [`"1"`], [编号格式：任何 Typst 原生 `numbering()` 接受的字符串（`"1.1"`、`"A.1"`、`"附 1"` 等）或函数形式 `(..nums) => content`],
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
  [`caption-text`], [`(:)`], [题注 `text()` 透传字典（同 captab-style）],
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
  [`subcaption-number-title-spacing`], [`auto`], [子标题"编号-正文"分隔符（`auto` 继承大题注的 `number-title-spacing`；可传 content/length）],
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
  [`label-style`], [`"(a)"` / dict], [标签样式：传 `str` 时 overlay 与 subcaption 共用；传 `(overlay: ..., subcaption: ...)` 字典可分别指定（缺失键回退 `"(a)"`）],
  [`label-font`], [`("Arial",)`], [标签字体列表],
  [`label-size`], [`12pt`], [标签字号],
  [`label-offset`], [`(4pt, 4pt)`], [标签偏移 `(dx, dy)`],
  [`label-text-color`], [`black`], [标签文字颜色],
  [`label-stroke`], [`none`], [标签描边],
  [`label-bg`], [`none`], [标签背景色],
  [`label-bg-shape`], [`"rect"`], [背景形状 `"rect"` / `"circle"`],
  [`label-bg-radius`], [`2pt`], [矩形圆角],
  [`label-bg-inset`], [`3pt`], [背景内边距],
  [`label-sep`], [`auto`], [子图引用分隔符（`auto`：数字 → `"."`，字母 → `""`；`subref-style: "full"` 模式下默认 `""`）],
  [`subref-style`], [`"letter"`], [子图交叉引用字母样式：`"letter"`（仅字母，如 `图 1a`）/ `"full"`（带 label-style 装饰，如 `图 1(a)`）],
  [`caption-position`], [`bottom`], [#raw("#bicap()[body]") 模式下题注相对 body 的位置（图片默认 `bottom`）],
  [`caption-align`], [`"center"`], [题注水平对齐：`"center"` / `"left"` / `"right"` / `"text-left"` / `"text-right"`；或 dict `(main, continued)`],
  [`placement`], [`none`], [浮动定位：`none` / `top` / `bottom` / `auto`],
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
  [`columns`], [`auto` / `int` / `array`], [列配置（推荐用法，`auto` 或长度数组，支持 `fr` 与绝对单位）],
  [`cols`], [`auto` / `int` / `array`], [#`columns` 的向后兼容别名（同时传入时 `columns` 优先）],
  [`align`], [`auto` / `alignment` / `array` / `function`], [单元格对齐；与 markdown `:---:` 语法合并（透传给 tablem 后再回到 `table.align`）],
  [`size`], [`auto` / `length`], [内容字号（`auto` 取全局 `body-size`）],
  [`leading`], [`auto` / `length`], [内容行距（`auto` 取全局 `body-leading`）],
  [`inset`], [`auto` / `length` / `dictionary`], [单元格内边距（与 `cell-inset` 互为别名；同时传入时 `cell-inset` 优先）],
  [`cell-inset`], [`auto` / `length` / `dictionary`], [`inset` 的别名（与全局 `captab-style.cell-inset` 命名一致）],
  [`caption`], [`none` / `content`], [主语言标题],
  [`caption-en`], [`none` / `content`], [英文标题],
  [`refer-to`], [`none` / `label`], [续表引用的原表标签],
  [`show-caption`], [`auto` / `bool`], [续表是否显示标题文本],
  [`width`], [`auto` / `length` / `ratio`], [表格宽度（`auto` 取全局，默认 `auto` 不固定；可传 `8cm` / `80%` / `80.5%`）],
  [`caption-position`], [`auto` / `top` / `bottom`], [题注位置（`auto` 取全局 `caption-position`，默认 `top`；`bottom` 把题注放表下方；与 `continued-caption: true` 同时设置时 `continued-caption` 静默失效）],
  [`caption-align`], [`auto` / `str` / `dict`], [题注水平对齐：`"center"` / `"left"` / `"right"`（表局部）/ `"text-left"` / `"text-right"`（正文宽）；或 dict `(main, continued)` 拆分主与续；`auto` 取全局],
  [`placement`], [`none` / `top` / `bottom` / `auto`], [浮动定位（`none` 原地、`top`/`bottom` 浮到页顶/底、`auto` Typst 按距离自动选）；不传则跟随全局，状态初始 `none`；启用浮动时强制 `breakable: false`],
  [`three-line-table`], [`auto` / `bool`], [是否使用三线表样式（`auto` 取全局 `three-line-table`，默认 `true`）],
  [`top-rule`], [`auto` / `stroke`], [顶线 stroke（`auto` 取全局 `top-rule`，默认 `1.5pt`；仅 `three-line-table: true` 时生效）],
  [`middle-rule`], [`auto` / `stroke`], [中线 stroke（`auto` 取全局 `middle-rule`，默认 `0.5pt`）],
  [`bottom-rule`], [`auto` / `stroke`], [底线 stroke（`auto` 取全局 `bottom-rule`，默认 `1.5pt`）],
  [`extra-rule`], [`auto` / `stroke` / `dict`], [`hlines` / `vlines` 缺省 stroke 时的默认值；接单值或 dict `(h: ..., v: ...)` 分别指定横/竖线（缺失键回退包默认 `0.5pt`）；per-line `stroke` 仍可单独覆盖],
  [`breakable`], [`auto` / `bool`], [是否允许跨页（`auto` 取全局 `breakable`，默认 `true`）],
  [`repeat-header`], [`auto` / `bool` / `int`], [跨页时是否重复表头行（`auto` 取全局 `repeat-header`）],
  [`show-continued-caption`], [`auto` / `bool`], [跨页时是否在每个续页顶部重复题注（"续表 X.Y"格式）。旧名 `continued-caption` 仍兼容，0.2.0 移除；两者都传时新名优先],
  [`hlines`], [`array` of `int` / `dictionary`], [额外横线数组；元素可为 `int`（简写，等价 `(row: N)`）或完整 dict],
  [`vlines`], [`array` of `int` / `dictionary`], [额外竖线数组；元素可为 `int`（简写，等价 `(col: N)`）或完整 dict],
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

从 0.1.0 起 `bicap` 同时支持 *两种调用形式*：

- *仅题注*：`#bicap(caption: ..., kind: ...)` —— 在独立的不换页 block 里只渲染题注。
- *题注 + body*：`#bicap(caption: ..., kind: ...)[body]` —— 把 `body` 与题注一起包进同一个不换页 block，相当于 cap-able 风味的 `figure(body, caption: ...)`。`body` 也可以用名参 `body: [...]` 传。

题注与 body 的相对位置由 `caption-position` 控制：

- 默认值跟随全局 state：table 的初始 state 是 `top`，figure 是 `bottom`。
- 全局可在 `captab-style` / `capfig-style` 里通过 `caption-position: top | bottom` 覆盖。
- 单次调用可在 `bicap` 上用 `position: top | bottom` 直接覆盖。

=== 题注水平对齐 `caption-align`

`caption-align` 控制题注在水平方向上相对表/图与正文区的对齐位置，5 个取值：

#table(
  columns: (1fr, 4fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*取值*][*语义*],
  table.hline(stroke: 0.5pt),
  [`"center"`（默认）], [题注在表/图自身宽度内居中（与现状一致）],
  [`"left"`],   [与表/图的左边缘对齐（表/图局部）],
  [`"right"`],  [与表/图的右边缘对齐（表/图局部）],
  [`"text-left"`],  [与正文区的左边缘对齐（不论表/图多宽）],
  [`"text-right"`], [与正文区的右边缘对齐],
  table.hline(stroke: 1.5pt),
)

`width: 100%` 时表/图填满正文宽，`"left" ≡ "text-left"`、`"right" ≡ "text-right"`，自然退化。

*主标题与续表标题分别设置* —— 传 dict：

```typst
#captab(
  caption-align: (main: "left", continued: "right"),
  continued-caption: true,
  ...
)[ ... ]
```

`main` 控制首次出现的主标题，`continued` 控制 `continued-caption: true` 时每个续页顶部的"续表 X.Y"标题；缺失键回退 `"center"`。

*暴露面*：
- 全局：`cap-style(caption-align: ...)`、`captab-style`、`capfig-style`
- per-call：`captab(caption-align: ...)`、`bicap(caption-align: ...)`

#block(
  fill: rgb("#fff7ed"),
  stroke: 0.5pt + rgb("#f97316"),
  radius: 4pt,
  inset: 8pt,
)[
  *已知限制：续表标题的 `text-left` / `text-right` 静默降级*

  `continued-caption: true` 启用的*续页题注*实现上是嵌入 `table.header(level: 1, repeat: true)` 内的 cap-cell——*结构上锁在表的列宽内*，没法跨出去对齐到正文区的左/右边缘。我们尝试过 `place()`、`set page(footer: ...)` 等绕道，但都会引入新 bug（坐标失稳、覆盖用户页脚等），所以选择诚实降级而不是不稳定的"魔术"。

  当 `caption-align`（包括 dict 形式的 `continued` 那一侧）传 `"text-left"` / `"text-right"` 时，*续表标题侧* 会静默退回 `"left"` / `"right"`（按表的列宽对齐），主标题侧不受影响。

  *必要时改用手动 `refer-to`*：把表拆成几段，每段用 `captab(refer-to: <main>, caption-align: "text-left", ...)` 单独写续表段——这样续表标题在表外、走完整正文宽，5 种对齐都精确支持。
]

=== 浮动定位 `placement`

类似 Typst 原生 `figure(placement: ...)`：让表/图脱离文档流，*浮动到当前页或下一页* 的顶部 / 底部，正文继续填充剩余空间。等价于 LaTeX 的 `[t]` / `[b]`。

#table(
  columns: (1fr, 4fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*取值*][*语义*],
  table.hline(stroke: 0.5pt),
  [`none`（默认）], [原地渲染（不浮动）],
  [`top`],   [浮到当前页或下一页的*顶部*],
  [`bottom`],[浮到当前页或下一页的*底部*],
  [`auto`],  [让 Typst 自动选 top 或 bottom（按距离当前位置近的一边）],
  table.hline(stroke: 1.5pt),
)

```typst
#captab(caption: ..., placement: top)[ ... ]      // 浮顶
#captab(caption: ..., placement: bottom)[ ... ]   // 浮底
#capfig(caption: ..., placement: top)[ ... ]
#bicap(placement: top, ...)[ body ]

// 全局：让所有表都浮到顶部
#show: captab-style.with(placement: top)
```

*暴露面*：
- 全局：`cap-style(placement: ...)`、`captab-style`、`capfig-style`
- per-call：`captab` / `capfig` / `capsubfig` / `bicap`

#block(
  fill: rgb("#fff7ed"),
  stroke: 0.5pt + rgb("#f97316"),
  radius: 4pt,
  inset: 8pt,
)[
  *已知限制*：

  + *浮动禁止跨页*。Typst 的 `place(float: true)` 不允许内容跨页，所以：
    - 启用 `placement: top` / `bottom` 时，cap-able 会*强制把 `breakable` 改为 `false`*——即便用户传了 `breakable: true` 也无效。
    - 长表（高于一页）放进 float 会溢出/裁切：用户应保持 `placement: none` 让表自然跨页。
  + *与 `continued-caption: true` 不兼容*。`continued-caption` 依赖跨页机制，浮动模式下用不上；同时设置时 `continued-caption` 实际不会生效（因为 breakable 被强制 false，没有续页可言）。
  + *交叉引用 `@ref`*：cap-able 把 *隐藏 figure*（counter 注册器）也包进 float wrapper 里，所以 `@ref` 解析到 *float 落地页*，与读者眼中看到的位置一致；这点与 Typst 原生 `figure(placement: ...)` 行为相同。
]

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
  [`position`], [`auto` / `top` / `bottom`], [题注相对 body 的位置（仅在传 body 时生效；`auto` 跟随全局 `caption-position`）],
  [`caption-align`], [`auto` / `str` / `dict`], [题注水平对齐：`"center"` / `"left"` / `"right"` / `"text-left"` / `"text-right"`，或 dict `(main, continued)` 拆主与续；`auto` 取全局],
  [`placement`], [`none` / `top` / `bottom` / `auto`], [浮动定位（`auto` = Typst 按距离选 top/bottom）；启用浮动时强制 `breakable: false`],
  [`breakable`], [`bool`], [外层 block 是否允许跨页（默认 `true`，让 body 内部本身可跨页的内容自然顺延）],
  [`show-continued-caption`], [`auto` / `bool`], [跨页时是否在 body 内每张原生 `#table()` 顶部重复题注（默认 `false`；仅 `kind == "table"` 生效）。旧名 `continued-caption` 仍兼容，0.2.0 移除],
  [`repeat-header`], [`auto` / `bool` / `int`], [覆盖 body 内 `#table()` markdown 表头的 `repeat` 设定（`auto` 不干涉，`true/false/int` 强制覆盖；仅 `kind == "table"` 生效）],
  [`body`], [`none` / `content`], [可选的 body 内容；也可用尾随内容块 `#bicap()[...]` 传入],
  table.hline(stroke: 1.5pt),
)

```typst
// 形式一：仅题注（与 0.0.x 行为一致）
#align(center)[
  #rect(width: 6cm, height: 3cm, fill: gray.lighten(70%))
  #bicap(
    caption: [自定义图片],
    caption-en: [Custom Figure],
    kind: "figure",
    label: <fig:custom>,
  )
]

// 形式二：bicap 同时包 body（kind=table，题注默认在上）
#bicap(
  caption: [实验数据],
  kind: "table",
  label: <tab:exp>,
)[
  #table(
    columns: 3,
    [A], [B], [C],
    [1], [2], [3],
  )
]

// kind=figure，题注默认在下；用 position: top 强制在上
#bicap(
  caption: [示意图],
  kind: "figure",
  position: top,
)[
  #image("foo.png", width: 6cm)
]

// 长表跨页时让题注在每个续页顶部重复（kind:table 才有效）
#bicap(
  caption: [长数据表],
  kind: "table",
  continued-caption: true,
  label: <tab:long>,
)[
  #table(
    columns: 4,
    table.header([编号], [名称], [数值], [备注]),
    // ... 50+ 行数据
  )
]

// 让续页只重复题注、关闭 markdown 表头重复
#bicap(
  caption: [长表],
  kind: "table",
  continued-caption: true,
  repeat-header: false,
)[
  #table(
    columns: 4,
    table.header([列1], [列2], [列3], [列4]),
    // ...
  )
]

// 也可以单独关掉 markdown 表头重复，不开启 continued-caption
#bicap(
  caption: [短表],
  kind: "table",
  repeat-header: false,
)[ #table(columns: 3, table.header([A], [B], [C]), ...) ]
```

#block(
  fill: rgb("#fff7e6"),
  stroke: 0.5pt + rgb("#f59e0b"),
  radius: 4pt,
  inset: 8pt,
)[
  *约定：一个 bicap 里只放一张 `#table()`*。`continued-caption: true` 时 bicap 会用 `show table:` 给 body 内*每张*原生 `#table()` 注入同一个续表标题，这意味着如果你在同一个 bicap 里塞了多张表，所有表的续页都会出现同样的标题——通常不是你想要的。需要分别为多张表写题注时，请用多个 `bicap(...)` 调用，或直接用 `captab` 管理每张表。

  另：bicap 已经检测了 `captab` 自带的 *level≥2* 嵌套 header 结构，如果 body 里是 `captab(continued-caption: true)` 出来的内容，bicap 会跳过自己的注入，避免双层 caption。但*仍然不建议*把 captab 嵌进开了 `continued-caption` 的 bicap 里——语义混乱，编号也容易乱。
]

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

逐子图覆盖 overlay 标签的样式。仅作用于 *overlay* 一侧，subcaption 不参与。

#table(
  columns: (1fr, 3fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*键*][*覆盖的全局参数*],
  table.hline(stroke: 0.5pt),
  [`style`],      [`label-style.overlay`（或 `label-style` 字符串形式）— 该子图 overlay 的格式串，例如 `"[I]"`、`"{1}"`],
  [`font`],       [`label-font` — 字体列表],
  [`size`],       [`label-size` — 字号],
  [`offset`],     [`label-offset` — `(dx, dy)` 偏移],
  [`text-color`], [`label-text-color` — 标签文字颜色],
  [`stroke`],     [`label-stroke` — 标签描边],
  [`bg`],         [`label-bg` — 标签背景色],
  [`bg-shape`],   [`label-bg-shape` — 背景形状],
  [`bg-radius`],  [`label-bg-radius` — 矩形圆角],
  [`bg-inset`],   [`label-bg-inset` — 背景内边距],
  table.hline(stroke: 1.5pt),
)

`style` 还会影响交叉引用：当 ref 跟随 overlay（subcaption 不可见时），`@ref` 的字母按该子图自己的格式渲染。subcaption 可见时 ref 仍跟随全局 subcaption 样式，单图 `style` 覆盖只改图上叠加。

=== 函数参数

除 `subfigs` 外，所有参数皆可为 `auto`（表示继承 `capfig-style` 全局值）：

- `columns`（`auto` / `int`）：每行列数；`auto` 表示所有子图在一行。
- `caption` / `caption-en` / `label` / `refer-to` / `show-caption`：与 `capfig` 同义。
- `gutter`、`subcaption-pos`、`show-subcaption`、`show-subcaption-label`、`align`、`label-mode`、`label-style`、`label-font`、`label-size`、`label-offset`、`label-text-color`、`label-stroke`、`label-bg`、`label-bg-shape`、`label-bg-radius`、`label-bg-inset`、`label-sep`、`subref-style`：覆盖 `capfig-style` 的同名子图默认值。
  - `label-style` 接受 `str`（overlay/subcaption 共用）或 `(overlay: ..., subcaption: ...)` 字典分别指定。缺失键回退包默认 `"(a)"`。
- `figure-above`、`figure-below`、`caption-above`、`subcaption-above`、`subcaption-below`：间距覆盖。
- `subcaption-number-title-spacing`（`auto` / `content` / `length`）：子标题"编号-正文"分隔符。`auto` 继承大题注的 `number-title-spacing`（默认配置里那个分隔符）。

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
    read("/cap-able/0.1.2/src/config.typ"),
    name: "config",
  ),
  show-module-name: false,
  omit-private-definitions: true,
)

== 独立标题模块

标题模块提供核心的双语标题生成引擎，支持主标题和续表/续图两种模式。


#tidy.show-module(
  tidy.parse-module(
    read("/cap-able/0.1.2/src/bicap.typ"),
    name: "bicap",
  ),
  show-module-name: false,
  omit-private-definitions: true,
)

== 三线表模块

三线表模块提供符合学术规范的三线表创建函数及其别名。


#tidy.show-module(
  tidy.parse-module(
    read("/cap-able/0.1.2/src/table.typ"),
    name: "table",
  ),
  show-module-name: false,
  omit-private-definitions: true,
)

== 注释模块

注释模块提供表注和图注功能，支持自动宽度匹配和多种宽度模式。


#tidy.show-module(
  tidy.parse-module(
    read("/cap-able/0.1.2/src/note.typ"),
    name: "note",
  ),
  show-module-name: false,
  omit-private-definitions: true,
)

== 图片模块

图片模块提供单图片和多子图布局函数，支持双语标题、覆盖标签和子标题。


#tidy.show-module(
  tidy.parse-module(
    read("/cap-able/0.1.2/src/figure.typ"),
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

这条仅针对 *手动 `refer-to`* 方式：默认情况下续表在未提供 `caption`（且 `show-caption` 是 `auto`）时只显示"续表 X.Y"编号。要让续表带上完整标题文本：

```typst
#captab(
  refer-to: <tab:original>,
  caption: [原始标题],                      // 提供标题文本
  show-caption: true,                       // 或强制显示
)[...]
```

如果你想*自动跨页*让每个续页顶部都自动出现"续表 X.Y 原始标题"，则用 0.1.0 起的新写法：

```typst
#captab(
  caption: [原始标题],
  continued-caption: true,    // 让 captab 在跨页时把题注复刻到续页顶部
)[...]
```

完整对比见*表格详解 → 续表*一节。

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

== 为什么没有 `capsubtab`（子表）？

cap-able 目前*不提供* `capsubtab`。原因：

1. *学术排版里子表本来就罕见*。绝大多数论文规范都没有专门讲子表，因为更常见的做法是把对照数据合并成 *一张大表 + 加一列"组别"*，而不是拆成 (a)(b) 两张子表。子图（`capsubfig`）在文献里到处都是，子表则属于个位数比例的特殊场景。
2. *跨页问题更严重*。子表一行作为原子块跨页就破版，长内容直接溢出；子图（一般是图片）天生短，跨页问题不突出。
3. *用户已有出路*。需要并排两张小表时，`grid` + 多个 `captab(caption: none)` + 外层 `figure(kind: table, ...)` 组合就能凑出来；唯一缺失的是子表 `@tab:sub-a` cross-reference 自动解析成 "1.2a" 这种语法，但绝大多数子表场景在正文里直接写"如表 1.2a 所示"也行。

#block(
  fill: rgb("#fff7e6"),
  stroke: 0.5pt + rgb("#f59e0b"),
  radius: 4pt,
  inset: 8pt,
)[
  *状态*：upstream 已开 issue 跟踪，目前*无人请求*。如果你确实需要并觉得现成的 grid 写法不够，欢迎在 GitHub issues 上 +1，需求量到了再实现。
]

举一个并排小表的示例写法：

```typst
#figure(
  kind: table,
  supplement: [表],
  caption: figure.caption(position: top)[实验组与对照组数据对比],
  grid(
    columns: 2,
    column-gutter: 1em,
    align: top,
    [
      *(a) 实验组* \
      #captab(caption: none)[
        | 编号 | 数值 |
        | ---- | ---- |
        | 1    | 100  |
        | 2    | 200  |
      ]
    ],
    [
      *(b) 对照组* \
      #captab(caption: none)[
        | 编号 | 数值 |
        | ---- | ---- |
        | 1    | 95   |
        | 2    | 205  |
      ]
    ],
  ),
)<tab:cmp>
```

#figure(
  kind: table,
  supplement: [表],
  caption: figure.caption(position: top)[实验组与对照组数据对比],
  grid(
    columns: 2,
    column-gutter: 1em,
    align: top,
    [
      *(a) 实验组* \
      #captab(caption: none)[
        | 编号 | 数值 |
        | ---- | ---- |
        | 1    | 100  |
        | 2    | 200  |
      ]
    ],
    [
      *(b) 对照组* \
      #captab(caption: none)[
        | 编号 | 数值 |
        | ---- | ---- |
        | 1    | 95   |
        | 2    | 205  |
      ]
    ],
  ),
)<tab:cmp>

引用：`@tab:cmp` 解析为 "@tab:cmp"。子表 (a)(b) 没有自动 label，正文里直接写"如@tab:cmp(a) 所示"即可。

== 用了 `placement` 后，为什么小编号出现在大编号下方？

把较前声明的表用 `placement: bottom` 浮到页底时，页面上从上往下看可能是"Table 2 ... Table 1"——小编号在下。

*这不是 bug，是浮动的固有行为，LaTeX 完全一致*（`\begin{table}[b]` 的 Table 1 同样落在后面 in-flow 的 Table 2 下方）。浮动的定义就是把*物理位置*和*编号顺序*解耦：

- *编号* 始终按*源码声明顺序*——这是学术规范，正文里"见表 1"依赖它。
- *物理位置* 按 `placement` 落点走。

=== 如果希望"靠上的表编号更小"

自己控制即可，*不用改任何 cap-able 设置*：编号既然按声明顺序走，那就*把想要小编号的表先声明*。

```typst
// 想要的效果：上方的表 = 表 1，页底浮动的表 = 表 2
#captab(caption: [上方这张])[ ... ]                      // 声明①→ 表 1
#captab(caption: [浮到页底这张], placement: bottom)[ ... ]  // 声明②→ 表 2
```

物理上靠上的先声明 → 拿小编号；要浮到页底的那张声明在后、加 `placement: bottom`。同页浮动场景这样 100% 可控。

#block(
  fill: rgb("#fff7ed"),
  stroke: 0.5pt + rgb("#f97316"),
  radius: 4pt,
  inset: 8pt,
)[
  *⚠️ 不要手动干预编号*。不要试图用 `counter(figure.where(kind: table)).update(...)` 之类强行改编号——cap-able 通过内部隐藏 figure 机制注册编号（一套 +1 / −1 / step 流程），手动改计数器会与这套机制冲突，导致*编号或交叉引用错乱*。调整 `captab` 的声明顺序是唯一正确的解法。
]

// ============================================================
// 第十一章：变更日志
// ============================================================
= 变更日志

== 版本 0.1.2

*修复*：

- 修复跨页时题注可能与表/图分离的问题（issue #16）。`breakable: true` 的外层 block 允许分页落在题注与表体之间，导致题注被孤立在上一页底部、表体跑到下一页。现在用 `block(sticky: true)` 把"排在前面的那一块"（`caption-position: top` 时是题注、`bottom` 时是表体）粘住其后续内容——分页时一起移动，绝不分离。表体仍可正常内部跨页。
- 修复 `placement: top` / `bottom` / `auto` 时，`figure-above` / `figure-below`（以及 captab 的 `caption-above` / `table-below`）间距失效的问题（issue #14）。浮动元素由 `place(float: true)` 包裹，外层 `v()` / block 间距对它无效；改用 `place` 的 `clearance` 参数承载浮动元素与正文之间的间距。浮动只有"朝向正文一侧"的间距有意义：`top` 取 below 间距、`bottom` 取 above 间距、`auto` 取 below 兜底。

*新增功能 / 弃用*：

- `continued-caption` 重命名为 `show-continued-caption`（与 `show-subcaption` / `show-subcaption-label` 命名统一）。旧名 `continued-caption` 在 0.1.x *仍兼容*，将于 *0.2.0 移除*。两者同时传时新名优先。涉及 `captab` / `captab-style` / `bicap`。

== 版本 0.1.1

*修复*：

- 修复 `continued-caption: true` 时，用户自定义 `hlines` 的 `row` 索引相对 markdown 表格错位的问题（issue #8）。续页 caption 行注入会占 y=0，之前用户的 `row` 未跟着补 1，导致用户写 `row: 2` 实际落在 caption 与表头之间。修复后 `row` 始终按 markdown 表格自身行号计算，无论是否启用 `continued-caption` 行为一致。⚠️ 兼容性：如果之前用 `row: N+1` 作为 workaround 绕过 bug，修复后请改回 `row: N`，否则会有两条线重叠。
- 修复 `subcaption-number-title-spacing` 设为 length（如 `0.3em`）时，渲染处把长度当 content join 引发 `"cannot join string with length"`，进而抑制 hidden figure 注册、`@subfig` 报 "label not exist" 的连锁问题（issue #9）。改用 `handle-spacing` 把 length/relative 自动转 `h(...)`，content 直通。

*新增功能*：

- `capfig-style` / `capsubfig` 新增 `subref-style` 字段（默认 `"letter"`，新增 `"full"`）—— 控制 `@subfig` 交叉引用的字母样式。`"letter"` 仅字母（向后兼容，`图 1a`），`"full"` 保留 `label-style` 装饰（`图 1(a)`）。`"full"` 模式下 `label-sep` 默认空字符串（装饰自带视觉分隔）。issue #10。
- `captab` / `captab-style` 新增 `extra-rule` 字段（默认 `0.5pt`）—— `hlines` / `vlines` 缺省 `stroke` 时的默认值，避免每条线重复写 stroke。接受单值（h、v 共用）或 dict `(h: ..., v: ...)` 拆分横/竖线。per-line `stroke` 仍 wins。
- `hlines` / `vlines` 数组的每一项现支持 *int 简写*：`hlines: (2, 3, 4)` 等价 `((row: 2,), (row: 3,), (row: 4,))`。可与完整 dict 混用：`hlines: (2, (row: 5, stroke: 1pt), 7)`。

== 版本 0.1.0

*新增功能*：

- `captab` 与 `captab-style` 新增 `breakable` 参数（bool，默认 `true`）—— 控制三线表能否跨页。外层 `block` 的 `breakable` 跟随该参数，超长表格不再被压死在一页。
- 新增 `repeat-header` 参数（bool / 正整数，默认 `true`）—— 跨页时重复 markdown 表头行，基于 Typst 原生 `table.header(repeat: ...)`。`true`=每个续页都重复；`n`=只在前 n 个续页重复；`false`=关闭重复。
- 新增 `continued-caption` 参数（bool，默认 `false`，原名 `repeat-caption`，0.1.0 内不保留旧名）—— 跨页时在每个续页顶部再渲染一次"续表 X.Y caption"（与 `refer-to` 模式同款格式，编号锁定到主表）。实现上把 caption 行与 markdown 表头行放进两个独立的 `table.header`（用 `level: 1/2` 分层），所以 `continued-caption: true` 与 `repeat-header: false` 可以共存。续页通过 `query(label)` 查询主表位置、走 `_make_caption_content` 的 refer-to 分支生成续表标题，*不会* 重复登记 figure 编号；用户没传 `label` 时自动合成隐藏 label。
- 新增 `caption-align` 配置（默认 `"center"`）—— 控制题注水平对齐位置。5 种取值：`"center"` / `"left"` / `"right"`（与表/图局部对齐）、`"text-left"` / `"text-right"`（与正文区对齐）。也接受 dict `(main: ..., continued: ...)` 拆分主标题与续表标题（缺失键回退 `"center"`）。暴露面：`cap-style` / `captab-style` / `capfig-style` / `captab` / `bicap`。已知限制：续表标题嵌在 `table.header` 内被列宽锁住，`text-left` / `text-right` 在续表那侧静默降级为 `left` / `right`；需要真正"续页正文宽对齐"时改用手动 `refer-to` 拆段。
- *重命名* `repeat-caption` → `continued-caption`（0.1.0 尚未合并，不保留别名）。`captab` 与 `bicap` 同步改名，语义不变——bool，默认 `false`，控制是否在每个续页自动重复题注。
- 修复 `numbering-format` 在 `use-chapter: false` 时被忽略的 bug —— 之前这条分支硬编码了 `numbering("1", num)`，导致用户自定义的格式串（`"(A)"`、`"附 1"` 等）无效。修复后两条分支都尊重 `numbering-format`。
- 新增 `placement` 配置（默认 `none`）—— 类 Typst 原生 `figure(placement: ...)` 的浮动定位。4 种取值：`none` 原地（默认）/ `top` / `bottom`（浮到当前页或下一页顶/底）/ `auto`（Typst 按距离当前位置近的一边自动选 top 或 bottom）。基于 `place(float: true)` 包外层 block 实现；隐藏 figure（cross-ref 注册器）一同 ride 进 float wrapper，`@ref` 正确指向 float 落地页。暴露面：`cap-style` / `captab-style` / `capfig-style` / `captab` / `capfig` / `capsubfig` / `bicap`。已知限制：（1）启用浮动时强制 `breakable: false`（Typst float 不允许跨页）；（2）长表放进 float 会溢出，用户应保持 `placement: none`；（3）与 `continued-caption: true` 不兼容（依赖跨页）。
- 新增 `caption-text` 配置（默认 `(:)`）—— 题注 `text(...)` 透传字典，支持任何 Typst 原生 `text()` 参数（`font` / `fill` / `tracking` / `spacing` 等）。两种形式：扁平 dict（`(font: "Times")`）作用整个题注；分层 dict（含 `whole` / `prefix` / `supplement` / `number` / `body` 任一键）按层覆盖，内层覆盖外层。适用于"showrule 改字体不生效"的场景——cap-able 题注是手写 `text(...)` 不是 `figure.caption` 元素，必须走 `caption-text`。暴露于 `cap-style` / `captab-style` / `capfig-style`，对续表题注也生效。
- `numbering-format` 现接受 `str | function`，与 Typst 原生 `numbering()` 第一参数完全一致。函数形式收到 *所有 heading 层级 + 图/表自身编号*（`use-chapter: true` 时）或仅图/表编号（`use-chapter: false` 时），用户函数自行决定怎么消费。`calculate-chapter-levels` 对函数形式直接返回 0（章节层级数对函数无意义）。同时把字符串迭代改为 `clusters()` 遍历，避免在多字节字符（如中文 `"附 1"` 的 `"附"`）处切到 UTF-8 非边界。
- `bicap` 支持 `#bicap(...)[body]` 形式：把题注与 body 一起包进同一个不换页 block，等价于 cap-able 风味的 `figure(body, caption: ...)`。`body` 也可用名参 `body: [...]` 传。
- `bicap` 新增 `continued-caption`（bool，默认 false）—— `kind: "table"` 时，body 内每张原生 `#table()` 跨页时在续页顶部重复题注（与 `captab(continued-caption: true)` 同款）。约定：一个 bicap 里只放一张表，多表会被注入相同题注。
- `bicap` 新增 `repeat-header`（auto/bool/int，默认 auto）—— 覆盖 body 内 `#table()` 的 markdown 表头 `repeat` 设定，与 `continued-caption` 互相独立；可用 `repeat-header: false` 单独关掉表头跨页重复。
- `captab` 与 `captab-style` 新增 `three-line-table` 配置（bool，默认 `true`）—— 设为 `false` 关闭三线表样式，改用 Typst 原生 `table()` 默认网格描边；此时 `top-rule` / `middle-rule` / `bottom-rule` 不生效，用户自定义 `hlines` / `vlines` 仍正常工作。
- `captab` 形参新增 `align: auto`，并加 `..extra-args` 接收任意其它命名参数（`fill` / `stroke` / `gutter` / `column-gutter` / `row-gutter` / `rows` 等），透传给底层 `table(...)`，与 `tablem` 的 advanced-usage 例子保持一致。用户传 `stroke` 会覆盖三线模式默认的 `stroke: none`（建议同时设 `three-line-table: false`，否则三条手画 hline 会叠在用户 stroke 上）。
- `cell-inset` 与 `inset` 在 `captab` / `captab-style` 互为别名：原本 `captab` 用 `inset:` 而全局配置用 `cell-inset:`，命名不一致；现在两个名字都能用，同时传入时 `cell-inset` 优先（与 state 字段名一致）。
- 表格宽度系统重做：默认从"占满文本宽 100%"改为 *`auto`（按内容宽度自然撑开，不再强制拉满）*。`captab` / `captab-style` 都新增 `width` 形参，接受 `auto` / `<length>`（如 `8cm`）/ `<ratio>`（如 `80%` / `80.5%`）。`set-table-width` 同步加 `width:` 新形参（`percentage:` 旧 API 仍可用，会被转成 `<int>%`）。优先级 *per-call > 全局 state > `auto`*。`width != auto` 时若用户没传 `columns`，默认用 `(1fr,) * N` 让表填满设定宽度；`width == auto` 时默认用 `(auto,) * N` 走内容宽。
- 修正 `captab` 的对齐解析：用户传 *已经是 2D 的对齐* （如 `align: horizon + center`）时不再抛 "cannot add a vertical and a 2D alignment" 错；逻辑改为只在 `.y == none` 时才补 `+ horizon`，2D 对齐原样保留。
- 新增 `caption-position` 配置（`top` / `bottom`）—— 控制题注在表/图 body 的上方或下方。
  - 作用范围：`captab` 自身的题注布局、`bicap()[body]` 模式下题注与 body 的相对位置。
  - 默认值跟随 kind：table=top、figure=bottom。
  - 全局：`captab-style(caption-position: ...)` / `capfig-style(caption-position: ...)` / `cap-style(caption-position: ...)`（cap-style 同时影响表与图）。
  - per-call：`captab(caption-position: ...)` / `bicap(position: ...)`。
  - 已知限制：`caption-position: bottom` 与 `continued-caption: true` 不兼容。续页重复依赖 `table.header`，改用 `table.footer` 会把题注锁在表内列宽里，破坏"表外、表下方"的语义。两者同时设置时 `continued-caption` 静默失效，原始题注只在最后一页表下方出现一次。
  - 跨页与 `bottom` 兼容：长表配 `caption-position: bottom` 时，题注落在表格内容结束的最后一页底部，渲染正常。
- `bicap` 新增 `breakable` 参数（bool，默认 `true`）—— 外层 block 是否允许跨页。原来的实现把 caption + body 锁在 `breakable: false` 的 block 里会阻止内部本身可跨页的内容（如长 captab）跨页；改为默认透明，让内部 breakable 元素自然顺延。如果想保留旧的"标题 + body 原子化"行为，显式传 `breakable: false`。
- 子图 `label-style-override` 字典扩展：新增 `style` / `font` / `size` / `offset` 四个键，允许逐子图独立覆盖 overlay 标签的格式字符串、字体、字号、偏移。`style` 同时影响交叉引用——当 ref 跟随 overlay（subcaption 不可见）时，`@ref` 字母按该子图自己的格式渲染，与图上叠加保持一致。subcaption 不参与逐子图覆盖（保持整齐统一）。
- 子图 `label-style` 现接受 `str | dict` —— 默认 `str` 形式（如 `"(a)"`）让 *图上叠加的标签* 和 *subcaption 前缀* 共用同一样式（默认耦合）；传字典 `(overlay: "a)", subcaption: "(a)")` 可分别指定，缺失键回退包默认 `"(a)"`。交叉引用字母跟随"实际可见"的一侧——subcaption 可见时以 subcaption 为准，否则用 overlay；两者都没可见编号时退回 subcaption。这样 `@ref` 渲染出的字母始终和读者看到的一致。
- 新增 `subcaption-number-title-spacing` 配置（默认 `auto`）—— 控制 subcaption 编号与正文之间的间距。`auto` 继承大题注的 `number-title-spacing`（包默认配置里那个分隔符），消除子标题写成"(a) caption"时编号与正文只隔单空格的视觉割裂。可以在 `capfig-style(subcaption-number-title-spacing: ...)` 全局设置，或 `capsubfig(subcaption-number-title-spacing: ...)` per-call 覆盖。

*兼容性*：

- 默认值变化：`breakable` 默认从 0.0.x 隐式的 `false` 改为 `true`。如希望保留旧行为，请显式传 `breakable: false` 或在 `captab-style.with(...)` 中全局设置。
- 默认值变化：表宽默认从"占满文本宽 100%"改为 `auto`（按内容宽度）。如希望保留旧行为，全局设 `set-table-width(width: 100%)` 或 `captab-style.with(width: 100%)` 即可。带 `fr` 列的表（如用户写 `columns: (1fr, 1fr, 1fr)`）继续按 fr 撑开，受父容器宽度影响；之前没传 `columns` 的表会变成内容宽。

== 版本 0.0.2

*Bug 修复*：

- `captab-style` / `capfig-style` / `cap-style` 改为 *patch 语义*。所有形参的实际默认值改为 `auto`，仅显式传入的字段才会写回 state。这意味着可以连续调用 `captab-style.with(...)` 仅覆盖某一维度（如启用 `outline-bilingual`），而不会把未提供的字段（如 `cell-inset`）重置为函数默认值。show / set 规则现在也通过 `context { state.get() }` 在渲染时读取最新合并值。

*新增功能*：

- `captab` 与 `captab-style` 新增 `top-rule` / `middle-rule` / `bottom-rule` 三参数，用于自定义三线表的顶/中/底线。接受任何 Typst stroke 值，例如 `2pt + red`、`stroke(thickness: 1pt, dash: "dashed")`。默认值仍为顶/底 `1.5pt`、中 `0.5pt`。
- `captab` 新增 `columns` 参数作为 `cols` 的推荐别名，与 Typst 原生 `table(columns: ...)` 命名一致；`cols` 仍向后兼容。

*文档更新*：

- 完整参数表新增 `top-rule` / `middle-rule` / `bottom-rule` / `columns` 行。
- `captab-style` 与 `capfig-style` 节前添加 patch-语义说明块。
- 新增 `== 三线粗细` 小节展示用法。
- 全部 `cols:` 示例改写为 `columns:`。

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