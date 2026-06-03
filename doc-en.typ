// ============================================================
// cap-able Package Documentation (English)
// ============================================================
//
// This file is the complete documentation for cap-able,
// typeset with the mantys template and auto-generated API
// reference via tidy from source docstrings.
//
// How to compile:
//   typst compile doc-en.typ
//
// ============================================================

#import "@preview/tidy:0.4.3"
#import "@preview/mantys:1.0.2": *
#import "cap-able/0.1.2/lib.typ": *

// ============================================================
// Document Metadata
// ============================================================

#show: mantys(
  name: "cap-able",
  version: "0.1.2",
  authors: (
    "Schrödinger Blume",
  ),
  license: "MIT",
  description: "A comprehensive Typst package for creating professional three-line tables and figures with bilingual caption support, continued tables/figures, subfigures, and flexible customization options for academic documents.",
  repository: "https://github.com/SchrodingerBlume/typst-cap-able",

  title: "cap-able",
  subtitle: "Make it more able to caption — now that is cap-able",
  date: datetime.today(),

  abstract: [
    *cap-able* is a powerful Typst package designed for academic documents, providing:

    - *Three-line tables* — Academic-standard tables (top, middle, bottom rules)
    - *Bilingual captions* — Auto-formatted bilingual captions (Chinese/English, German/English, etc.)
    - *Continued tables/figures* — Multi-page tables and figures with automatic numbering
    - *Subfigures* — Flexible multi-image grid layouts with overlay labels and subcaptions
    - *Notes* — Auto-width-matched notes for tables and figures
    - *Multilingual support* — 25+ languages including RTL languages
    - *Unified configuration* — Configure both via `cap-style`, or override per-type with `captab-style` / `capfig-style`

    The package is particularly suited for academic papers, theses, and technical
    documents requiring professional typography and multi-language support.
  ],
)

#set par(first-line-indent: 2em)

// ============================================================
// Chapter 1: Introduction
// ============================================================
#set text(font:("Noto Serif", "Noto Serif CJK SC", "Devanagari Sangam MN"))
#show raw: set text(font: "LXGW WenKai Mono")

// mantys show ref rule outputs nothing for plain figure (kind: image/table),
// causing @fig:xxx to render blank. Restore default link behavior for these refs.
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

= Introduction

*cap-able* brings professional table and figure capabilities to Typst, following academic publishing standards and best practices.

The name "cap-able" is a wordplay on "caption" and "able" — making your documents more *able* to handle complex *captions*, very capable, huh!

== Design Philosophy

The package follows these design principles:

+ *Declarative Configuration*: Configure once at the document start, use everywhere
+ *Sensible Defaults*: Works out of the box with minimal configuration
+ *Language Awareness*: Automatic formatting based on document language
+ *Academic Standards*: Follows established conventions for scholarly publishing

== Dependencies

This package depends on:

- ```typ @preview/tablem:0.3.0``` — Markdown-style table syntax support

For documentation generation only:

- ```typ @preview/tidy:0.4.3``` — Auto-generate API reference from docstrings
- ```typ @preview/mantys:1.0.2``` — Documentation template

// ============================================================
// Chapter 2: Installation
// ============================================================
= Installation

== From Typst Universe

Once published to Typst Universe, import directly:

```typst
#import "@preview/cap-able:0.1.2": *
```

== Manual Installation

After downloading from the repository:

+ Place the `cap-able` folder in your project directory
+ Import with a relative path:

```typst
#import "cap-able/0.1.2/lib.typ": *
```

// ============================================================
// Chapter 3: Quick Start
// ============================================================
= Quick Start

This chapter provides a quick overview of the most common use cases.

== Basic Three-Line Table

The simplest way to create a table uses Markdown-like syntax:

```typst
#captab(
  caption: [Sample Data],
)[
  | Name   | Age | Score |
  | ------ | --- | ----- |
  | Alice  | 25  | 95    |
  | Bob    | 30  | 87    |
]
```

#captab(
  caption: [Sample Data],
)[
  | Name   | Age | Score |
  | ------ | --- | ----- |
  | Alice  | 25  | 95    |
  | Bob    | 30  | 87    |
]

The table automatically gets:

- Content-sized width (default `width: auto`; switch to fixed length / ratio via the `width` parameter or `set-table-width(...)` — see "Table Width" section)
- 1.5pt top rule
- 0.5pt rule below the header
- 1.5pt bottom rule
- Centered content with proper spacing

== Basic Figure

Creating figures is equally straightforward:

```typst
#capfig(
  rect(width: 15%, height: 1.15cm, fill: blue.lighten(80%)),
  caption: [A Simple Rectangle],
)
```

#capfig(
  rect(width: 15%, height: 1.15cm, fill: blue.lighten(80%)),
  caption: [A Simple Rectangle],
)

== Bilingual Captions

For documents requiring bilingual captions, simply add the `caption-en` parameter:

```typst
#set text(lang: "es") // Set the document language to non-English

#captab(
  caption: [Parámetros experimentales],
  caption-en: [Experimental Parameters],
)[
  | Parámetro   | Valor | Unidad |
  | ----------- | ----- | ------ |
  | Temperatura |  25   |   °C   |
  | Presión     |   1   |   atm  |
]
```

#set text(lang: "es")

#captab(
  caption: [Parámetros experimentales],
  caption-en: [Experimental Parameters],
)[
  | Parámetro   | Valor | Unidad |
  | ----------- | ----- | ------ |
  | Temperatura |  25   |   °C   |
  | Presión     |   1   |   atm  |
]

#set text(lang: "en")

The package automatically:
- Detects the document language
- Formats the primary caption in that language
- Adds an English caption below when `enable-english-caption: true`

Note: When the document language is English (`#set text(lang: "en")`), if both `caption` and `caption-en` are provided, only `caption-en` is displayed as a single-language caption — `caption` is ignored, since the document is already in English and bilingual output is unnecessary.

// ============================================================
// Chapter 4: Tables in Detail
// ============================================================
= Tables in Detail

== Table Syntax

`captab` uses the `tablem` package to parse Markdown-style table syntax, avoiding verbose Typst table syntax.

=== Basic Syntax

```
  | Header1 | Header2 | Header3 |
  | ------- | ------- | ------- | <- Separator
  | Cell 1  | Cell 2  | Cell 3  |
  | Cell 4  | Cell 5  | Cell 6  |
```

#captab(
  caption: [Basic Syntax Example],
)[
  | Header1 | Header2 | Header3 |
  | ------- | ------- | ------- |
  | Cell 1  | Cell 2  | Cell 3  |
  | Cell 4  | Cell 5  | Cell 6  |
]

#captnote[Note: The separator row (`| --- |`) marks the boundary between header and body rows.]

=== Alignment

Control alignment using colons in the separator:

```
  | Left       | Center    | Right       |
  | :--------- | :-------: | ----------: |
  | L          | C         | R           |
```

#captab(
  caption: [Column Alignment Example],
)[
  | Left       | Center    | Right       |
  | :--------- | :-------: | ----------: |
  | L          | C         | R           |
]

#pagebreak()

=== Cell Merging

tablem supports cell merging:
- Use `<` to merge with cell to the left (horizontal)
- Use `^` to merge with cell above (vertical)

```
| A    | B    |
| ---- | ---- |
| Span | <    |
| C    | Span |
| D    | ^    |
```

#captab(
  caption: [Cell Merging Example],
)[
  | A    | B    |
  | ---- | ---- |
  | Span | <    |
  | C    | Span |
  | D    | ^    |
]

== Column Configuration

Customize column widths using the `columns` parameter (the legacy name `cols` still works as a back-compat alias).

*Column width rules:*

- Without `columns` (auto mode): columns fit content; may overflow with long text.
- Only absolute units (e.g., `cm`, `pt`): table width = sum of columns; may be narrower or overflow.
- With `fr` units: table expands proportionally to text width. `fr` and absolute units can be mixed — absolute columns take fixed widths first, and the remaining space is distributed by `fr` ratio.

The `columns` parameter accepts an array of lengths, for example:
```typst
  columns: (8cm, 2cm, 2cm)       // Absolute units
  columns: (3fr, 1fr, 1fr)       // fr units
  columns: (3fr, 2cm, 1fr)       // Mixed
```

=== *Auto mode `columns: ()`*

#captab(
  caption: [Auto Columns],
)[
  | Description | Value | Unit |
  | ----------- | ----- | ---- |
  | This is a very very, really really, truly truly long text | 42 | m/s |
]
#pagebreak()
=== Absolute units `columns: (8cm, 3cm, 2cm)`

#captab(
  columns: (8cm, 3cm, 2cm),
  caption: [Absolute Columns],
)[
  | Description | Value | Unit |
  | ----------- | ----- | ---- |
  | This is a very very, really really, truly truly long text | 42 | m/s |
]

=== fr units `columns: (3fr, 1fr, 1fr)` — First column third as wide

#captab(
  columns: (3fr, 1fr, 1fr),
  caption: [Proportional Columns],
)[
  | Description | Value | Unit |
  | ----------- | ----- | ---- |
  | This is a very very, really really, truly truly long text | 42 | m/s |
]

=== Mixed `columns: (5fr, 3cm, 1fr)` — Value column fixed at 3cm; Description and Unit columns share remaining width at 5:1

#captab(
  columns: (5fr, 3cm, 1fr),
  caption: [Mixed Columns],
)[
  | Description | Value | Unit |
  | ----------- | ----- | ---- |
  | This is a very very, really really, truly truly long text | 42 | m/s |
]

== Additional Lines

Add extra horizontal or vertical lines for complex layouts. Each entry in `hlines` / `vlines` may be an *`int` shorthand* (just the row/col index, all other fields default) or a *full dict*:

```typst
// Shorthand: plain int list
#captab(hlines: (2, 3), vlines: (1, 2), caption: [...])[ ... ]

// Full dict (customise stroke / start / end)
#captab(
  hlines: ((row: 3, stroke: 1pt),),   // Add 1pt horizontal line after row 3
  vlines: ((col: 1, start: 1),),      // Add vertical line at column 1 (from row 1)
  caption: [Table with Extra Lines],
)[...]

// Mixed
#captab(hlines: (2, (row: 5, stroke: 1.5pt + red), 7), ...)[ ... ]
```

#captab(
  hlines: ((row: 3, stroke: 1pt),),
  vlines: ((col: 1, start: 1),),
  caption: [Table with Extra Lines],
)[
  | A | B | C |
  | - | - | - |
  | 1 | 2 | 3 |
  | 4 | 5 | 6 |
  | 7 | 8 | 9 |
]

=== Global default stroke `extra-rule`

When every extra line in a table (or document) shares the same stroke, set a global default rather than repeating it per line:

```typst
#show: captab-style.with(extra-rule: 0.5pt + red)

#captab(
  hlines: ((row: 2,), (row: 3,)),     // both inherit 0.5pt + red, no repetition
)[ ... ]
```

`extra-rule` accepts a *single value* (shared by hlines & vlines) or a *dict form* for per-axis control:

```typst
#show: captab-style.with(
  extra-rule: (h: 1pt + blue, v: 0.3pt + gray),
)
```

Per-line `stroke` still wins:

```typst
#captab(
  extra-rule: 0.5pt + green,
  hlines: (
    (row: 2,),                        // 0.5pt + green ← inherits
    (row: 5, stroke: 1.5pt + orange), // 1.5pt + orange ← overrides
  ),
)
```

Configurable globally on `cap-style` / `captab-style`, or per-call via `captab(extra-rule: ...)`. Default `0.5pt` matches the previous hard-coded behaviour.

== Three-Line Strokes

Customize the top, middle and bottom rules of the three-line table via `top-rule` / `middle-rule` / `bottom-rule`. Any Typst stroke value works — thickness, color, dashed:

```typst
#captab(
  caption: [Custom Rule Styles],
  top-rule: 2pt + red,             // 2pt red top rule
  middle-rule: 0.5pt + gray,       // gray middle rule
  bottom-rule: stroke(thickness: 2pt, dash: "dashed"), // dashed bottom
)[
  | A | B | C |
  | - | - | - |
  | 1 | 2 | 3 |
]
```

#captab(
  caption: [Custom Rule Styles],
  top-rule: 2pt + red,
  middle-rule: 0.5pt + gray,
  bottom-rule: stroke(thickness: 2pt, dash: "dashed"),
)[
  | A | B | C |
  | - | - | - |
  | 1 | 2 | 3 |
]

You can also configure them globally via `captab-style`:

```typst
#show: captab-style.with(
  top-rule: 1.2pt,
  middle-rule: 0.4pt,
  bottom-rule: 1.2pt,
)
```

`auto` reads from global state (defaults: top/bottom `1.5pt`, middle `0.5pt`).

== Disable three-line mode (`three-line-table: false`)

By default `captab` renders a three-line table (manual top/middle/bottom rules, table `stroke: none`). To produce a *standard Typst grid table* (borders on every cell side), set `three-line-table` to `false`:

```typst
// Per-call
#captab(
  caption: [Standard Typst grid],
  three-line-table: false,
)[
  | ID | Name | Value |
  | -- | ---- | ----- |
  | 1  | A    | 100   |
]

// Globally
#show: captab-style.with(three-line-table: false)
// or
#show: cap-style.with(three-line-table: false)
```

When `three-line-table: false`, `top-rule` / `middle-rule` / `bottom-rule` are inactive; user-defined extra `hlines` / `vlines` still apply. Adjust the default Typst grid stroke globally via `set table(stroke: ...)`.

== Pass-through `tablem` / `table` advanced usage

