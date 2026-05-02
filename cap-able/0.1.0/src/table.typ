// ============================================================
// 三线表模块 (Three-line Table Module)
// ============================================================
//
// 本模块提供符合学术规范的三线表功能。
// This module provides academic-standard three-line table functionality.
//
// 什么是三线表 / What is a three-line table:
// 三线表是学术出版物中最常用的表格样式，以三条水平线为特征，
// 无竖线，视觉简洁、信息层次清晰：
// The three-line table is the most common table style in academic publications,
// characterized by three horizontal rules and no vertical rules:
//
//  ═══════════════════════  ← 顶线 1.5pt（粗）/ Top rule 1.5pt (heavy)
//  Header | Header | Header
//  ───────────────────────  ← 中线 0.5pt（细）/ Middle rule 0.5pt (light)
//  Data   | Data   | Data
//  Data   | Data   | Data
//  ═══════════════════════  ← 底线 1.5pt（粗）/ Bottom rule 1.5pt (heavy)
//
// 表格语法（基于 tablem）/ Table syntax (powered by tablem):
// 使用 Markdown 风格的管道符语法：
// Uses Markdown-style pipe syntax:
//
//  | Header 1 | Header 2 | Header 3 |
//  | -------- | -------- | -------- |   ← 分隔行，必须存在 / Required separator row
//  | Cell 1   | Cell 2   | Cell 3   |
//
// 对齐控制 / Alignment control:
//  | :Left | :Center: | Right: |
//
// 单元格合并 / Cell merging:
//  | Span | <    |    ← < 向左合并 / < merges left
//  | A    | Span |
//  | ^    | B    |    ← ^ 向上合并 / ^ merges up
//
// 导出函数 / Exported Functions:
// - cap-table(): 三线表主函数（Three-line table main function）
// - tlt: cap-table 的国际化别名（International alias）
// - biaoge: cap-table 的中文拼音别名（Chinese alias）
//
// 依赖 / Dependencies:
// - @preview/tablem:0.3.0 — Markdown 表格解析
// - src/config.typ         — 全局配置和辅助函数
// - src/bicap.typ          — 标题内容生成引擎
//
// ============================================================

#import "@preview/tablem:0.3.0": tablem
#import "config.typ": *
#import "bicap.typ": _make_caption_content

