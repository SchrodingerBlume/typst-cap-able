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
#import "cap-able/0.0.2/lib.typ": *

// ============================================================
// Document Metadata
// ============================================================

#show: mantys(
  name: "cap-able",
  version: "0.0.2",
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
#set text(font:("Noto Serif CJK SC", "Devanagari Sangam MN"))
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
#import "@preview/cap-able:0.0.2": *
```

== Manual Installation

After downloading from the repository:

+ Place the `cap-able` folder in your project directory
+ Import with a relative path:

```typst
#import "cap-able/0.0.2/lib.typ": *
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

- Full text width
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

Add extra horizontal or vertical lines for complex layouts:

```typst
#captab(
  hlines: ((row: 3, stroke: 1pt),),   // Add 1pt horizontal line after row 3
  vlines: ((col: 1, start: 1),),      // Add vertical line at column 1 (from row 1)
  caption: [Table with Extra Lines],
)[...]
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

== Three-Line Strokes

Customize the top, middle and bottom rules of the three-line table via `top-rule` / `middle-rule` / `bottom-rule`. Any Typst stroke value works — thickness, color, even dashed:

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

For tables spanning multiple pages, use the `refer-to` parameter:

```typst
// First part (original table)
#captab(
  caption: [Long Data Table],
  label: <tab:long>,        // Set label for continuation reference
)[...]

// Continuation (header shows "Continued Table X")
#captab(
  caption: [Long Data Table],
  refer-to: <tab:long>,       // Reference original for numbering
)[...]
```

The continuation automatically:

- Uses the same number as the original table
- Adds continuation prefix/suffix
- Does not create a new entry in the table of contents

=== Continuation Mode

Control the continuation style via `continued-mode`:

- `"prefix"` (default): Prefix mode, e.g. "Continuation of Table 1"
- `"suffix"`: Suffix mode, e.g. "Table 1 (continued)"

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

Adjust table width as a percentage of text width:

```typst
#set-table-width(percentage: 80)   // 80% of text width

#captab(caption: [Narrow Table])[...]

#set-table-width(percentage: 100)  // Reset to full width
```

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
  columns: (1fr, 1fr, 3fr),
  stroke: none,
  inset: 5pt,
  table.hline(stroke: 1.5pt),
  table.header[*Param*][*Type*][*Description*],
  table.hline(stroke: 0.5pt),
  [`percentage`], [`int` (1--100)], [Table width as % of text area (asserted 1--100)],
  table.hline(stroke: 1.5pt),
)

```typst
#set-table-width(percentage: 80)   // 80% wide
#set-table-width(percentage: 100)  // Reset to full
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
  [`numbering-format`],       [`"1"`],         [Numbering format string],
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
  table.hline(stroke: 1.5pt),
)