Apart from captab's own named parameters (`columns` / `cols` / `align` / `size` / `leading` / `inset` / `caption…` / `…-rule` / `breakable` / `repeat-…` / `hlines` / `vlines` / `label`, etc.), *any other named argument* is forwarded as-is to the underlying `table(...)` call, mirroring `tablem`'s advanced-usage surface. Useful pass-throughs:

- `fill: color | function` (cell background; can be `(x, y)` callback)
- `stroke: stroke | function | dictionary` (per-cell strokes)
- `gutter` / `column-gutter` / `row-gutter`
- `rows`
- any other named parameter that Typst's `table()` accepts

```typst
#let frame(stroke) = (x, y) => (
  left: if x > 0 { 0pt } else { stroke },
  right: stroke,
  top: if y < 2 { stroke } else { 0pt },
  bottom: stroke,
)

#captab(
  caption: [Monthly reading list],
  three-line-table: false,                                // full grid instead of three-line
  columns: (0.4fr, 1fr, 1fr),
  align: left,
  fill: (_, y) => if calc.odd(y) { rgb("EAF2F5") },        // alternating row fill
  stroke: frame(rgb("21222C")),                            // custom stroke
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
  caption: [Monthly reading list],
  three-line-table: false,                                // full grid instead of three-line
  columns: (0.4fr, 1fr, 1fr),
  align: left,
  fill: (_, y) => if calc.odd(y) { rgb("EAF2F5") },        // alternating row fill
  stroke: frame(rgb("21222C")),                            // custom stroke
)[
  | *Month*  | *Title*               | *Author*            |
  | -------- | --------------------- | ------------------- |
  | January  | The Great Gatsby      | F. Scott Fitzgerald |
  | February | To Kill a Mockingbird | Harper Lee          |
]

== Page Break

Starting with 0.1.0 `captab` allows long tables to break across pages by default. Two relevant parameters:

- `breakable` (bool, default `true`) — whether the table may break. Set to `false` to keep the table atomic on one page (it may overflow).
- `repeat-header` (bool / int, default `true`) — repeat the header row on each continuation page using Typst's native `table.header(repeat: ...)`. `true` repeats on every continuation page; pass a positive integer `n` to repeat only on the first `n` continuation pages; `false` disables repetition.
- `continued-caption` (bool, default `false`) — whether to render a "Cont. Table X.Y caption" header on each continuation page (same format as `refer-to` mode). The first page still shows the full original caption.

```typst
#captab(
  caption: [Long Data Table],
  breakable: true,         // allow page break (default)
  repeat-header: true,     // repeat header rows (default)
  continued-caption: true,    // continuation pages show "Cont. Table X.Y"
)[
  | ID | Name | Value |
  | -- | ---- | ----- |
  // ...
]
```

Or configure globally:

```typst
#show: captab-style.with(
  breakable: true,
  repeat-header: true,
  continued-caption: true,
)
```

#captab(
  caption: [Long Data Table],
  breakable: true,         // allow page break (default)
  repeat-header: true,     // repeat header rows (default)
  continued-caption: true,    // continuation pages show "Cont. Table X.Y"
)[
  | ID  | Name        | Value |
  | --- | ----------- | ----- |
  | 001 | Apple       | 12.50 |
  | 002 | Banana      | 8.30  |
  | 003 | Orange      | 15.00 |
  | 004 | Grape       | 22.80 |
  | 005 | Watermelon  | 35.60 |
  | 006 | Mango       | 18.90 |
  | 007 | Pineapple   | 25.40 |
  | 008 | Strawberry  | 28.70 |
  | 009 | Blueberry   | 45.20 |
  | 010 | Peach       | 16.40 |
  | 011 | Pear        | 10.80 |
  | 012 | Cherry      | 52.30 |
  | 013 | Pomelo      | 19.60 |
  | 014 | Dragonfruit | 21.50 |
  | 015 | Kiwi        | 14.30 |
  | 016 | Cantaloupe  | 32.90 |
  | 017 | Coconut     | 26.80 |
  | 018 | Lychee      | 38.40 |
  | 019 | Longan      | 24.70 |
  | 020 | Mangosteen  | 48.50 |
]

*How it works*: `continued-caption` does not register a new figure on every continuation page. Each continuation cell uses `query(label)` to locate the main table, reads its number from the counter, and delegates to the refer-to branch of `_make_caption_content` to format "Cont. Table X.Y caption …". If no `label` was provided, cap-able auto-synthesises a hidden `__captab_repeat_<n>` label for internal lookup. The caption row and the header row live in two separate `table.header` blocks (with `level: 1/2`), so `continued-caption: true` can coexist with `repeat-header: false` — the caption repeats while the header does not.

The explicit `refer-to` continuation mechanism (manually-split tables) is still supported and useful when you need to place continuation tables at different positions / chapters.

#pagebreak()

== Table Notes

Add explanatory notes below tables:

```typst
#captab(caption: [Statistical Results])[
  | Variable | Mean  | SD   |
  | -------- | ----- | ---- |
  | X        | 3.2\* | 0.5  |
  | Y        | 4.1   | 0.8  |
]
#captnote[
  Note: $\*p < 0.05$. SD = Standard Deviation.
]
```

#captab(caption: [Statistical Results])[
  | Variable | Mean  | SD   |
  | -------- | ----- | ---- |
  | X        | 3.2\* | 0.5  |
  | Y        | 4.1   | 0.8  |
]
#captnote[
  Note: $\*p < 0.05$. SD = Standard Deviation.
]

== Continued Tables

cap-able supports two continuation styles — pick the one that fits the use case:

+ *Auto page-break + repeat caption (recommended, since 0.1.0)* — let `captab` flow naturally across pages and automatically render "Cont. Table X.Y" on the top of every continuation page.
+ *Manual `refer-to` (always available)* — split the table into two or more parts and use `refer-to` on the second part to inherit the number. Useful when you want to insert text/figures/other logic between the original and the continuation.

=== Auto page-break + repeat caption

Pass `continued-caption: true` to `captab` (`breakable` is `true` by default). cap-able uses Typst's native `table.header(repeat: ...)` to re-emit "Cont. Table X.Y" on the top of every continuation page. The number is anchored to the main table, so no figure is re-registered.

```typst
#captab(
  caption: [Long Data Table],
  continued-caption: true,         // continuation pages show "Cont. Table X.Y"
  // breakable: true,           // already the default
  // repeat-header: true,       // header also repeats by default
  label: <tab:long-auto>,
)[
  | ID | Value |
  | -- | ----- |
  | 1  | 100   |
  | 2  | 200   |
  | 3  | 300   |
  // ...
]
```

To repeat only the caption but not the markdown header, pass `repeat-header: false`. To let the table flow without any continuation caption (Typst-default behaviour), keep `continued-caption: false` (the default).

#block(
  fill: rgb("#ecfeff"),
  stroke: 0.5pt + rgb("#06b6d4"),
  radius: 4pt,
  inset: 8pt,
)[
  *When to use*: long data tables, fully-automatic page breaks. One line of `continued-caption: true` does it — no manual splitting, no caption duplication.
]

#block(
  fill: rgb("#fff7ed"),
  stroke: 0.5pt + rgb("#f97316"),
  radius: 4pt,
  inset: 8pt,
)[
  *Known limitation*: `continued-caption: true` is incompatible with `caption-position: bottom`. Continuation repetition relies on `table.header(repeat: true)` to inject the caption inside the table; the only mechanism for the bottom edge would be `table.footer`, but that locks the caption inside the table's column boundaries — visually "embedded in the table" — which contradicts what `caption-position: bottom` means ("outside the table, below it").

  When both are set, cap-able *silently disables repeat* — equivalent to `continued-caption: false`: the original caption appears once, beneath the last page of the table. To repeat the caption on every page, switch to `caption-position: top`.
]

=== Manual `refer-to` (preserved)

When you need to insert explanatory text, footnotes or any other content between the original and the continuation, use `refer-to` to split explicitly:

```typst
// First part (original table)
#captab(
  caption: [Long Data Table],
  label: <tab:long>,        // set label for continuation reference
)[
  | ID | Value |
  | -- | ----- |
  | 1  | 100   |
]

Arbitrary content can go here (notes, smaller table, image, …).

// Continuation (header shows "Cont. Table X")
#captab(
  caption: [Long Data Table],
  refer-to: <tab:long>,       // reference the original for numbering
  show-caption: true,         // force the caption text on the continuation
)[
  | ID | Value |
  | -- | ----- |
  | 2  | 200   |
]
```

#captab(
  caption: [Long Data Table],
  label: <tab:long>,
)[
  | ID | Value |
  | -- | ----- |
  | 1  | 100   |
]

Arbitrary content can go here (notes, smaller table, image, …).

#captab(
  caption: [Long Data Table],
  refer-to: <tab:long>,
  show-caption: true,
)[
  | ID | Value |
  | -- | ----- |
  | 2  | 200   |
]

Either way, the continuation automatically:

- Uses the same number as the original table
- Adds the continuation prefix/suffix
- Does not create a new entry in the table of contents

=== Continuation Mode

`continued-mode` controls the format (applies to both styles):

- `"prefix"` (default): prefix mode, e.g. "Cont. Table 1"
- `"suffix"`: suffix mode, e.g. "Table 1 (continued)"

// ============================================================
// Chapter 5: Figures in Detail
// ============================================================
= Figures in Detail

== Single Figures

Create single figures with bilingual captions using `capfig`:

```typst
#capfig(
  image("example.png", width: 30%),
  caption: [Typst Logo],
  label: <fig:typst-logo>,
)
```

== Subfigures

`capsubfig` creates multi-image parallel layouts:

```typst
#capsubfig(
  (
    (content: rect(width: 3cm, height: 2cm, fill: red.lighten(70%)),
     subcaption: [Red]),
    (content: rect(width: 3cm, height: 2cm, fill: green.lighten(70%)),
     subcaption: [Green]),
    (content: rect(width: 3cm, height: 2cm, fill: blue.lighten(70%)),
     subcaption: [Blue]),
  ),
  columns: 3,
  show-subcaption: true,        // Show subcaptions
  caption: [Color Comparison],
)
```

#capsubfig(
  (
    (content: rect(width: 3cm, height: 2cm, fill: red.lighten(70%)),
     subcaption: [Red]),
    (content: rect(width: 3cm, height: 2cm, fill: green.lighten(70%)),
     subcaption: [Green]),
    (content: rect(width: 3cm, height: 2cm, fill: blue.lighten(70%)),
     subcaption: [Blue]),
  ),
  columns: 3,
  caption: [Color Comparison],
  show-subcaption: true,
)

== Overlay Labels

Use overlay label mode to place (a), (b) labels directly on images for a cleaner look:

```typst
#capsubfig(
  (
    (content: rect(width: 4cm, height: 3cm, fill: orange.lighten(70%))),
    (content: rect(width: 4cm, height: 3cm, fill: purple.lighten(70%))),
  ),
  columns: 2,
  caption: [Overlay Labels Demo],
  label-mode: "overlay",        // Enable overlay mode
  label-style: "(a)",           // Label style
  label-bg: white.transparentize(20%),  // Semi-transparent white bg
  label-offset: (5pt, 5pt),     // Offset from top-left
)
```

#capsubfig(
  (
    (content: rect(width: 4cm, height: 3cm, fill: orange.lighten(70%))),
    (content: rect(width: 4cm, height: 3cm, fill: purple.lighten(70%))),
  ),
  columns: 2,
  caption: [Overlay Labels Demo],
  label-mode: "overlay",
  label-style: "(a)",
  label-bg: white.transparentize(20%),
  label-offset: (5pt, 5pt),
)

=== Label Style Reference

The `label-style` parameter supports various formats:

#table(
  columns: (1fr, 2fr, 3fr),
  stroke: none,
  inset: 6pt,
  table.hline(stroke: 1.5pt),
  table.header[*Style*][*Example*][*Description*],
  table.hline(stroke: 0.5pt),
  [`"(a)"`], [(a), (b), (c)], [Parenthesized lowercase],
  [`"(A)"`], [(A), (B), (C)], [Parenthesized uppercase],
  [`"(1)"`], [(1), (2), (3)], [Parenthesized numbers],
  [`"(i)"`], [(i), (ii), (iii)], [Parenthesized roman lowercase],
  [`"(I)"`], [(I), (II), (III)], [Parenthesized roman uppercase],
  [`"a)"`], [a), b), c)], [Trailing parenthesis only],
  [`"Fig. A"`], [Fig. A, Fig. B], [English prefix],
  table.hline(stroke: 1.5pt),
)

=== Decoupling overlay vs subcaption: dict form of `label-style`

By default the *overlay label stamped on the figure* (`label-mode: "overlay"`) and the *subcaption number prefix* share a single `label-style` — pass a string and both stay in sync.

To control them independently, pass a dictionary:

```typst
#capsubfig(
  caption: [Compact overlay, full subcaption],
  show-subcaption: true,
  label-mode: "overlay",
  label-style: (overlay: "a)", subcaption: "(a)"),    // overlay "a)", subcaption "(a) caption"
  (
    (content: img1, subcaption: [first sub]),
    (content: img2, subcaption: [second sub]),
  ),
)
```

In the dict, `overlay` controls the overlay style and `subcaption` controls the subcaption prefix; missing keys fall back to the package default `"(a)"`.

*Cross-reference letter source*: follows whichever side is actually visible — subcaption (when `show-subcaption: true` and `show-subcaption-label: true`) wins, otherwise the overlay style is used (when `label-mode: "overlay"`); when neither is visible the subcaption style is used as a defensive fallback. This keeps the letter in `@fig:xxx` consistent with what the reader actually sees.

=== Spacing between subcaption number and body

The gap between the subcaption number prefix (e.g. `"(a)"`) and its body text is controlled by `subcaption-number-title-spacing`:

- Default `auto`: inherits the main caption's `number-title-spacing` (the same separator used for "Figure 1.1#h(0.5em)caption" in the package defaults), keeping subcaptions visually consistent with the main caption.
- Configure globally via `capfig-style(subcaption-number-title-spacing: ...)`.
- Override per call via `capsubfig(subcaption-number-title-spacing: ...)`.

```typst
#capsubfig(
  caption: [per-call separator " — "],
  show-subcaption: true,
  label-mode: "overlay",
  subcaption-number-title-spacing: [ — ],
  (...),
)
```

== Subfigure Cross-References

After setting a `label` for each subfigure, reference them with `@`:

```typst
#capsubfig(
  (
    (content: rect(fill: gray), label: <fig:sub-a>),
    (content: rect(fill: gray), label: <fig:sub-b>),
  ),
  label-mode: "overlay",
  caption: [Referenced Subfigures],
  label: <fig:main>,
)