/// 创建三线表，支持 Markdown 语法、双语标题、续表和自定义线条。
/// Create a three-line table with Markdown syntax, bilingual captions, continuation, and custom lines.
///
/// - columns (auto | int | array): 列配置 / Column config（推荐用法 / preferred）
/// - cols (auto | int | array): columns 的向后兼容别名 / Back-compat alias for columns
/// - align (auto | alignment | array | function): 单元格对齐（与 tablem 的 :---: 语法合并）/ Cell alignment
/// - size (auto | length): 表格内容字号 / Table content font size
/// - leading (auto | length): 表格内容行距 / Table content line spacing
/// - inset (auto | length | dictionary): 单元格内边距 / Cell padding
/// - caption (none | content): 主语言标题 / Main language caption
/// - caption-en (none | content): 英文标题 / English caption
/// - refer-to (none | label): 续表引用的原表标签 / Original label for continuation
/// - show-caption (auto | bool): 续表是否显示标题文本 / Show caption in continuation
/// - three-line-table (auto | bool): 是否使用三线表样式（默认 true；false 时跳过手动三线，使用 Typst 默认 table 边框）/ Three-line table mode
/// - top-rule (auto | stroke): 顶线粗细，接受任何 stroke 值（如 1.5pt + red）/ Top rule stroke
/// - middle-rule (auto | stroke): 中线粗细 / Middle rule stroke
/// - bottom-rule (auto | stroke): 底线粗细 / Bottom rule stroke
/// - breakable (auto | bool): 表格能否跨页（默认从全局读取，初始 true）/ Whether table may break across pages
/// - repeat-header (auto | bool | int): 跨页时重复表头行 / Repeat the markdown header row on page-break
/// - repeat-caption (auto | bool): 跨页时是否在每页表头之上重复题注（题注会进入 `table.header` 内）/ Repeat caption on every page
/// - hlines (array): 额外横线，每项为 `(row: int, start: int, end: none|int, stroke: stroke)` / Extra h-rules
/// - vlines (array): 额外竖线，每项为 `(col: int, start: int, end: none|int, stroke: stroke)` / Extra v-rules
/// - label (none | label): 表格标签，用于交叉引用 / Label for cross-reference
/// - ..extra-args: 任何其它命名参数（如 `fill`, `stroke`, `gutter`, `column-gutter`, `row-gutter`, `rows`）会
///   原样透传给底层 `table(...)`，与 `tablem` 的高级用法保持一致。
///   `stroke` 用户传值时会覆盖我们三线模式默认的 `stroke: none`（建议这种情况下同时设
///   `three-line-table: false`，否则三条手画 hline 会叠在用户 stroke 之上）。
///   Any other named args (e.g. `fill`, `stroke`, `gutter`, `column-gutter`, `row-gutter`, `rows`) are
///   passed through to the underlying `table(...)`, mirroring tablem's advanced-usage surface.
///   A user-provided `stroke` overrides the `stroke: none` we use in three-line mode (consider also
///   passing `three-line-table: false`, otherwise the three manual hlines stack on top of user stroke).
/// - content (content): Markdown 风格的表格内容 / Markdown-style table content
#let captab(
  columns: auto,
  cols: auto,        // 向后兼容别名 / back-compat alias for columns
  align: auto,       // 透传给 tablem 的对齐 / Forwarded to tablem
  size: auto,
  leading: auto,
  inset: auto,
  cell-inset: auto,  // ← inset 的别名（与全局 captab-style 的 cell-inset 命名一致）/ alias of inset
  caption: none,
  caption-en: none,
  refer-to: none,
  show-caption: auto,
  three-line-table: auto,
  top-rule: auto,
  middle-rule: auto,
  bottom-rule: auto,
  breakable: auto,
  repeat-header: auto,
  repeat-caption: auto,
  hlines: (),
  vlines: (),
  label: none,
  ..extra-args,        // 透传给底层 table() / Forwarded to underlying table()
  content
) = {
  // columns 优先；cols 作为兼容别名 / columns wins; cols is back-compat alias
  let columns = if columns != auto { columns } else { cols }

  // ..extra-args 只接受命名参数；位置参数应当通过 trailing content block 传入
  // ..extra-args only accepts named args; positional content goes via the trailing block
  assert(
    extra-args.pos().len() == 0,
    message: "captab: unexpected positional argument(s) — pass markdown content as the trailing block.",
  )

  context {
    // 读取全局配置状态（在 context 中才能读取）
    // Read global config state (only readable inside context)
    let percentage = table-width-config.get()
    let config = table-style-config.get()

    // 解析样式参数：优先使用传入值，否则使用全局配置
    // Resolve style params: prefer passed value, fall back to global config
    let final-size = if size == auto { config.body-size } else { size }
    let final-leading = if leading == auto { config.body-leading } else { leading }
    // 接受 inset 或 cell-inset；同时传入时 cell-inset 优先（与全局命名一致）
    // Accept either inset or cell-inset; cell-inset wins when both provided (matches global name)
    let user-inset = if cell-inset != auto { cell-inset } else { inset }
    let final-inset = if user-inset == auto { config.cell-inset } else { user-inset }
    let final-three-line-table = if three-line-table != auto { three-line-table } else { config.at("three-line-table", default: true) }
    let final-top-rule = if top-rule != auto { top-rule } else { config.at("top-rule", default: 1.5pt) }
    let final-middle-rule = if middle-rule != auto { middle-rule } else { config.at("middle-rule", default: 0.5pt) }
    let final-bottom-rule = if bottom-rule != auto { bottom-rule } else { config.at("bottom-rule", default: 1.5pt) }
    let final-breakable = if breakable != auto { breakable } else { config.at("breakable", default: true) }
    let final-repeat-header = if repeat-header != auto { repeat-header } else { config.at("repeat-header", default: true) }
    let final-repeat-caption = if repeat-caption != auto { repeat-caption } else { config.at("repeat-caption", default: false) }
    // repeat-caption 需要一个 label 以便续页通过 query(label) 找到原表的位置/编号。
    // 用户没传 label 时，自动合成一个唯一隐藏 label，仅用于 repeat-caption 内部检索。
    // repeat-caption needs a label so continuation pages can locate the original table via query(label).
    // If the user didn't supply one, auto-synthesise a hidden unique label for internal lookup only.
    let cap-in-header = (final-repeat-caption
                         and caption != none
                         and refer-to == none)
    // 用 counter("__captab-synth-id") 给每个 captab 调用分配一个唯一编号；
    // step 在下面以 content 形式发射出去（看 cap-in-header 块里的 emit 段落）。
    // counter assigns each captab call a unique id; step is emitted as content below.
    let synth-id = if cap-in-header and label == none {
      counter("__captab-synth-id").get().first()
    } else { 0 }
    let effective-label = if label != none {
      label
    } else if cap-in-header {
      std.label("__captab_repeat_" + str(synth-id))
    } else {
      none
    }

    // 解析文档语言和首行缩进修复标志 / Resolve language and indent-fix flag
    let (doc-lang, should-indent) = resolve-lang-indent(config)

    // ── 构建表格主体 ─────────────────────────────────────────────
    // ── Build table body ─────────────────────────────────────────
    let table-body = {
      let raw-table = {
        // 设置文本和段落样式（在 tablem 解析前设置，会应用到所有单元格）
        // Set text/paragraph style before tablem parsing (applies to all cells)
        set text(size: final-size)
        set par(leading: final-leading)

        // 把外层的 columns / align 闭包别名，避免与 tablem render 回调里同名形参发生遮蔽
        // 也避免 align 撞到 Typst 内建 align() 函数
        // Alias the outer params to avoid shadowing render's same-name params
        // and to keep `align` from clashing with Typst's builtin `align()` function.
        let user-columns = columns
        let user-align = align
        tablem(
          columns: user-columns,
          align: user-align,
          ..extra-args.named(),
          // tablem 的 render 回调：接收解析好的列数/对齐/单元格内容，
          // 由我们来决定如何渲染最终的 table
          // tablem's render callback: receives parsed columns/alignment/cells,
          // we decide how to render the final table
          render: (columns: auto, align: auto, ..args) => {
            // ── 处理列宽 ──────────────────────────────────────────
            // ── Handle column widths ──────────────────────────────
            let final-columns = if user-columns != auto {
              // 用户指定了 columns：直接使用（不管 tablem 解析到的列数）
              // User specified columns: use directly (ignore tablem-parsed column count)
              user-columns
            } else if type(columns) == int {
              // tablem 检测到 n 列（返回整数）：转换为 n 个等宽 fr 列
              // tablem detected n columns (returns int): convert to n equal-width fr columns
              (1fr,) * columns
            } else {
              // tablem 返回了列宽数组（来自 Markdown 对齐语法）：直接使用
              // tablem returned column width array (from Markdown alignment syntax): use directly
              columns
            }

            // ── 处理对齐 ──────────────────────────────────────────
            // ── Handle alignment ──────────────────────────────────
            // 默认强制 horizon（垂直居中），但要分辨用户传的 alignment 是否已经是 2D：
            // 1D `left` → 加 horizon → `left + horizon`；
            // 2D `left + bottom` → 已经指定了垂直方向，原样保留，*不再覆盖*。
            // Force horizon for vertical centering by default, but only if the user
            // hasn't already specified a vertical component (avoid the
            // "cannot add a vertical and a 2D alignment" error).
            let _ensure-horizon = a => {
              if a == auto {
                center + horizon
              } else if type(a) == alignment {
                if a.y == none { a + horizon } else { a }
              } else {
                a
              }
            }
            let final-align = if type(align) == array {
              align.map(_ensure-horizon)
            } else if type(align) == function {
              // 函数式 align：(col, row) => alignment，用 wrap 包一层补 horizon
              // Functional align: wrap to add horizon when missing
              (col, row) => _ensure-horizon(align(col, row))
            } else {
              _ensure-horizon(align)
            }

            // ── 解构 tablem 已经构造好的 table.header ─────────────────
            // ── Unpack the table.header tablem produced ───────────────
            // tablem 把表头行包成 table.header(...)，作为 args.pos() 的第一个元素，
            // 后面才是 body cells。我们读取它的 children，再重建一个带正确 repeat
            // 与可选题注行的 table.header。
            // tablem wraps the markdown header row in `table.header(...)` and passes
            // it as args.pos().first(); body cells follow. We extract its children
            // and rebuild a fresh table.header with the right repeat + optional caption row.
            let received = args.pos()
            let tablem-header-elem = if received.len() > 0 and received.first().func() == table.header {
              received.first()
            } else {
              none
            }
            let header-cells = if tablem-header-elem != none {
              tablem-header-elem.children
            } else {
              ()
            }
            let body-cells = if tablem-header-elem != none {
              received.slice(1)
            } else {
              received
            }
            let ncols = if type(final-columns) == array {
              final-columns.len()
            } else if type(final-columns) == int {
              final-columns
            } else if header-cells.len() > 0 {
              header-cells.len()
            } else {
              1  // 兜底 / fallback
            }

            // ── 构建 table.header（用于跨页重复）─────────────────────
            // ── Build table.header (for cross-page repetition) ────────
            // 我们 *始终* 用自己的 table.header 替换 tablem 默认产出的版本，
            // 这样 repeat-header: false 才能真正关掉重复（tablem 默认 repeat=auto≈true）。
            // We *always* replace tablem's default table.header with our own,
            // so that repeat-header: false actually disables repetition (tablem defaults to auto≈true).
            let cap-row-count = if cap-in-header { 1 } else { 0 }

            // 跨页时显示的"续表 X.Y caption"内容：仅在续页（here().page() 不等于
            // 表起始页）时通过 _make_caption_content 走 refer-to 分支生成；这样
            // 不会重复登记 figure，编号也通过 query(label) 锁定到第一页。
            // 把 caption-above/-below 间距放进内容里（而不是 cell inset），这样
            // 第一页空 cell 不会撑出多余空白。
            // Continuation caption shown on each subsequent page: rendered via the
            // refer-to branch of _make_caption_content (no figure registration). The
            // table number is anchored to the main table via query(label).
            // The caption-above/-below spacing is baked into the content (rather than
            // the cell inset) so the empty cell on page 1 stays collapsed.
            let cap-cell-content = if cap-in-header {
              context {
                let originals = query(effective-label)
                if originals.len() > 0 {
                  let start-page = originals.first().location().page()
                  let cur-page = here().page()
                  if cur-page != start-page {
                    v(config.caption-above)
                    _make_caption_content(
                      caption: caption,
                      caption-en: caption-en,
                      refer-to: effective-label,
                      label: none,
                      config: config,
                      kind: "table",
                      show-caption: true,
                    )
                    v(config.caption-below)
                  }
                  // else: 第一页，外层标题块已渲染原标题，本 cell 留空 / page 1 stays empty
                }
              }
            } else { none }

            // ── 构建表格内容列表 ───────────────────────────────────
            // ── Build table content list ───────────────────────────
            let table-content = ()

            // 顶线 / 中线 y 索引随 cap-in-header 上移一行（caption 行无顶线，看起来像题注）
            // Shift top/middle hline y indices down if caption row is included in header
            let top-hline-y = cap-row-count
            let middle-hline-y = cap-row-count + 1

            // 三线表模式才手动加顶/中/底线；非三线表模式让 Typst 用默认 table 边框
            // Only add manual top/middle/bottom rules in three-line mode;
            // otherwise rely on Typst's default table stroke.
            if final-three-line-table {
              // 顶线（在表头行上方；若有 caption 行，caption 在顶线之上无 stroke 看起来像题注）
              // Top rule above header row; caption row (if any) sits above without strokes
              table-content.push(table.hline(y: top-hline-y, stroke: final-top-rule))
              // 中线（表头行下方）/ Middle rule (below header row)
              table-content.push(table.hline(y: middle-hline-y, stroke: final-middle-rule))
            }

            // ── repeat-caption 模式下，把 caption 行单独放在一个外层 table.header
            // 里（level: 1, repeat: true），这样它能跨页重复，跟 markdown header 行
            // 是否重复（level: 2, repeat: final-repeat-header）解耦。
            // For repeat-caption mode the caption row lives in its own table.header
            // (level 1, repeat: true) so it always repeats independently of whether
            // the markdown header row (level 2, repeat: final-repeat-header) repeats.
            if cap-in-header {
              table-content.push(
                table.header(
                  level: 1,
                  repeat: true,
                  table.cell(
                    colspan: ncols,
                    stroke: none,
                    align: center,
                    inset: (x: 0pt, y: 0pt),
                    cap-cell-content,
                  )
                )
              )
            }

            if header-cells.len() > 0 {
              // 始终重建 markdown 表头 header，保证 repeat-header: false 能真正关掉重复
              // Always rebuild the markdown header so repeat-header: false really disables repetition
              table-content.push(
                table.header(
                  level: if cap-in-header { 2 } else { 1 },
                  repeat: final-repeat-header,
                  ..header-cells
                )
              )
              table-content += body-cells
            } else {
              // 没有 header（可能是空表）；直接展开所有内容
              // No header (possibly empty table); spread all received content
              table-content += received
            }

            // ── 添加用户自定义额外横线 ─────────────────────────────
            // ── Add user-defined extra horizontal lines ─────────────
            for line in hlines {
              let y = line.at("row", default: 2)         // 默认第2行上方 / default: above row 2
              let start = line.at("start", default: 0)   // 默认从第0列开始 / default: from col 0
              let end = line.at("end", default: none)     // 默认到最右列 / default: to rightmost
              let stroke-style = line.at("stroke", default: 0.5pt)
              table-content.push(
                table.hline(y: y, start: start, end: end, stroke: stroke-style)
              )
            }

            // ── 添加用户自定义额外竖线 ─────────────────────────────
            // ── Add user-defined extra vertical lines ───────────────
            for line in vlines {
              let x = line.at("col", default: 1)         // 默认第1列右侧 / default: right of col 1
              let start = line.at("start", default: 0)
              let end = line.at("end", default: none)
              let stroke-style = line.at("stroke", default: 0.5pt)
              table-content.push(
                table.vline(x: x, start: start, end: end, stroke: stroke-style)
              )
            }

            // 底线（默认 1.5pt 粗；可由 bottom-rule / 全局配置覆盖；非三线表模式跳过）
            // Bottom rule (default 1.5pt; overridable; skipped when not in three-line mode)
            if final-three-line-table {
              table-content.push(table.hline(stroke: final-bottom-rule))
            }

            // ── 处理 inset（单元格内边距）─────────────────────────
            // ── Process inset (cell padding) ───────────────────────
            // inset 可以是字典（{x: ..., y: ...}）或标量（统一应用）
            // inset can be a dict ({x: ..., y: ...}) or scalar (uniform)
            let final-table-inset = if type(final-inset) == dictionary {
              final-inset
            } else {
              // 标量转换为 x/y 字典
              // Convert scalar to x/y dict
              (x: final-inset, y: final-inset)
            }

            // 三线表模式下显式 stroke: none（线条由上面手动添加）；
            // 非三线表模式下不传 stroke，由 Typst / 现有 set rule 决定默认网格描边。
            // 用户通过 ..extra-args 显式传 stroke / fill / gutter 等会覆盖我们的默认。
            // In three-line mode explicitly stroke: none (we draw the rules manually);
            // otherwise omit the stroke arg so Typst's set rules / defaults apply.
            // User-provided stroke / fill / gutter / etc. via ..extra-args override our defaults.
            let stroke-args = if final-three-line-table { (stroke: none) } else { (:) }
            table(
              columns: final-columns,
              ..stroke-args,
              align: final-align,
              inset: final-table-inset,
              ..args.named(),           // 透传用户高级参数（fill/stroke/gutter 等）/ Pass-through user advanced args
              ..table-content           // 展开所有内容（线条+单元格）/ Spread all content
            )
          },
          content
        )
      }

      // ── 应用表格宽度百分比 ────────────────────────────────────
      // ── Apply table width percentage ─────────────────────────
      // 通过在左右添加等量 padding 来实现居中缩窄效果
      // Centering + narrowing achieved by adding equal padding on both sides
      let margin-percent = (100 - percentage) / 2
      pad(
        left: margin-percent * 1%,
        right: margin-percent * 1%,
        block(
          width: 100%,
          std.align(center, raw-table)
        )
      )
    }

    // ── 组合标题和表体 ────────────────────────────────────────────
    // ── Combine caption and table body ───────────────────────────
    //
    // 三种情况：
    // Three cases:
    // 1. 有标题 + 续表（refer-to 非 none）
    //    Has caption + continuation
    // 2. 有标题 + 主表（refer-to 为 none）
    //    Has caption + main table
    // 3. 无标题（只有表体）
    //    No caption (table body only)
    //
    // 标题和表体放在同一个不换页 block 中，防止跨页分离
    // Caption and body are in the same non-breakable block to prevent page splits

    // 如果用了 cap-in-header 且我们合成了 label，需要把 synth-id 计数器推进 1，
    // 让下一个用同样路径的 captab 拿到不同的合成 id。
    // If cap-in-header used a synthesised label, step the synth counter so the
    // next captab call gets a fresh id.
    if cap-in-header and label == none {
      counter("__captab-synth-id").step()
    }

    if caption != none {
      // 续表不设置标签（避免重复引用），主表才设置 label
      // Continuation gets no label (avoid duplicate refs); main table gets the label
      let is-continuation = refer-to != none

      // 标准/repeat-caption 模式都走这一段：外层 block 渲染原标题在表格上方一次，
      // 跨页时由 table.header 内的 cap-cell-content 在续页上重复输出（refer-to 形式）。
      // Both standard mode and repeat-caption mode share this branch: the outer
      // block renders the caption once above the table; on continuation pages the
      // table.header cell rendered the refer-to-style caption.
      block(
        breakable: final-breakable,
        above: config.caption-above,
        below: config.table-below,
      )[
        #std.align(center)[
          #_make_caption_content(
            caption: caption,
            caption-en: caption-en,
            refer-to: refer-to,
            label: if is-continuation { none } else { effective-label },
            config: config,
            kind: "table",
            show-caption: show-caption,
          )
        ]
        // 标题与表体之间的间距；减去 1em 是因为 block 的 below 已贡献默认段距
        // Gap between caption and body; subtract 1em because block below contributes default paragraph spacing
        #v(config.caption-below - 1em)
        #table-body
      ]
      if should-indent { _fakepar }
    } else {
      // ─ 无标题：直接输出表体 ─ (No caption: output table body only)
      table-body
      if should-indent { _fakepar }
    }
  }
}