*Parameters not exposed by `cap-style`* — table-body (`body-size` / `body-leading` / `cell-inset` / `table-below`) and figure-only fields (`figure-above` / `figure-below` / `subcaption-*` / `gutter` / subfigure `label-*`) — must still be configured via `captab-style` / `capfig-style` directly.

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
  [`numbering-format`],       [`"1"`],         [Numbering format],
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
  [`pre-supplement-number-spacing`],  [`auto`], [Prefix--number spacing],
  [`post-supplement-number-spacing`], [`auto`], [Number--suffix spacing],
  [`number-title-spacing`],       [`auto`],    [Number--title separator],
  [`number-title-spacing-en`],    [`auto`],    [Number--English-title separator],
  [`lang`],                   [`auto`],        [Language override],
  [`enable-english-caption`], [`true`],        [Enable English sub-caption],
  [`body-size`],              [`10.5pt`],      [Body font size],
  [`body-leading`],           [`0.45em`],      [Body line spacing],
  [`cell-inset`],             [`(x: 5pt, y: 5pt)`], [Cell padding (dict or scalar)],
  [`note-above`],             [`0.5em`],       [Above note],
  [`note-below`],             [`1em`],         [Below note],
  [`note-size`],              [`10.5pt`],      [Note size],
  [`note-leading`],           [`6.5pt`],       [Note leading],
  [`note-justify`],           [`true`],        [Justify note],
  [`outline-bilingual`],      [`false`],       [Bilingual outline],
  [`outline-separator`],      [`" / "`],       [Outline separator],
  [`outline-newline`],        [`false`],       [Newline in outline],
  [`after-indent`],           [`auto`],        [Post-table indent fix],
  [`top-rule`],               [`1.5pt`],       [Three-line top rule stroke (any stroke value, e.g. `2pt + red`)],
  [`middle-rule`],            [`0.5pt`],       [Three-line middle rule stroke],
  [`bottom-rule`],            [`1.5pt`],       [Three-line bottom rule stroke],
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
  [`numbering-format`],       [`"1"`],         [Numbering format string],
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
  [`label-style`],        [`"(a)"`],       [Label style string],
  [`label-font`],         [`("Arial",)`],  [Label font list],
  [`label-size`],         [`12pt`],        [Label size],
  [`label-offset`],       [`(4pt, 4pt)`],  [Offset],
  [`label-text-color`],   [`black`],       [Text color],
  [`label-stroke`],       [`none`],        [Stroke],
  [`label-bg`],           [`none`],        [Background],
  [`label-bg-shape`],     [`"rect"`],      [Background shape],
  [`label-bg-radius`],    [`2pt`],         [Rect radius],
  [`label-bg-inset`],     [`3pt`],         [Background padding],
  [`label-sep`],          [`auto`],        [Subref separator (`auto`: number -> `"."`, letter -> `""`)],
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
  [`size`],        [`auto` / `length`],        [Body font size],
  [`leading`],     [`auto` / `length`],        [Body line spacing],
  [`inset`],       [`auto` / `length` / `dictionary`], [Cell padding (dict `(x:, y:)` or scalar)],
  [`caption`],     [`none` / `content`],       [Main language caption],
  [`caption-en`],  [`none` / `content`],       [English caption],
  [`refer-to`],    [`none` / `label`],         [Label ref for continuation],
  [`show-caption`],[`auto` / `bool`],          [Show caption in continuation],
  [`top-rule`],    [`auto` / `stroke`],        [Top rule stroke (`auto` reads global `top-rule`, default `1.5pt`)],
  [`middle-rule`], [`auto` / `stroke`],        [Middle rule stroke (`auto` reads global `middle-rule`, default `0.5pt`)],
  [`bottom-rule`], [`auto` / `stroke`],        [Bottom rule stroke (`auto` reads global `bottom-rule`, default `1.5pt`)],
  [`hlines`],      [`array` of `dictionary`],  [Extra horizontal rules (see below)],
  [`vlines`],      [`array` of `dictionary`],  [Extra vertical rules (see below)],
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
  table.hline(stroke: 1.5pt),
)

```typst
// Standalone bilingual caption for a figure
#align(center)[
  #rect(width: 6cm, height: 3cm, fill: gray.lighten(70%))
  #bicap(
    caption: [Custom Figure],
    caption-en: [Custom Figure],
    kind: "figure",
    label: <fig:custom>,
  )
]
```

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

#table(
  columns: (1fr, 3fr),
  stroke: none,
  inset: 4pt,
  table.hline(stroke: 1.5pt),
  table.header[*Key*][*Overrides*],
  table.hline(stroke: 0.5pt),
  [`text-color`], [label text color],
  [`stroke`],     [label stroke],
  [`bg`],         [label background],
  [`bg-shape`],   [background shape],
  [`bg-radius`],  [rect radius],
  [`bg-inset`],   [background padding],
  table.hline(stroke: 1.5pt),
)

=== Function Parameters

All params besides `subfigs` accept `auto` (inherit global `capfig-style`):

- `columns` (`auto` / `int`): Columns per row; `auto` = single row.
- `caption` / `caption-en` / `label` / `refer-to` / `show-caption`: Same as `capfig`.
- `gutter`, `subcaption-pos`, `show-subcaption`, `show-subcaption-label`, `align`, `label-mode`, `label-style`, `label-font`, `label-size`, `label-offset`, `label-text-color`, `label-stroke`, `label-bg`, `label-bg-shape`, `label-bg-radius`, `label-bg-inset`, `label-sep`: Override the subfigure defaults from `capfig-style`.
- `figure-above`, `figure-below`, `caption-above`, `subcaption-above`, `subcaption-below`: Spacing overrides.

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
    read("/cap-able/0.0.2/src/config.typ"),
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
    read("/cap-able/0.0.2/src/bicap.typ"),
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
    read("/cap-able/0.0.2/src/table.typ"),
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
    read("/cap-able/0.0.2/src/note.typ"),
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
    read("/cap-able/0.0.2/src/figure.typ"),
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

By default, continued tables only show the number when `caption` is not provided. To force showing the caption text:

```typst
#captab(
  refer-to: <tab:original>,
  caption: [Original Caption],  // Provide caption text
  show-caption: true,           // Or force it
)[...]
```

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

// ============================================================
// Chapter 11: Changelog
// ============================================================
= Changelog

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