See @fig:sub-a and @fig:sub-b for details.
```

Live demonstration:

#capsubfig(
  (
    (content: rect(width: 3cm, height: 1.5cm, fill: gray), label: <fig:sub-a>),
    (content: rect(width: 3cm, height: 1.5cm, fill: gray), label: <fig:sub-b>),
  ),
  label-mode: "overlay",
  caption: [Referenced Subfigures],
  label: <fig:subref-main>,
)

See @fig:sub-a and @fig:sub-b (overall @fig:subref-main).

=== `subref-style`: keep `label-style` decorations in `@ref`

By default `subref-style: "letter"` — `@fig:sub-a` renders as `Fig. 1a` (just the letter).

Set `"full"` to *also keep the `label-style` decorations in cross-references*:

```typst
#capsubfig(
  ...
  label-style: "(a)",
  subref-style: "full",        // ← keep the parentheses in @ref
)
```

Renders: `@fig:sub-a` → `Fig. 1(a)`, matching the subcaption prefix.

Works with Chinese-style prefixes (`label-style: "图a"` + `"full"` → `图 1图a`), brackets (`"[A]"` → `Fig. 1[A]`), etc. In `"full"` mode, `label-sep` defaults to empty string since the decorations already separate visually; override `label-sep` explicitly if you want a different separator.

Configurable globally via `capfig-style(subref-style: "full")` or per-call on `capsubfig`.

// ============================================================
// Chapter 6: Configuration
// ============================================================
= Configuration

== Unified Configuration

`cap-style` configures shared styles (numbering, caption, language, notes, ...) for both tables and figures at once. A subsequent `captab-style` / `capfig-style` call can override per-type.

```typst
#show: cap-style.with(
  numbering-format: "1.1",
  use-chapter: true,
  caption-weight: "regular",
  enable-english-caption: true,
)

// Per-type override still works afterwards:
#show: capfig-style.with(
  label-mode: "overlay",
  label-style: "(a)",
)
```

== Table Configuration

Use `captab-style` to configure all table-related settings. Typically called via `#show:` at the document start:

```typst
#show: captab-style.with(
  // Numbering
  numbering-format: "1.1",      // Chapter.Number format
  use-chapter: true,            // Include chapter number

  // Caption style
  caption-size: 10.5pt,
  caption-weight: "regular",    // or "bold"

  // Spacing
  caption-above: 1em,           // Above caption
  caption-below: 0.95em,        // Between caption and table

  // Language
  lang: auto,                   // Auto-detect
  enable-english-caption: true, // Enable English sub-caption

  // Table content
  body-size: 10.5pt,
  cell-inset: (x: 3pt, y: 6.5pt),

  // Continuation
  continued-mode: "prefix",     // "prefix" or "suffix"
)
```

== Figure Configuration

Use `capfig-style` for figure and subfigure settings:

```typst
#show: capfig-style.with(
  // Numbering
  numbering-format: "1.1",

  // Subfigure defaults
  label-mode: "overlay",        // Default overlay mode
  label-style: "(a)",
  gutter: 1em,
  subcaption-pos: "bottom",

  // Caption
  enable-english-caption: true,
)
```

== Table Width

cap-able *does not enforce a fixed table width by default* — `width: auto` lets the table size itself by content (a row like `| A | B | C |` only takes three character-widths, not the full text area). The default is decided by `columns`:

- *User did not pass `columns`*: defaults to `(auto,) * N`, table is content-sized.
- *User passed `columns`*: respects the user's spec.
  - `(1fr, 1fr, 1fr)` → fr columns expand, but with no fixed-width parent, behaviour depends on context.
  - `(8cm, 4cm)` → table is 12cm wide, centered.

To *fix the table width*, three options:

```typst
// (1) Per call: captab(width: ...)
#captab(caption: [Narrow Table], width: 60%)[ ... ]
#captab(caption: [Absolute Width], width: 8cm)[ ... ]
#captab(caption: [Decimal Percent], width: 80.5%)[ ... ]

// (2) Globally via captab-style; subsequent captab calls follow
#show: captab-style.with(width: 70%)

// (3) Globally via set-table-width; everything after that follows
#set-table-width(width: 50%)         // new form
#set-table-width(percentage: 50)     // legacy form (1-100 int, converted to ratio)
```

When `width != auto`, if the user did not pass `columns`, cap-able uses `(1fr,) * N` so the table fills the configured width.

`width` accepts three types:

#table(
  columns: (1fr, 3fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Type*][*Description / Examples*],
  table.hline(stroke: 0.5pt),
  [`auto`], [Unconstrained (default). Table sizes to content.],
  [`<length>`], [Absolute width. e.g. `8cm`, `120pt`.],
  [`<ratio>`], [Percentage of text width, including decimals. e.g. `80%`, `80.5%`.],
  table.hline(stroke: 1.5pt),
)

Priority: *per-call `captab(width:)`* > *global state* (set by `captab-style` / `set-table-width`) > *default `auto`*.

```typst
#show: captab-style.with(width: 70%)

#captab(caption: [Following the global 70%])[ ... ]                  // 70% wide
#captab(caption: [Override to 50%], width: 50%)[ ... ]               // 50% wide
```

#captab(caption: [Example: 50% wide], width: 50%)[
  |A|B|
  |C|D|
]

== Custom Numbering

`numbering-format` accepts any value Typst's native `numbering()` would accept — most needs are one-liners.

=== String formats

As long as it contains a format placeholder (`1` arabic, `a/A` letter, `i/I` roman), other characters render verbatim:

#table(
  columns: (1fr, 2fr, 2fr),
  stroke: none,
  inset: 6pt,
  table.hline(stroke: 1.5pt),
  table.header[*Format*][*Renders*][*Use case*],
  table.hline(stroke: 0.5pt),
  [`"1"`],          [1, 2, 3, ...],          [Plain arabic (default)],
  [`"(A)"`],        [(A), (B), (C), ...],    [Letter + parentheses],
  [`"App. 1"`],     [App. 1, App. 2, ...],   [Literal prefix + number],
  [`"1.1"`],        [1.1, 1.2, 2.1, ...],    [Chapter.number (needs `use-chapter: true`)],
  [`"I.A"`],        [I.A, I.B, II.A, ...],   [Roman chapter + letter index],
  [`"§1-A"`],       [§1-A, §1-B, ...],       [Symbol + chapter + letter],
  table.hline(stroke: 1.5pt),
)

With `use-chapter: true`, the *last* placeholder in the format string is treated as the figure/table's own number; the *N-1 preceding ones* are heading-level prefixes (matching `=`, `==`, `===` ...). For example, `"I.1.1.A"` inside `=== 2.3.4` for the 5th table renders as `II.3.4.E`.

=== Function form (advanced)

`numbering-format` also accepts a function — equivalent to Typst's native `numbering((..nums) => ..., 1, 2)`:

```typst
#show: captab-style.with(
  use-chapter: false,
  numbering-format: (..nums) => {
    let n = nums.pos().last()
    [Tab§#n]                     // → "Tab§1", "Tab§2", ...
  },
)
```

With `use-chapter: true`, the function receives *all heading levels + the figure/table number* (without slicing — your function decides what to consume):

```typst
#show: captab-style.with(
  use-chapter: true,
  numbering-format: (..nums) => {
    let arr = nums.pos()
    let chap = arr.slice(0, arr.len() - 1)   // chapter chain
    let n = arr.last()                        // figure/table number
    [§#chap.map(str).join(".")—#n]            // "§2.3—5"
  },
)
```

=== Tables vs figures: separate or unified

```typst
// Fully separate (recommended)
#show: captab-style.with(numbering-format: "1.1")    // tables: 1.1, 1.2
#show: capfig-style.with(numbering-format: "I.1")    // figures: I.1, I.2

// Unified via cap-style
#show: cap-style.with(numbering-format: "1.1")       // both tables & figures: 1.1
```

=== Escape hatch: bypass cap-able entirely

cap-able installs `set figure(numbering: ...)` inside `captab-style` / `capfig-style`. If even the function form is not enough, write your own `set figure(...)` *after* the cap-style call to fully replace it:

```typst
#show: cap-style.with(...)
#set figure.where(kind: table): set figure(numbering: num => [#sym.section.bold #num])
```

Note: this bypasses cap-able's bilingual supplement / continued-prefix show rules, so confirm you don't need those.

== Fine-grained caption text `caption-text`

cap-able's caption is *not* a real `figure.caption` element — to support bilingual layout, the caption is rendered manually as `text(...)` calls. As a result, `show figure.caption: set text(font: ...)` *does not work*. To change caption font / colour / tracking / etc., use the `caption-text` field.

`caption-text` accepts *any parameter Typst's native `text()` takes* (`font`, `fill`, `tracking`, `spacing`, `stretch`, ...) and supports both *flat* and *nested* forms:

=== Flat form — applies to the whole caption

```typst
#show: cap-style.with(
  caption-text: (font: "Times New Roman", fill: blue),
)
```

The whole caption (prefix + number + body) is wrapped uniformly.

=== Nested form — per-part overrides

If the dict contains *any* of `whole` / `prefix` / `supplement` / `number` / `body`, it is treated as nested:

#table(
  columns: (1fr, 4fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Layer*][*Scope*],
  table.hline(stroke: 0.5pt),
  [`whole`],      [Entire caption (outermost default)],
  [`prefix`],     [Prefix block (supplement + number)],
  [`supplement`], [Just the supplement word ("Table" / "Figure")],
  [`number`],     [Just the digits ("1" / "1.1" / "II.3.4.E" / ...)],
  [`body`],       [Just the body (the user-supplied caption text)],
  table.hline(stroke: 1.5pt),
)

Layers cascade: inner overrides outer. Example:

```typst
#show: cap-style.with(
  caption-text: (
    whole:  (font: "Helvetica"),         // outermost default
    number: (fill: red, weight: "bold"), // overlay: red bold on the digits
    body:   (font: "SimSun"),            // body uses SimSun
  ),
)
```

Result: supplement is Helvetica; number is red bold Helvetica; body is SimSun.

=== Common patterns

```typst
// 1. Whole caption Times
caption-text: (font: "Times New Roman")

// 2. Only the digits red
caption-text: (number: (fill: red))

// 3. Prefix bold Times, body regular SimSun
caption-text: (
  prefix: (font: "Times New Roman", weight: "bold"),
  body:   (font: "SimSun"),
)

// 4. Supplement monospace, number Times, body Helvetica
caption-text: (
  supplement: (font: "Courier"),
  number:     (font: "Times New Roman"),
  body:       (font: "Helvetica"),
)
```

=== Properties

- Default `(:)` does not affect rendering — fully backward compatible.
- When a key collides with `caption-size` / `caption-weight`, the dict's value wins (it acts as an override layer).
- Exposed on `cap-style` / `captab-style` / `capfig-style`.
- *Applies to continuation captions too* (both `continued-caption: true` and the `refer-to` continuation form).

== Bilingual Outline

By default, only the primary language caption appears in the outline (table of contents). Enable `outline-bilingual` to show both languages in the outline.

```typst
#show: captab-style.with(
  outline-bilingual: true,       // Enable bilingual outline
  outline-separator: " / ",      // Separator between primary and English
  outline-newline: false,        // false: same line; true: English on new line
)
```

Three related parameters:

- `outline-bilingual`: Show bilingual captions in outline (default `false`)
- `outline-separator`: Separator between primary and English captions (default `" / "`)
- `outline-newline`: Put English caption on a new line (default `false`)

All three configuration functions (`captab-style`, `capfig-style`, `cap-style`) support these parameters. Use `cap-style` to enable bilingual outline for both tables and figures at once.

// ============================================================
// Chapter 7: Multilingual Support
// ============================================================
= Multilingual Support

The package supports 25+ languages with automatic localization. Just set the document language and the package automatically uses the correct text.

```typst
#set text(lang: "de")   // Switch to German

#captab(
  caption: [Experimentelle Ergebnisse],
  caption-en: [Experimental Results],
)[...]
// Caption shows: Tabelle 1  Experimentelle Ergebnisse
//                Table 1 Experimental Results
```

== Supported Languages

#table(
  columns: (1fr, 1fr, 1fr, 1fr),
  stroke: none,
  inset: 5pt,
  table.hline(stroke: 1.5pt),
  table.header[*Code*][*Language*][*Code*][*Language*],
  table.hline(stroke: 0.5pt),
  [en], [English], [zh], [Chinese],
  [de], [German], [fr], [French],
  [es], [Spanish], [it], [Italian],
  [pt], [Portuguese], [ru], [Russian],
  [ja], [Japanese], [ko], [Korean],
  [ar], [Arabic ↵], [he], [Hebrew ↵],
  [fa], [Persian ↵], [ur], [Urdu ↵],
  [nl], [Dutch], [pl], [Polish],
  [cs], [Czech], [sv], [Swedish],
  [da], [Danish], [no], [Norwegian],
  [fi], [Finnish], [tr], [Turkish],
  [el], [Greek], [hi], [Hindi],
  [th], [Thai], [vi], [Vietnamese],
  table.hline(stroke: 1.5pt),
)

↵ = Right-to-left language; Traditional Chinese is distinguished via the `region` parameter.

#pagebreak()

== Simplified vs Traditional Chinese

The package distinguishes Simplified Chinese (`zh`) from Traditional Chinese (`zh-TW`) using Typst's `text.region` parameter:

```typst
// Simplified Chinese (default)
#set text(lang: "zh")

// Traditional Chinese
#set text(lang: "zh", region: "TW")
```

Key differences:

#table(
  columns: (1fr, 1fr, 1fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Item*][*Simplified*][*Traditional*],
  table.hline(stroke: 0.5pt),
  [Table prefix], [表], [表],
  [Figure prefix], [图], [圖],
  [Continued table], [续表], [續表],
  [Continued figure], [续图], [續圖],
  [Continued suffix], [（续）], [（續）],
  table.hline(stroke: 1.5pt),
)

#set text(lang: "zh", region: "TW")

#captab(
  caption: [繁體中文測試表格],
  caption-en: [Traditional Chinese Test Table],
  label: <tab:zh-TW>
)[
  | 項目 | 數值 |
  | ---- | ---- |
  | 測試 | 100  |
]

#captab(
  caption: [繁體中文測試表格],
  caption-en: [Traditional Chinese Test Table],
  refer-to: <tab:zh-TW>
)[
  | 項目 | 數值 |
  | ---- | ---- |
  | 測試 | 100  |
]

#capfig(
  rect(width: 15%, height: 1.35cm, fill: green.lighten(80%)),
  caption: [繁體中文測試圖片],
  caption-en: [Traditional Chinese Test Figure],
)

#set text(lang: "en")

== RTL Language Support

For RTL languages (Arabic, Hebrew, Persian, Urdu), the package automatically:

- Reverses bilingual caption line order (RTL first, then English)
- Uses `box[]` wrapping to prevent direction confusion in RTL content
- Forces `dir: ltr` for the English line

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

== Language-Specific Formatting

Each language has customized separators and spacing:

- *Chinese/Japanese*: No space between prefix and number, em-space before title
- *French*: Space before colon ("Tableau 1 : Title")
- *Spanish/Italian*: Dot separator ("Table 1. Title")
- *English/German*: Colon+space ("Table 1: Title")

// ============================================================
// Chapter 8: Complete Usage Reference
// ============================================================
= Complete Usage Reference

This chapter is the authoritative reference listing every public function, every parameter, every accepted value, every alias, and every behavioral detail of cap-able.

== Public API Overview

#table(
  columns: (1.2fr, 0.8fr, 2fr),
  stroke: none,
  inset: 5pt,
  table.hline(stroke: 1.5pt),
  table.header[*Function*][*Category*][*Purpose*],
  table.hline(stroke: 0.5pt),
  [`cap-style`],              [Config],  [Shared style for tables & figures],
  [`captab-style`],           [Config],  [Global table style],
  [`capfig-style`],           [Config],  [Global figure style],
  [`set-table-width`],        [Config],  [Global table width %],
  [`captab`],                 [Table],   [Three-line table],
  [`capfig`],                 [Figure],  [Single bilingual figure],
  [`capsubfig`],              [Figure],  [Subfigure layout],
  [`captnote`],               [Note],    [Table note],
  [`capfnote`],               [Note],    [Figure note],
  [`bicap`],                  [Caption], [Standalone bilingual caption],
  table.hline(stroke: 1.5pt),
)

== `set-table-width` Complete Parameters

#table(
  columns: (1fr, 1.4fr, 3fr),
  stroke: none,
  inset: 5pt,
  table.hline(stroke: 1.5pt),
  table.header[*Param*][*Type*][*Description*],
  table.hline(stroke: 0.5pt),
  [`width`], [`auto` / `length` / `ratio`], [New API. `auto` = unconstrained; pass `8cm` / `80%` / `80.5%`],
  [`percentage`], [`int` (1--100)], [Legacy API (kept for backward compat). Converted to `<int>%`],
  table.hline(stroke: 1.5pt),
)

When both are passed, `width` wins.

```typst
#set-table-width(width: 80%)        // new form
#set-table-width(width: 8cm)        // absolute width
#set-table-width(width: auto)       // back to unconstrained
#set-table-width(percentage: 80)    // legacy still works
```

== `cap-style` Complete Parameters

`cap-style` is the unified entry point: it writes all shared parameters into both the table and figure config states (equivalent to calling `captab-style.with(...)` and `capfig-style.with(...)` in sequence). A subsequent `captab-style` / `capfig-style` call can still override per-type.

#table(
  columns: (1.8fr, 1fr, 2.5fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Param*][*Default*][*Description*],
  table.hline(stroke: 0.5pt),
  [`numbering-format`],       [`"1"`],         [Numbering format: any string accepted by Typst's native `numbering()` (e.g. `"1.1"`, `"A.1"`, `"§1-A"`) or a function `(..nums) => content`],
  [`use-chapter`],            [`false`],       [Include chapter number],
  [`supplement`],             [`auto`],        [Main language prefix],
  [`supplement-en`],          [`auto`],        [English prefix],
  [`continued-prefix`],       [`auto`],        [Continued prefix (main lang)],
  [`continued-prefix-en`],    [`auto`],        [Continued prefix (English)],
  [`continued-suffix`],       [`auto`],        [Continued suffix (main lang)],
  [`continued-suffix-en`],    [`auto`],        [Continued suffix (English)],
  [`continued-mode`],         [`"prefix"`],    [Continuation mode `"prefix"` / `"suffix"`],
  [`continued-show-caption`], [`auto`],        [Show caption text in continuation],
  [`caption-size`],           [`10.5pt`],      [Caption size],
  [`caption-weight`],         [`"regular"`],   [Caption weight],
  [`caption-text`],           [`(:)`],         [Pass-through dict for caption `text(...)`. Flat form (e.g. `(font: "Times")`) applies to the whole caption; nested form (any of `whole` / `prefix` / `supplement` / `number` / `body`) layers per part. See "Fine-grained caption text" section.],
  [`caption-leading`],        [`0.5em`],       [Caption line spacing],
  [`caption-above`],          [`1.5em`],       [Space above caption],
  [`pre-supplement-number-spacing`],  [`auto`], [Prefix--number spacing],
  [`post-supplement-number-spacing`], [`auto`], [Number--suffix spacing],
  [`number-title-spacing`],   [`auto`],        [Number--title separator],
  [`number-title-spacing-en`],[`auto`],        [Number--English-title separator],
  [`lang`],                   [`auto`],        [Language code override],
  [`enable-english-caption`], [`true`],        [Enable English sub-caption],
  [`outline-bilingual`],      [`false`],       [Bilingual outline],
  [`outline-separator`],      [`" / "`],       [Outline separator],
  [`outline-newline`],        [`false`],       [Newline in outline],
  [`after-indent`],           [`auto`],        [Post-block indent fix],
  [`note-above`],             [`0.7em`],       [Above note],
  [`note-below`],             [`1em`],         [Below note],
  [`note-size`],              [`10.5pt`],      [Note size],
  [`note-leading`],           [`6.5pt`],       [Note leading],
  [`note-justify`],           [`true`],        [Justify note],
  [`caption-position`],       [`auto`],        [Caption position in `#bicap()[body]` mode (applies to both table/figure; `auto` keeps each kind's default)],
  [`caption-align`],          [`auto`],        [Caption horizontal alignment: string `"center"` / `"left"` / `"right"` / `"text-left"` / `"text-right"`, or dict `(main, continued)` to split],
  [`placement`],              [`none`],        [Floating placement: `none` (in-flow) / `top` / `bottom` (float top/bottom of page) / `auto` (Typst picks the closer of top/bottom); forces `breakable: false` when active],
  table.hline(stroke: 1.5pt),
)

*Parameters not exposed by `cap-style`* — table-only (`body-size` / `body-leading` / `cell-inset` / `inset` / `table-below` / `width` / `three-line-table` / `top-rule` / `middle-rule` / `bottom-rule` / `breakable` / `repeat-header` / `continued-caption`) and figure-only (`figure-above` / `figure-below` / `subcaption-*` / `gutter` / subfigure `label-*`) — must still be configured via `captab-style` / `capfig-style` directly.

== `captab-style` Complete Parameters

All parameters of `captab-style` with defaults. `auto` means auto-select based on document language.

#block(
  fill: rgb("#eef6ff"),
  stroke: 0.5pt + rgb("#3b82f6"),
  radius: 4pt,
  inset: 8pt,
)[
  *Patch semantics*: every parameter actually defaults to `auto`, meaning "leave the current state untouched". The "Default" column below shows the value used the first time the function is called. Subsequent `captab-style.with(...)` calls only override the fields you supply — any field you omit keeps its previous value. This lets you patch one dimension at a time without re-stating the entire configuration.
]


#table(
  columns: (1.8fr, 1fr, 2.5fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Param*][*Default*][*Description*],
  table.hline(stroke: 0.5pt),
  [`caption-above`],          [`1.5em`],       [Space above caption block],
  [`caption-below`],          [`0.5em`],       [Between caption and body],
  [`table-below`],            [`0.5em`],       [Below whole table],
  [`caption-leading`],        [`0.5em`],       [Caption line spacing],
  [`numbering-format`],       [`"1"`],         [Numbering format: any string accepted by Typst's native `numbering()` or a function `(..nums) => content`. See "Custom numbering" section for details.],
  [`use-chapter`],            [`true`],        [Include chapter number],
  [`supplement`],             [`auto`],        [Main language prefix],
  [`supplement-en`],          [`auto`],        [English prefix],
  [`continued-prefix`],       [`auto`],        [Continued prefix],
  [`continued-prefix-en`],    [`auto`],        [English continued prefix],
  [`continued-suffix`],       [`auto`],        [Continued suffix],
  [`continued-suffix-en`],    [`auto`],        [English continued suffix],
  [`continued-mode`],         [`"prefix"`],    [Continuation mode `"prefix"` / `"suffix"`],
  [`continued-show-caption`], [`auto`],        [Show caption text in continuation],
  [`caption-size`],           [`10.5pt`],      [Caption size],
  [`caption-weight`],         [`"regular"`],   [Caption weight],
  [`caption-text`],           [`(:)`],         [Pass-through dict for caption `text(...)`. Flat form (e.g. `(font: "Times")`) applies to the whole caption; nested form (any of `whole` / `prefix` / `supplement` / `number` / `body`) layers per part. See "Fine-grained caption text" section.],
  [`pre-supplement-number-spacing`],  [`auto`], [Prefix--number spacing],
  [`post-supplement-number-spacing`], [`auto`], [Number--suffix spacing],
  [`number-title-spacing`],       [`auto`],    [Number--title separator],
  [`number-title-spacing-en`],    [`auto`],    [Number--English-title separator],
  [`lang`],                   [`auto`],        [Language override],
  [`enable-english-caption`], [`true`],        [Enable English sub-caption],
  [`body-size`],              [`10.5pt`],      [Body font size],
  [`body-leading`],           [`0.45em`],      [Body line spacing],
  [`cell-inset`],             [`(x: 5pt, y: 5pt)`], [Cell padding (dict or scalar); alias of `inset`, `cell-inset` wins if both passed],
  [`inset`],                  [`auto`],             [Alias of `cell-inset` (matches captab's `inset` parameter name)],
  [`note-above`],             [`0.5em`],       [Above note],
  [`note-below`],             [`1em`],         [Below note],
  [`note-size`],              [`10.5pt`],      [Note size],
  [`note-leading`],           [`6.5pt`],       [Note leading],
  [`note-justify`],           [`true`],        [Justify note],
  [`outline-bilingual`],      [`false`],       [Bilingual outline],
  [`outline-separator`],      [`" / "`],       [Outline separator],
  [`outline-newline`],        [`false`],       [Newline in outline],
  [`after-indent`],           [`auto`],        [Post-table indent fix],
  [`width`],                  [`auto`],        [Table width. `auto`=unconstrained (content-sized); `<length>` like `8cm`; `<ratio>` like `80%` / `80.5%`],
  [`three-line-table`],       [`true`],        [Three-line table mode (`false` skips the manual rules and uses Typst's default `table()` grid stroke)],
  [`top-rule`],               [`1.5pt`],       [Three-line top rule stroke (any stroke value, e.g. `2pt + red`; only used when `three-line-table: true`)],
  [`middle-rule`],            [`0.5pt`],       [Three-line middle rule stroke],
  [`bottom-rule`],            [`1.5pt`],       [Three-line bottom rule stroke],
  [`extra-rule`],             [`0.5pt`],       [Default stroke for `hlines` / `vlines` entries that omit `stroke`; accepts a single value or `(h: ..., v: ...)` dict for per-axis control],
  [`breakable`],              [`true`],        [Allow the table to break across pages (outer block's `breakable`)],
  [`repeat-header`],          [`true`],        [Repeat the markdown header row on each continuation page (`true` / `false` / positive int `n`)],
  [`show-continued-caption`],    [`false`],       [Repeat the caption on each continuation page using the refer-to ("Cont. Table X.Y") format. Deprecated alias `continued-caption` still works, removed in 0.2.0],
  [`caption-position`],       [`top`],         [Position of the caption relative to body in `#bicap()[body]` mode (`top` / `bottom`)],
  [`caption-align`],          [`"center"`],    [Caption horizontal alignment: `"center"` / `"left"` / `"right"` (table-local) / `"text-left"` / `"text-right"` (text-area-local); or dict `(main, continued)`],
  [`placement`],              [`none`],        [Floating placement: `none` / `top` / `bottom` / `auto` (forces `breakable: false` when active)],
  table.hline(stroke: 1.5pt),
)

*Spacing parameters may be length or content*: any `*-spacing` or `pre/post-supplement-number-spacing` accepts a length (e.g. `0.5em`) or content directly (e.g. `[\u{3000}]` em-space).

== `capfig-style` Complete Parameters

`capfig-style` merges figure style + figure spacing + subfigure defaults, updating all three states at once.

#block(
  fill: rgb("#eef6ff"),
  stroke: 0.5pt + rgb("#3b82f6"),
  radius: 4pt,
  inset: 8pt,
)[
  *Patch semantics*: same as `captab-style` — every parameter defaults to `auto`; only the fields you supply are written back. The "Default" column shows the initial state-dictionary value.
]


*Caption/numbering/language section*

#table(
  columns: (1.4fr, 1fr, 2.5fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Param*][*Default*][*Description*],
  table.hline(stroke: 0.5pt),
  [`numbering-format`],       [`"1"`],         [Numbering format: any string accepted by Typst's native `numbering()` (e.g. `"1.1"`, `"A.1"`, `"§1-A"`) or a function `(..nums) => content`],
  [`use-chapter`],            [`false`],       [Include chapter number],
  [`supplement`],             [`auto`],        [Main language prefix],
  [`supplement-en`],          [`auto`],        [English prefix],
  [`continued-prefix`],       [`auto`],        [Continued prefix (main lang)],
  [`continued-prefix-en`],    [`auto`],        [Continued prefix (English)],
  [`continued-suffix`],       [`auto`],        [Continued suffix (main lang)],
  [`continued-suffix-en`],    [`auto`],        [Continued suffix (English)],
  [`continued-mode`],         [`"prefix"`],    [Continuation mode `"prefix"` / `"suffix"`],
  [`continued-show-caption`], [`auto`],        [Show caption text in continuation],
  [`caption-size`],           [`10.5pt`],      [Caption size],
  [`caption-weight`],         [`"regular"`],   [Caption weight],
  [`caption-text`],           [`(:)`],         [Pass-through dict for caption `text(...)`. Flat form (e.g. `(font: "Times")`) applies to the whole caption; nested form (any of `whole` / `prefix` / `supplement` / `number` / `body`) layers per part. See "Fine-grained caption text" section.],
  [`caption-leading`],        [`0.5em`],       [Caption line spacing],
  [`pre-supplement-number-spacing`],  [`auto`], [Prefix--number spacing],
  [`post-supplement-number-spacing`], [`auto`], [Number--suffix spacing],
  [`number-title-spacing`],   [`auto`],        [Number--title separator],
  [`number-title-spacing-en`],[`auto`],        [Number--English-title separator],
  [`lang`],                   [`auto`],        [Language code override],
  [`enable-english-caption`], [`true`],        [Enable English sub-caption],
  [`outline-bilingual`],      [`false`],       [Bilingual outline],
  [`outline-separator`],      [`" / "`],       [Outline separator],
  [`outline-newline`],        [`false`],       [Newline in outline],
  [`after-indent`],           [`auto`],        [Post-block indent fix],
  [`note-above`],             [`0.7em`],       [Above note],
  [`note-below`],             [`1em + 1.5pt`], [Below note],
  [`note-size`],              [`10.5pt`],      [Note size],
  [`note-leading`],           [`6.5pt`],       [Note leading],
  [`note-justify`],           [`true`],        [Justify note],
  table.hline(stroke: 1.5pt),
)

*Figure spacing section*

#table(
  columns: (1.2fr, 1fr, 2.5fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Param*][*Default*][*Description*],
  table.hline(stroke: 0.5pt),
  [`figure-above`],       [`1em`],  [Space above figure],
  [`figure-below`],       [`1em`],  [Space below figure],
  [`caption-above`],      [`0.5em`], [Image--caption gap],
  [`caption-leading`],    [`0.5em`], [Caption leading],
  [`subcaption-above`],   [`0.3em`], [Subfig--subcaption gap],
  [`subcaption-below`],   [`0.5em`], [Below subcaption],
  [`subcaption-number-title-spacing`], [`auto`], [Separator between subcaption number and body (`auto` inherits main caption's `number-title-spacing`; accepts content / length)],
  table.hline(stroke: 1.5pt),
)

*Subfigure defaults section*

#table(
  columns: (1.3fr, 1fr, 2.3fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Param*][*Default*][*Description*],
  table.hline(stroke: 0.5pt),
  [`gutter`],             [`1em`],         [Horizontal gap],
  [`subcaption-pos`],     [`"bottom"`],    [Subcaption position],
  [`show-subcaption`],    [`false`],       [Show subcaptions],
  [`show-subcaption-label`], [`true`],     [Subcaption includes label],
  [`align`],              [`"horizon"`],   [Vertical alignment],
  [`label-mode`],         [`none`],        [Label mode (`none` / `"overlay"`)],
  [`label-style`],        [`"(a)"` / dict],[Label style: pass `str` to share between overlay and subcaption; pass `(overlay: ..., subcaption: ...)` dict for per-side control (missing keys fall back to `"(a)"`)],
  [`label-font`],         [`("Arial",)`],  [Label font list],
  [`label-size`],         [`12pt`],        [Label size],
  [`label-offset`],       [`(4pt, 4pt)`],  [Offset],
  [`label-text-color`],   [`black`],       [Text color],
  [`label-stroke`],       [`none`],        [Stroke],
  [`label-bg`],           [`none`],        [Background],
  [`label-bg-shape`],     [`"rect"`],      [Background shape],
  [`label-bg-radius`],    [`2pt`],         [Rect radius],
  [`label-bg-inset`],     [`3pt`],         [Background padding],
  [`label-sep`],          [`auto`],        [Subref separator (`auto`: number -> `"."`, letter -> `""`; defaults to `""` in `subref-style: "full"` mode)],
  [`subref-style`],       [`"letter"`],    [Subref letter style: `"letter"` (just the letter, e.g. `Fig. 1a`) / `"full"` (with label-style decorations, e.g. `Fig. 1(a)`)],
  [`caption-position`],   [`bottom`],      [Caption position relative to body in `#bicap()[body]` mode (figures default to `bottom`)],
  [`caption-align`],      [`"center"`],    [Caption horizontal alignment: `"center"` / `"left"` / `"right"` / `"text-left"` / `"text-right"`; or dict `(main, continued)`],
  [`placement`],          [`none`],        [Floating placement: `none` / `top` / `bottom` / `auto`],
  table.hline(stroke: 1.5pt),
)

== `captab` Complete Parameters

#table(
  columns: (1fr, 1.2fr, 2.5fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Param*][*Type*][*Description*],
  table.hline(stroke: 0.5pt),
  [`columns`],     [`auto` / `int` / `array`], [Column config (preferred; `auto` or length array, supports `fr`/abs units)],
  [`cols`],        [`auto` / `int` / `array`], [Back-compat alias for `columns` (`columns` wins if both set)],
  [`align`],       [`auto` / `alignment` / `array` / `function`], [Cell alignment; merged with markdown `:---:` syntax (forwarded to tablem then to `table.align`)],
  [`size`],        [`auto` / `length`],        [Body font size],
  [`leading`],     [`auto` / `length`],        [Body line spacing],
  [`inset`],       [`auto` / `length` / `dictionary`], [Cell padding (alias of `cell-inset`; `cell-inset` wins if both passed)],
  [`cell-inset`],  [`auto` / `length` / `dictionary`], [Alias of `inset` (matches the global `captab-style.cell-inset` name)],
  [`caption`],     [`none` / `content`],       [Main language caption],
  [`caption-en`],  [`none` / `content`],       [English caption],
  [`refer-to`],    [`none` / `label`],         [Label ref for continuation],
  [`show-caption`],[`auto` / `bool`],          [Show caption in continuation],
  [`width`],       [`auto` / `length` / `ratio`], [Table width (`auto` reads global, default `auto` unconstrained; pass `8cm` / `80%` / `80.5%`)],
  [`caption-position`], [`auto` / `top` / `bottom`], [Caption position (`auto` reads global `caption-position`, default `top`; `bottom` places the caption below the table; combined with `continued-caption: true` the latter is silently disabled)],
  [`caption-align`], [`auto` / `str` / `dict`], [Caption horizontal alignment: `"center"` / `"left"` / `"right"` (table-local) / `"text-left"` / `"text-right"` (text-area-local); or dict `(main, continued)` to split; `auto` reads global],
  [`placement`], [`none` / `top` / `bottom` / `auto`], [Floating placement (`none` in-flow, `top`/`bottom` to page edge, `auto` lets Typst pick the closer of top/bottom); omit to follow global state (initially `none`); forces `breakable: false` when active],
  [`three-line-table`], [`auto` / `bool`],     [Three-line mode (`auto` reads global `three-line-table`, default `true`)],
  [`top-rule`],    [`auto` / `stroke`],        [Top rule stroke (`auto` reads global `top-rule`, default `1.5pt`; only used when `three-line-table: true`)],
  [`middle-rule`], [`auto` / `stroke`],        [Middle rule stroke (`auto` reads global `middle-rule`, default `0.5pt`)],
  [`bottom-rule`], [`auto` / `stroke`],        [Bottom rule stroke (`auto` reads global `bottom-rule`, default `1.5pt`)],
  [`extra-rule`], [`auto` / `stroke` / `dict`], [Default stroke for `hlines` / `vlines` (when entries omit `stroke`); single value or `(h: ..., v: ...)` dict for per-axis (missing keys fall back to `0.5pt`); per-line `stroke` still wins],
  [`breakable`],   [`auto` / `bool`],          [Allow page break (`auto` reads global `breakable`, default `true`)],
  [`repeat-header`],[`auto` / `bool` / `int`], [Repeat header row on continuation pages (`auto` reads global `repeat-header`)],
  [`show-continued-caption`],[`auto` / `bool`],   [Repeat caption on each continuation page (refer-to format). Deprecated alias `continued-caption` still works (removed in 0.2.0); preferred name wins if both passed],
  [`hlines`],      [`array` of `int` / `dictionary`],  [Extra horizontal rules; entries may be `int` (shorthand for `(row: N)`) or full dicts],
  [`vlines`],      [`array` of `int` / `dictionary`],  [Extra vertical rules; entries may be `int` (shorthand for `(col: N)`) or full dicts],
  [`label`],       [`none` / `label`],         [Cross-reference label],
  [`content`],     [`content` (positional)],   [Markdown-style body],
  table.hline(stroke: 1.5pt),
)

*`hlines` / `vlines` dict structure*:

#table(
  columns: (1fr, 1fr, 1fr, 3fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Key*][*hlines default*][*vlines default*][*Description*],
  table.hline(stroke: 0.5pt),
  [`row` / `col`], [`2`],      [`1`],      [Row above (h) or col right (v)],
  [`start`],       [`0`],      [`0`],      [Start col/row index],
  [`end`],         [`none`],   [`none`],   [End index (`none` = to end)],
  [`stroke`],      [`0.5pt`],  [`0.5pt`],  [Rule stroke],
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
  caption: [Complex Rules],
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
  caption: [Complex Rules],
)[
  | A | B | C | D |
  | - | - | - | - |
  | 1 | 2 | 3 | 4 |
  | 5 | 6 | 7 | 8 |
  | 9 | 0 | 1 | 2 |
]

=== Continuation Mode Examples

*Prefix mode (default)*: shows `"Continuation of Table 1.1"`

*Suffix mode*: shows `"Table 1.1 (continued)"`

```typst
#show: captab-style.with(continued-mode: "suffix")
#captab(caption: [Long Table], label: <tab:long2>)[...]
#captab(refer-to: <tab:long2>)[...]  // Shows "Table 1.1 (continued)"
```

*Force show / hide caption text*:

```typst
// Force show
#captab(
  refer-to: <tab:original>,
  caption: [Original Caption],
  show-caption: true,
)[...]

// Force hide (even when caption is provided)
#captab(
  refer-to: <tab:original>,
  show-caption: false,
)[...]
```

== `bicap` Standalone Caption Function

`bicap` is the standalone caption generator; usable independently of `captab`/`capfig` for custom layouts or embedding bilingual captions in plain Typst tables/figures.

Starting from 0.1.0 `bicap` supports *two calling forms*:

- *Caption only*: `#bicap(caption: ..., kind: ...)` — renders the caption alone in its own non-breakable block.
- *Caption + body*: `#bicap(caption: ..., kind: ...)[body]` — wraps `body` and the caption together in a single non-breakable block, conceptually a cap-able-flavoured `figure(body, caption: ...)`. The `body` may also be passed via the named argument `body: [...]`.

The relative position of caption vs. body is controlled by `caption-position`:

- The default follows the global state — `top` for tables, `bottom` for figures.
- Override globally via `captab-style` / `capfig-style` with `caption-position: top | bottom`.
- Override per-call by passing `position: top | bottom` to `bicap`.

=== Caption horizontal alignment `caption-align`

`caption-align` controls how the caption sits horizontally relative to the table/figure and the text area. Five values:

#table(
  columns: (1fr, 4fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Value*][*Meaning*],
  table.hline(stroke: 0.5pt),
  [`"center"` (default)], [Caption centered within the table/figure's own width (current behaviour)],
  [`"left"`],   [Aligned to the table/figure's left edge (table-local)],
  [`"right"`],  [Aligned to the table/figure's right edge (table-local)],
  [`"text-left"`],  [Aligned to the text-area left edge (regardless of table/figure width)],
  [`"text-right"`], [Aligned to the text-area right edge],
  table.hline(stroke: 1.5pt),
)

When `width: 100%` the table/figure fills the text width, so `"left" ≡ "text-left"` and `"right" ≡ "text-right"` collapse naturally.

*Splitting main vs continuation captions* — pass a dict:

```typst
#captab(
  caption-align: (main: "left", continued: "right"),
  continued-caption: true,
  ...
)[ ... ]
```

`main` controls the first-page caption; `continued` controls the "Cont. Table X.Y" caption that appears on each break page when `continued-caption: true`. Missing keys fall back to `"center"`.

*Exposed at*:
- Global: `cap-style(caption-align: ...)`, `captab-style`, `capfig-style`
- Per-call: `captab(caption-align: ...)`, `bicap(caption-align: ...)`

#block(
  fill: rgb("#fff7ed"),
  stroke: 0.5pt + rgb("#f97316"),
  radius: 4pt,
  inset: 8pt,
)[
  *Known limitation: continuation `text-left` / `text-right` silently degrade*

  The continuation caption emitted by `continued-caption: true` is implemented as a cap-cell inside `table.header(level: 1, repeat: true)` — *structurally locked to the table's column width*, with no way to extend out to the text-area edges. We considered escape hatches via `place()` and `set page(footer: ...)` but each introduced new bugs (unstable coordinates, clobbering user-defined footers), so we picked an honest degradation over unstable magic.

  When `caption-align` (or the `continued` side of a dict) is `"text-left"` / `"text-right"`, the *continuation side* silently falls back to `"left"` / `"right"` (aligned to the table's column width). The main caption side is unaffected.

  *Workaround when needed — manual `refer-to`*: split the table into segments and write each continuation segment with a separate `captab(refer-to: <main>, caption-align: "text-left", ...)`. The continuation caption then lives outside the original table at full text width, and all five alignment values work precisely.
]

=== Floating placement `placement`

Mirrors Typst's native `figure(placement: ...)`: lifts the table/figure out of the document flow and *floats it to the top or bottom* of the current page (or the next one), letting body text fill the remaining space. Equivalent to LaTeX's `[t]` / `[b]`.

#table(
  columns: (1fr, 4fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Value*][*Meaning*],
  table.hline(stroke: 0.5pt),
  [`none` (default)], [Render in-flow (no float)],
  [`top`],    [Float to the *top* of the current or next page],
  [`bottom`], [Float to the *bottom* of the current or next page],
  [`auto`],   [Let Typst pick `top` or `bottom` automatically — whichever edge is closer to the current document position],
  table.hline(stroke: 1.5pt),
)

```typst
#captab(caption: ..., placement: top)[ ... ]      // float top
#captab(caption: ..., placement: bottom)[ ... ]   // float bottom
#capfig(caption: ..., placement: top)[ ... ]
#bicap(placement: top, ...)[ body ]

// Global: every table floats to the top
#show: captab-style.with(placement: top)
```

*Exposed at*:
- Global: `cap-style(placement: ...)`, `captab-style`, `capfig-style`
- Per-call: `captab` / `capfig` / `capsubfig` / `bicap`

#block(
  fill: rgb("#fff7ed"),
  stroke: 0.5pt + rgb("#f97316"),
  radius: 4pt,
  inset: 8pt,
)[
  *Known limitations*:

  + *Floats can't break across pages*. Typst's `place(float: true)` requires the floated content to fit on a single page, so:
    - When `placement: top` / `bottom` is active, cap-able *forces `breakable: false`* on the inner block — even if the user passes `breakable: true`.
    - A long table (taller than one page) will overflow / clip when floated. Keep `placement: none` for such tables and let them flow naturally.
  + *Incompatible with `continued-caption: true`*. Continuation depends on page breaks, which floats forbid; the combination effectively disables `continued-caption` (no continuation pages exist).
  + *Cross-references `@ref`*: cap-able wraps the *hidden figure* (counter-registration anchor) inside the float wrapper too, so `@ref` resolves to the float's *landing page* — matching what the reader sees. This mirrors Typst's native `figure(placement: ...)` behaviour.
]

#table(
  columns: (1.2fr, 1.2fr, 2.6fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Param*][*Type*][*Description*],
  table.hline(stroke: 0.5pt),
  [`caption`],      [`none` / `content`],   [Main caption],
  [`caption-en`],   [`none` / `content`],   [English caption],
  [`refer-to`],     [`none` / `label`],     [Continuation ref label],
  [`label`],        [`none` / `label`],     [Label for cross-ref],
  [`kind`],         [`"table"` / `"figure"`], [Kind (selects counter and config source)],
  [`show-caption`], [`auto` / `bool`],      [Show caption in continuation],
  [`config`],       [`auto` / `dictionary`], [`auto` reads the global config matching `kind`; otherwise uses the dict],
  [`position`],     [`auto` / `top` / `bottom`], [Caption position relative to body (only when body is given; `auto` follows global `caption-position`)],
  [`caption-align`],[`auto` / `str` / `dict`],   [Caption horizontal alignment: `"center"` / `"left"` / `"right"` / `"text-left"` / `"text-right"`, or dict `(main, continued)`; `auto` reads global],
  [`placement`],    [`none` / `top` / `bottom` / `auto`], [Floating placement (`auto` = Typst picks the closer of top/bottom); forces `breakable: false` when active],
  [`breakable`],    [`bool`],               [Whether the outer block may break across pages (default `true`; lets a breakable body flow naturally)],
  [`show-continued-caption`],[`auto` / `bool`], [When body breaks across pages, repeat the caption above each native `#table()` in body (default `false`; only when `kind == "table"`). Deprecated alias `continued-caption` still works, removed in 0.2.0],
  [`repeat-header`],[`auto` / `bool` / `int`], [Override the `repeat` setting of the markdown header in body's `#table()` (`auto` leaves user's value alone; `true/false/int` overrides; only when `kind == "table"`)],
  [`body`],         [`none` / `content`],   [Optional body; may also be passed via trailing block `#bicap()[...]`],
  table.hline(stroke: 1.5pt),
)

```typst
// Form 1: caption only (same as 0.0.x)
#align(center)[
  #rect(width: 6cm, height: 3cm, fill: gray.lighten(70%))
  #bicap(
    caption: [Custom Figure],
    caption-en: [Custom Figure],
    kind: "figure",
    label: <fig:custom>,
  )
]

// Form 2: bicap wraps the body (kind=table; caption defaults to top)
#bicap(
  caption: [Experimental Data],
  kind: "table",
  label: <tab:exp>,
)[
  #table(
    columns: 3,
    [A], [B], [C],
    [1], [2], [3],
  )
]

// kind=figure; caption defaults to bottom — use position: top to flip
#bicap(
  caption: [Schematic],
  kind: "figure",
  position: top,
)[
  #image("foo.png", width: 6cm)
]

// Long table that should repeat the caption on each continuation page (table-kind only)
#bicap(
  caption: [Long Data Table],
  kind: "table",
  continued-caption: true,
  label: <tab:long>,
)[
  #table(
    columns: 4,
    table.header([ID], [Name], [Value], [Note]),
    // ... 50+ rows of data
  )
]

// Repeat only the caption on continuation pages — turn off markdown header repetition
#bicap(
  caption: [Long Table],
  kind: "table",
  continued-caption: true,
  repeat-header: false,
)[
  #table(
    columns: 4,
    table.header([Col1], [Col2], [Col3], [Col4]),
    // ...
  )
]

// Or just disable markdown header repetition on its own, without continued-caption
#bicap(
  caption: [Short Table],
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
  *Convention: keep at most one `#table()` per bicap.* When `continued-caption: true`,
  bicap installs a `show table:` rule that injects the SAME caption header into
  *every* native `#table()` in body. If you stuff multiple tables under one bicap,
  every table's continuation page will show the same caption — usually not what you
  want. Use multiple `bicap(...)` calls or manage each table's caption with `captab`.

  Note: bicap detects `captab`'s own nested *level ≥ 2* header structure and skips
  the injection in that case (so wrapping `captab(continued-caption: true)` inside bicap
  won't produce stacked captions). Still, *avoid nesting captab inside a bicap with
  `continued-caption`* — the semantics get muddled and numbering can drift.
]

== `capfig` Complete Parameters

#table(
  columns: (1.1fr, 1fr, 2.8fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Param*][*Type*][*Description*],
  table.hline(stroke: 0.5pt),
  [`content`],       [`content` (positional)], [Figure body],
  [`caption`],       [`none` / `content`], [Main language caption],
  [`caption-en`],    [`none` / `content`], [English caption],
  [`label`],         [`none` / `label`],   [Cross-reference label],
  [`refer-to`],      [`none` / `label`],   [Continuation ref label],
  [`show-caption`],  [`auto` / `bool`],    [Show caption in continuation],
  [`figure-above`],  [`auto` / `length`],  [Space above figure (`auto` = global)],
  [`figure-below`],  [`auto` / `length`],  [Space below figure (`auto` = global)],
  [`caption-above`], [`auto` / `length`],  [Image--caption gap (`auto` = global)],
  [`caption-leading`], [`auto` / `length`], [Caption leading (`auto` = global)],
  table.hline(stroke: 1.5pt),
)

The figure body and caption are always wrapped in a non-breakable block; the caption is always placed below the image; if `capfig-style.lang` is `auto` while `captab-style.lang` is not, the figure inherits the table's language setting.

== `capsubfig` Complete Parameters

=== Subfigure Dict Structure

`subfigs` is an array of dicts; each supports:

#table(
  columns: (1.2fr, 1fr, 2.8fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Key*][*Required*][*Description*],
  table.hline(stroke: 0.5pt),
  [`content`],              [Yes],     [Subfigure body],
  [`subcaption`],           [Cond.],   [Subcaption (used when `show-subcaption: true`)],
  [`label`],                [Opt.],    [Cross-ref label, e.g. `Figure 1.1a`],
  [`label-style-override`], [Opt.],    [Per-item style override (overlay), see below],
  table.hline(stroke: 1.5pt),
)

=== `label-style-override` dict keys

Per-subfigure overrides for the overlay label. Affects the *overlay* side only; the subcaption does not participate.

#table(
  columns: (1fr, 3fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Key*][*Overrides*],
  table.hline(stroke: 0.5pt),
  [`style`],      [`label-style.overlay` (or `label-style` string form) — per-subfig overlay format string, e.g. `"[I]"`, `"{1}"`],
  [`font`],       [label font list],
  [`size`],       [label font size],
  [`offset`],     [label `(dx, dy)` offset],
  [`text-color`], [label text color],
  [`stroke`],     [label stroke],
  [`bg`],         [label background],
  [`bg-shape`],   [background shape],
  [`bg-radius`],  [rect radius],
  [`bg-inset`],   [background padding],
  table.hline(stroke: 1.5pt),
)

`style` also affects cross-references: when ref follows overlay (i.e. subcaption is hidden), `@ref` renders the per-subfig letter in that subfig's own format. When subcaption is visible, ref still follows the global subcaption style; the per-subfig `style` only changes the figure-stamped label.

=== Function Parameters

All params besides `subfigs` accept `auto` (inherit global `capfig-style`):

- `columns` (`auto` / `int`): Columns per row; `auto` = single row.
- `caption` / `caption-en` / `label` / `refer-to` / `show-caption`: Same as `capfig`.
- `gutter`, `subcaption-pos`, `show-subcaption`, `show-subcaption-label`, `align`, `label-mode`, `label-style`, `label-font`, `label-size`, `label-offset`, `label-text-color`, `label-stroke`, `label-bg`, `label-bg-shape`, `label-bg-radius`, `label-bg-inset`, `label-sep`, `subref-style`: Override the subfigure defaults from `capfig-style`.
  - `label-style` accepts `str` (overlay/subcaption share the style) or `(overlay: ..., subcaption: ...)` dict for per-side control. Missing keys fall back to the package default `"(a)"`.
- `figure-above`, `figure-below`, `caption-above`, `subcaption-above`, `subcaption-below`: Spacing overrides.
- `subcaption-number-title-spacing` (`auto` / `content` / `length`): separator between subcaption number and body; `auto` inherits the main caption's `number-title-spacing`.

=== Label Style Parse Rules

The parser scans `label-style` left-to-right, locates the *first* format char (`a`/`A`/`1`/`i`/`I`); everything before is prefix, everything after is suffix. If no format char exists, the whole string becomes prefix with default format `"a"`.

- Roman numerals support 1--20; fallback to Arabic.
- `label-sep` `auto` rule: number format -> `"."` (e.g. `"Figure 1.1.2"`), letter/roman format -> `""` (e.g. `"Figure 1.1a"`).

=== Overlay with Circle Background

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
  caption: [Circle bg + per-item override],
)
```

=== Multi-row Subfigures

Set `columns: N`; overflow auto-wraps, the last row shrinks to the actual count.

```typst
#capsubfig(
  (
    (content: rect(width: 2cm, height: 2cm, fill: red)),
    (content: rect(width: 2cm, height: 2cm, fill: green)),
    (content: rect(width: 2cm, height: 2cm, fill: blue)),
    (content: rect(width: 2cm, height: 2cm, fill: orange)),
    (content: rect(width: 2cm, height: 2cm, fill: purple)),
  ),
  columns: 3,                 // 3 per row: 3+2
  label-mode: "overlay",
  caption: [Five Subfigures],
)
```

== `captnote` Complete Parameters

#table(
  columns: (1fr, 1.2fr, 3fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Param*][*Type*][*Description*],
  table.hline(stroke: 0.5pt),
  [`width`],   [`auto` / `ratio` / `length`], [Width (three modes below)],
  [`justify`], [`auto` / `bool`], [Justify (`auto` = global `note-justify`)],
  [`content`], [`content` (positional)], [Table note body],
  table.hline(stroke: 1.5pt),
)

*Three width modes*:

- `width: auto` (default): Match current `captab` width via `table-width-config`.
- `width: 80%` etc. `ratio`: Narrow to percentage, centered.
- `width: 10cm` etc. `length`: Fixed width, centered.

```typst
#captnote[Auto match table width]
#captnote(width: 70%)[70% width centered]
#captnote(width: 8cm)[Fixed 8cm]
#captnote(justify: false)[No justification]
```

== `capfnote` Complete Parameters

#table(
  columns: (1fr, 1.2fr, 3fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Param*][*Type*][*Description*],
  table.hline(stroke: 0.5pt),
  [`width`],   [`ratio` / `length`], [Default `100%`; `auto` not supported],
  [`justify`], [`auto` / `bool`],    [Justify (`auto` = global `capfig-style.note-justify`)],
  [`content`], [`content`],          [Figure note body],
  table.hline(stroke: 1.5pt),
)

```typst
#capfig(image("chart.png"), caption: [Results])
#capfnote(width: 90%)[
  Source: 2024 Survey.
]
```

== Full Multilingual Rules

The following table lists prefix words and spacing rules for each language (`pre` = `pre-supplement-number-spacing`, `sep` = `number-title-spacing`):

#table(
  columns: (0.5fr, 0.8fr, 0.8fr, 0.5fr, 0.6fr, 1.2fr),
  stroke: none,
  inset: 3.5pt,
  table.hline(stroke: 1.5pt),
  table.header[*lang*][*table*][*figure*][*pre*][*sep*][*continued-suffix*],
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

↵ = Right-to-left language

*Auto-triggers post-table indent fix (`after-indent: auto`) for*: `zh`, `ja`, `ko`, `fr`, `vi`, `th`. Any language can override via explicit `after-indent: true`/`false`.

*RTL bilingual layout*: for `ar`/`he`/`fa`/`ur`, the main-language and English lines are auto-swapped, the English line is wrapped in `#text(dir: ltr)[...]` to prevent direction confusion, and in monolingual mode the main-language body is wrapped in `box[]`.

// ============================================================
// Chapter 9: API Reference
// ============================================================
= API Reference

This chapter provides auto-generated documentation from source code docstrings via tidy.

== Configuration Module (config.typ)

The configuration module provides global state management, multilingual text,
utility functions, and the two main configuration functions.

#tidy.show-module(
  tidy.parse-module(
    read("/cap-able/0.1.2/src/config.typ"),
    name: "config",
  ),
  show-module-name: false,
  omit-private-definitions: true,
)

== Caption Module (bicap.typ)

The caption module provides the core bilingual caption generation engine,
supporting both main and continuation (continued table/figure) modes.

#tidy.show-module(
  tidy.parse-module(
    read("/cap-able/0.1.2/src/bicap.typ"),
    name: "bicap",
  ),
  show-module-name: false,
  omit-private-definitions: true,
)

== Table Module (table.typ)

The table module provides academic-standard three-line table creation
and its aliases.

#tidy.show-module(
  tidy.parse-module(
    read("/cap-able/0.1.2/src/table.typ"),
    name: "table",
  ),
  show-module-name: false,
  omit-private-definitions: true,
)

== Note Module (note.typ)

The note module provides table and figure notes with auto-width matching
and multiple width modes.

#tidy.show-module(
  tidy.parse-module(
    read("/cap-able/0.1.2/src/note.typ"),
    name: "note",
  ),
  show-module-name: false,
  omit-private-definitions: true,
)

== Figure Module (figure.typ)

The figure module provides single figure and multi-subfigure layout functions,
supporting bilingual captions, overlay labels, and subcaptions.

#tidy.show-module(
  tidy.parse-module(
    read("/cap-able/0.1.2/src/figure.typ"),
    name: "figure",
  ),
  show-module-name: false,
  omit-private-definitions: true,
)

// ============================================================
// Chapter 10: FAQ
// ============================================================
= Frequently Asked Questions

== Why Markdown syntax for tables?

The Markdown table syntax (via `tablem`) is:

- Familiar to most users
- Easy to read and edit
- Quick to type
- Compatible with many editors

== How do I create tables without captions?

Simply omit the `caption` parameter:

```typst
#captab()[
  | A | B |
  | - | - |
  | 1 | 2 |
]
```

== Can I use regular Typst table syntax?

Yes! Use `bicap` to add a caption to any native Typst table:

```
#align(center)[
  #bicap(
    caption: [Regular Typst Table],
    caption-en: [Regular Typst Table],
    kind: "table",
  )
  #table(
  columns: 3,
  [A], [B], [C],
  [1], [2], [3],
  )
]
```

#align(center)[
  #bicap(
    caption: [Regular Typst Table],
    caption-en: [Regular Typst Table],
    kind: "table",
  )
  #table(
  columns: 3,
  [A], [B], [C],
  [1], [2], [3],
  )
]

== How do I reference tables and figures?

Use Typst's standard label and reference system:

```typst
#captab(caption: [...], label: <tab:example>)[...]

See @tab:example for details.
```

== Why doesn't my continued table show the caption?

This applies specifically to *manual `refer-to`* mode: by default, when `caption` is omitted (and `show-caption` is `auto`), the continuation only shows the "Cont. Table X.Y" number. To force the caption text:

```typst
#captab(
  refer-to: <tab:original>,
  caption: [Original Caption],  // provide caption text
  show-caption: true,           // or force it
)[...]
```

If you want the continuation caption to appear *automatically* on every continuation page when the table breaks, use the new `continued-caption` mode (since 0.1.0):

```typst
#captab(
  caption: [Original Caption],
  continued-caption: true,    // emits "Cont. Table X.Y Caption" on each continuation page
)[...]
```

See *Tables in Detail → Continued Tables* for the full comparison.

== How do I fix missing indentation after tables in Chinese?

The package automatically detects the language and fixes indentation (for Chinese, Japanese, etc.).

For manual control:

```typst
#show: captab-style.with(
  after-indent: true,   // Force fix
  // or
  after-indent: false,  // Disable fix
)
```

== How do I show bilingual captions in the table of contents?

```typst
#show: captab-style.with(
  outline-bilingual: true,      // Enable bilingual outline
  outline-separator: " / ",     // Separator
  outline-newline: false,       // true=newline, false=same line
)
```

== Why no `capsubtab` (sub-tables)?

cap-able currently *does not* ship a `capsubtab`. Reasons:

1. *Sub-tables are rare in academic typesetting*. Most style guides do not have a dedicated section on sub-tables; the prevailing practice is to merge comparison data into a *single larger table with an extra "Group" column* rather than splitting into (a)(b) sub-tables. Sub-figures (`capsubfig`) are everywhere in the literature; sub-tables show up in only a small fraction of cases.
2. *Page-break behaviour is harder*. A side-by-side row of sub-tables is an atomic block — long content overflows rather than flowing across pages; sub-figures (typically images) are short enough that this rarely matters.
3. *A workable manual recipe already exists*. For two small tables side by side, `grid` + multiple `captab(caption: none)` wrapped in an outer `figure(kind: table, ...)` is enough; the only thing missing is automatic sub-table cross-references like `@tab:sub-a` → "1.2a", and most authors just write "as shown in Table 1.2(a)" inline without a label anyway.

#block(
  fill: rgb("#fff7e6"),
  stroke: 0.5pt + rgb("#f59e0b"),
  radius: 4pt,
  inset: 8pt,
)[
  *Status*: an issue has been opened upstream to track this. *No requests to date.* If you actually need it and the manual `grid` recipe doesn't fit, please +1 the GitHub issue and we'll implement when demand materialises.
]

Example recipe for side-by-side small tables:

```typst
#figure(
  kind: table,
  supplement: [Table],
  caption: figure.caption(position: top)[Experimental vs. control group data],
  grid(
    columns: 2,
    column-gutter: 1em,
    align: top,
    [
      *(a) Experimental* \
      #captab(caption: none)[
        | ID | Value |
        | -- | ----- |
        | 1  | 100   |
        | 2  | 200   |
      ]
    ],
    [
      *(b) Control* \
      #captab(caption: none)[
        | ID | Value |
        | -- | ----- |
        | 1  | 95    |
        | 2  | 205   |
      ]
    ],
  ),
)<tab:cmp>
```

#figure(
  kind: table,
  supplement: [Table],
  caption: figure.caption(position: top)[Experimental vs. control group data],
  grid(
    columns: 2,
    column-gutter: 1em,
    align: top,
    [
      *(a) Experimental* \
      #captab(caption: none)[
        | ID | Value |
        | -- | ----- |
        | 1  | 100   |
        | 2  | 200   |
      ]
    ],
    [
      *(b) Control* \
      #captab(caption: none)[
        | ID | Value |
        | -- | ----- |
        | 1  | 95    |
        | 2  | 205   |
      ]
    ],
  ),
)<tab:cmp>

Reference: `@tab:cmp` resolves to "@tab:cmp". Sub-tables (a)(b) get no automatic labels; just write "as shown in @tab:cmp(a)" inline.

== Why does a smaller number appear below a larger one after using `placement`?

When you float an earlier-declared table to the page bottom with `placement: bottom`, the page may read "Table 2 ... Table 1" top-to-bottom — the smaller number sitting below the larger.

*This is not a bug — it is the inherent behavior of floats, and LaTeX behaves identically* (a `\begin{table}[b]` Table 1 likewise lands below a later in-flow Table 2). Floating *by definition* decouples *physical position* from *number order*:

- The *number* always follows *source declaration order* — this is the academic standard, and in-text references like "see Table 1" rely on it.
- The *physical position* follows the `placement` target.

=== If you want "the higher table to have the smaller number"

You can control this yourself, *with no cap-able setting changes*: since numbering follows declaration order, simply *declare the table you want numbered first* first.

```typst
// Desired: the upper table = Table 1, the bottom-floated table = Table 2
#captab(caption: [the upper one])[ ... ]                       // declared 1st → Table 1
#captab(caption: [floated to bottom], placement: bottom)[ ... ] // declared 2nd → Table 2
```

Declare the physically-higher table first → it gets the smaller number; declare the one to be floated later and add `placement: bottom`. For same-page floats this gives 100% control.

#block(
  fill: rgb("#fff7ed"),
  stroke: 0.5pt + rgb("#f97316"),
  radius: 4pt,
  inset: 8pt,
)[
  *⚠️ Do not manually manipulate the counter.* Do not try to force numbers via `counter(figure.where(kind: table)).update(...)` or similar — cap-able registers numbers through an internal hidden-figure mechanism (a +1 / −1 / step sequence); manual counter edits fight that machinery and will *desync numbering or cross-references*. Reordering your `captab` declarations is the only correct fix.
]

// ============================================================
// Chapter 11: Changelog
// ============================================================
= Changelog

== Version 0.1.2

*Fixed*:

- `captab-style` / `capfig-style` could trigger Typst's `"layout did not converge within 5 attempts"` warning when re-applied inside a nested `context`. Root cause: the patch implementation used a `context { state.get(); modify; state.update(new) }` read-then-write, and Typst's layout convergence checker would treat each iteration as a possible state change and fail to converge. Replaced with the functional form `state.update(prev => modify(prev))` — the updater is a pure function and does not read state, so Typst can judge idempotence directly. The PDF output was already correct; the warning was emitted on every compile. Reported downstream in a thesis template.
- With `use-chapter: true`, the body caption's chapter prefix could intermittently render as `0` (e.g. "Table 0.1" instead of "Table 3.1") while the LoT and `@ref` still showed the correct number. Root cause: the body caption read `counter(heading).get()` at its own `context { ... }` render position, which could drift to `(0,)` across layout iterations; the LoT / `@ref` path went through the figure's own `numbering:` closure, which Typst evaluates at the figure's landed location and is therefore stable. Fixed by having the body caption also *query the hidden figure's label to obtain its location* and read `counter(heading).at(loc)` — matching the LoT path. An anchor label `__bicap_anchor_<n>` is auto-synthesised when the user did not supply one.
- The caption could be separated from its table/figure across a page break (issue #16). The `breakable: true` outer block allowed a page break to fall between the caption and the body, orphaning the caption at the bottom of one page while the body started on the next. The "leading" block (the caption for `caption-position: top`, the body for `bottom`) is now wrapped in `block(sticky: true)`, so it moves to the next page together with the content it leads — never separated. The body still breaks internally as normal.
- `placement: top` / `bottom` / `auto` no longer breaks the `figure-above` / `figure-below` spacing (and captab's `caption-above` / `table-below`) (issue #14). A floated element is wrapped in `place(float: true)`, on which outer `v()` / block margins have no effect; the float-to-body spacing now goes through `place`'s `clearance` parameter. A float only has one meaningful gap (toward the body): `top` uses the below spacing, `bottom` uses the above spacing, `auto` falls back to below.

*Added / Deprecated*:

- `continued-caption` renamed to `show-continued-caption` (consistent with `show-subcaption` / `show-subcaption-label`). The old name `continued-caption` *still works* in 0.1.x and will be *removed in 0.2.0*. The preferred name wins if both are passed. Affects `captab` / `captab-style` / `bicap`.

== Version 0.1.1

*Fixed*:

- User-supplied `hlines` `row` index was incorrectly shifted relative to the markdown table when `continued-caption: true` (issue #8). The injected caption row at y=0 was not compensated for in the user's `row`, so `row: 2` ended up between the caption and the header. After the fix, `row` is always indexed against the markdown table itself, regardless of `continued-caption`. ⚠️ Compatibility: if you used `row: N+1` as a workaround, please switch back to `row: N` — otherwise you'll get two overlapping lines.
- `subcaption-number-title-spacing` with a length value (e.g. `0.3em`) raised `"cannot join string with length"` because the length was being joined into the content as a value; this also suppressed the hidden-figure registration, leading to a chain failure where `@subfig` reported "label not exist" (issue #9). The fix routes the value through `handle-spacing`, which wraps lengths/relatives into `h(...)` and passes content through.

*Added*:

- `subref-style` config on `capfig-style` / `capsubfig` (default `"letter"`, new `"full"`) — controls the letter style of `@subfig` cross-references. `"letter"` shows just the letter (backward-compatible, `Fig. 1a`); `"full"` keeps the `label-style` decorations (`Fig. 1(a)`). In `"full"` mode `label-sep` defaults to empty (decorations already separate visually). Issue #10.
- `extra-rule` config on `captab` / `captab-style` (default `0.5pt`) — default stroke for `hlines` / `vlines` entries that omit `stroke`, so you don't repeat the same stroke per line. Accepts a single value (shared by h & v) or a `(h: ..., v: ...)` dict for per-axis. Per-line `stroke` still wins.
- `hlines` / `vlines` entries now accept an *int shorthand*: `hlines: (2, 3, 4)` is equivalent to `((row: 2,), (row: 3,), (row: 4,))`. Can mix with full dicts: `hlines: (2, (row: 5, stroke: 1pt), 7)`.

== Version 0.1.0

*New features*:

- `captab` and `captab-style` gain a `breakable` parameter (bool, default `true`) — controls whether the three-line table can break across pages. The outer `block` now follows this flag, so long tables flow naturally instead of being clipped to one page.
- New `repeat-header` parameter (bool / positive int, default `true`) — repeats the markdown header row on each continuation page using Typst's native `table.header(repeat: ...)`. `true` = repeat on every continuation; `n` = first n continuation pages only; `false` = disable.
- New `continued-caption` parameter (bool, default `false`) — adds a "Cont. Table X.Y caption" header on each continuation page (same format as `refer-to` mode; number anchored to the main table). The caption row and markdown header row live in two separate `table.header` blocks (with `level: 1/2`), so `continued-caption: true` can coexist with `repeat-header: false`. Continuation cells locate the main table via `query(label)` and delegate to the refer-to branch of `_make_caption_content`, so they never re-register a figure or advance the counter; cap-able auto-synthesises a hidden label when the user did not provide one.
- `bicap` now supports the `#bicap(...)[body]` calling form: wraps caption + body in a single non-breakable block, conceptually a cap-able-flavoured `figure(body, caption: ...)`. `body` can also be passed via the named arg `body: [...]`.
- `bicap` gains `continued-caption` (bool, default false): when `kind: "table"`, every native `#table()` in body has its caption repeated on each continuation page (same mechanism as `captab(continued-caption: true)`). Convention: one table per bicap; multiple tables share the same injected caption.
- `bicap` gains `repeat-header` (auto/bool/int, default auto): overrides the `repeat` setting of the markdown header inside body's `#table()`. Independent of `continued-caption`; e.g. `repeat-header: false` to disable header repetition while keeping caption repetition (or alone).
- `captab` and `captab-style` gain `three-line-table` (bool, default `true`): set to `false` to drop the three-line style and use Typst's default `table()` grid stroke instead. `top-rule` / `middle-rule` / `bottom-rule` are inactive in that mode; user `hlines` / `vlines` still work.
- `captab` adds an explicit `align: auto` parameter and a `..extra-args` sink that forwards any other named arguments (`fill` / `stroke` / `gutter` / `column-gutter` / `row-gutter` / `rows`, etc.) straight to the underlying `table(...)`, matching tablem's advanced-usage surface. A user-supplied `stroke` overrides the `stroke: none` we emit in three-line mode (combine with `three-line-table: false` for a clean grid; otherwise the three manual hlines stack on top of your stroke).
- `cell-inset` and `inset` are now aliases of each other across `captab` / `captab-style`: previously `captab` only accepted `inset:` while the global config only accepted `cell-inset:`. Both names now work everywhere; if both are passed, `cell-inset` wins (matches the canonical state key).
- Table-width system reworked. Default changed from "fill 100% of text width" to *`auto` (sized to content)*. New `width` parameter on `captab` and `captab-style`, accepting `auto` / `<length>` (e.g. `8cm`) / `<ratio>` (e.g. `80%`, `80.5%`). `set-table-width` gains a `width:` parameter (legacy `percentage:` int still supported and converted to `<int>%`). Priority: *per-call > global state > `auto`*. When `width != auto` and the user did not pass `columns`, the default switches to `(1fr,) * N` so the table fills the configured width; when `width == auto`, the default is `(auto,) * N` for content sizing.
- Fix `captab`'s alignment handling: passing an already-2D alignment (e.g. `align: horizon + center`) no longer panics with "cannot add a vertical and a 2D alignment". The logic now only appends `+ horizon` when the alignment's `y` component is missing.
- New `caption-position` config (`top` / `bottom`) — controls whether the caption is above or below body for both `captab` and `bicap()[body]`. Defaults follow kind: table=top, figure=bottom. Override globally via `captab-style` / `capfig-style` / `cap-style`, or per call via `captab(caption-position: ...)` / `bicap(position: ...)`. Known limitation: `caption-position: bottom` and `continued-caption: true` are incompatible (continuation repetition would require `table.footer`, which locks the caption inside the table's column boundaries); when both are set, `continued-caption` is silently disabled.
- New `caption-align` config (default `"center"`) — controls horizontal alignment of the caption. Five values: `"center"` / `"left"` / `"right"` (table-local) / `"text-left"` / `"text-right"` (text-area-local). Also accepts a dict `(main: ..., continued: ...)` to split main vs continuation captions (missing keys fall back to `"center"`). Exposed via `cap-style` / `captab-style` / `capfig-style` / `captab` / `bicap`. Known limitation: continuation captions live inside `table.header` and are locked to the table's column width — `"text-left"` / `"text-right"` on the continuation side silently degrade to `"left"` / `"right"`; for true text-anchored continuation captions, fall back to manual `refer-to` splitting.
- *Renamed* `repeat-caption` → `continued-caption` (no alias retained, since 0.1.0 has not been merged yet). Affects both `captab` and `bicap`. The semantics are unchanged — bool, default `false`, controls whether the caption is auto-repeated on each continuation page.
- Fixed `numbering-format` being ignored when `use-chapter: false` — that branch hard-coded `numbering("1", num)`, so user-set formats like `"(A)"` or `"App. 1"` had no effect. Both branches now honour the configured format.
- New `placement` config (default `none`) — mirrors Typst's native `figure(placement: ...)`. Four values: `none` (in-flow, default) / `top` / `bottom` (float to top/bottom of current or next page) / `auto` (Typst picks `top` or `bottom` based on which edge is closer to the current position). Implemented by wrapping the outer block in `place(float: true)`; the hidden figure (cross-ref anchor) rides along inside the float wrapper, so `@ref` resolves to the float's landing page. Exposed via `cap-style` / `captab-style` / `capfig-style` / `captab` / `capfig` / `capsubfig` / `bicap`. Known limitations: (1) floats force `breakable: false` (Typst doesn't allow floats to break across pages); (2) tables taller than a page will overflow when floated — keep `placement: none` for them; (3) incompatible with `continued-caption: true` (which depends on page breaks).
- New `caption-text` config (default `(:)`) — pass-through dict for the caption's `text(...)` rendering. Accepts any Typst native `text()` parameter (`font` / `fill` / `tracking` / `spacing` / `stretch` / ...). Two forms: a *flat* dict (`(font: "Times")`) applies to the whole caption; a *nested* dict (containing any of `whole` / `prefix` / `supplement` / `number` / `body`) layers per part with inner overriding outer. Solves the "show rule on figure.caption doesn't change the font" problem — cap-able's caption isn't a real `figure.caption` element (it's manually rendered to support bilingual layout), so font/fill/tracking changes must go through `caption-text`. Exposed on `cap-style` / `captab-style` / `capfig-style`; applies to continuation captions as well.
- `numbering-format` now accepts `str | function`, matching the first argument of Typst's native `numbering()`. The function form receives *all heading levels + the figure/table number* (when `use-chapter: true`) or just the figure/table number (when `use-chapter: false`); the user function decides how to consume them. `calculate-chapter-levels` returns 0 for function-form formats (chapter-level is meaningless there). Also switched the format-string scan to grapheme clusters (`.clusters()`) so multi-byte literals like `"附 1"` no longer panic on UTF-8 boundaries.
- `bicap` gains a `breakable` parameter (bool, default `true`) — whether the outer block may break across pages. The previous design locked caption + body inside `breakable: false` and prevented an inherently breakable body (e.g. a long captab) from flowing across pages; the new default is transparent. Pass `breakable: false` explicitly to restore the old "atomic caption + body" behaviour.
- Subfigure `label-style-override` dict expanded with four new keys: `style` / `font` / `size` / `offset`, allowing per-subfig override of the overlay label's format string, font, size and offset. `style` also propagates to cross-references — when ref follows overlay (subcaption hidden), `@ref` renders that subfig's own format so the letter matches what's stamped on the figure. The subcaption side does not participate in per-subfig overrides (to keep subcaptions visually uniform).
- Subfigure `label-style` now accepts `str | dict` — passing a string (e.g. `"(a)"`) keeps overlay label and subcaption prefix coupled (default behaviour); passing a dict `(overlay: "a)", subcaption: "(a)")` decouples them, with missing keys falling back to the package default `"(a)"`. Cross-reference letters follow whichever side is actually visible — subcaption when shown (with `show-subcaption-label: true`), else overlay (when `label-mode: "overlay"`), with subcaption as the defensive fallback when neither is visible — so the rendered `@ref` letter always matches what the reader sees.
- New `subcaption-number-title-spacing` config (default `auto`) — controls the gap between the subcaption number prefix and its body. `auto` inherits the main caption's `number-title-spacing` so subcaptions render with the same separator as the main caption (instead of the previous bare single space). Configure globally via `capfig-style(subcaption-number-title-spacing: ...)` or per call via `capsubfig(subcaption-number-title-spacing: ...)`.

*Compatibility*:

- Default change: `breakable` defaults to `true` from 0.1.0 onward (versus the implicit `false` of 0.0.x). To preserve the old atomic behavior, pass `breakable: false` explicitly or set it globally via `captab-style.with(...)`.
- Default change: table width defaults to `auto` (content-sized) instead of "fill 100% of text width". To restore the old behaviour, pass `set-table-width(width: 100%)` or `captab-style.with(width: 100%)`. Tables that explicitly use `fr` columns continue to expand by their fr factors (constrained by the parent block); tables that previously relied on the implicit 100% width with no `columns` will now appear content-sized.

== Version 0.0.2

*Bug fixes*:

- `captab-style` / `capfig-style` / `cap-style` switched to *patch semantics*. Every parameter now defaults to `auto`, and only the fields you explicitly pass get written back to state. This means you can call `captab-style.with(...)` repeatedly to override one dimension at a time (e.g. enabling `outline-bilingual`) without resetting omitted fields (e.g. `cell-inset`) to their function defaults. Show / set rules now read the latest merged values via `context { state.get() }` at render time.

*New features*:

- `captab` and `captab-style` gain `top-rule` / `middle-rule` / `bottom-rule` parameters for customising the three-line table's top, middle, and bottom rules. Accept any Typst stroke value, e.g. `2pt + red`, `stroke(thickness: 1pt, dash: "dashed")`. Defaults remain `1.5pt` / `0.5pt` / `1.5pt`.
- `captab` gains a `columns` parameter as the preferred alias of `cols`, matching Typst's native `table(columns: ...)` naming. `cols` is still accepted as a back-compat alias.

*Documentation updates*:

- Complete parameter tables include `top-rule` / `middle-rule` / `bottom-rule` / `columns`.
- Added patch-semantics callouts before `captab-style` and `capfig-style` sections.
- Added `== Three-Line Strokes` subsection with usage examples.
- All `cols:` examples rewritten as `columns:`.

== Version 0.0.1

Initial release with:

- `captab` three-line table support
- Bilingual caption support
- Continued tables and figures
- `capsubfig` subfigure layouts
- Table and figure notes
- 25+ language localization
- RTL language support (Arabic, Hebrew, Persian, Urdu)
- Comprehensive configuration system
- Configuration functions: `cap-style` (unified), `captab-style`, `capfig-style`, `set-table-width`
