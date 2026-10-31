<h1 align="start">Breakify</h1>

<p align="start">
  <strong>A responsive layout toolkit for Flutter.</strong>
</p>

<p align="start">
  Build responsive interfaces using breakpoints, responsive values,
  fluid interpolation, and adaptive widgets.
</p>

<p align="center">
  <a href="https://pub.dev/packages/breakify">
    <img src="https://img.shields.io/pub/v/breakify.svg" alt="Pub Version">
  </a>
  <a href="https://github.com/josueSerna/breakify">
    <img src="https://img.shields.io/github/stars/josueSerna/breakify?style=social" alt="GitHub Stars">
  </a>
  <a href="https://pub.dev/packages/breakify">
    <img src="https://img.shields.io/pub/likes/breakify" alt="Pub Likes">
  </a>
  <a href="https://pub.dev/packages/breakify">
    <img src="https://img.shields.io/pub/points/breakify" alt="Pub Points">
  </a>
  <a href="https://github.com/josueSerna/breakify/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT">
  </a>
  <img src="https://img.shields.io/badge/flutter-%3E%3D3.27.0-02569B?logo=flutter" alt="Flutter SDK">
</p>

<p align="center">
  <img src="assets/brix_with_breakify_logo.png" width="400" alt="Breakify">
</p>

<p align="center">
    <img src="assets/breakify.gif" width="600" alt="Breakify live resize demo">
  </p>


---

## Table of Contents

- [Latest Important Updates](#latest-important-updates)
- [What is Breakify?](#what-is-breakify)
- [Why Breakify?](#why-breakify)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Default Breakpoints](#default-breakpoints)
- [Responsive Values](#responsive-values)
- [Fluid Values](#fluid-values)
- [BuildContext Extensions](#buildcontext-extensions)
- [Widgets](#widgets)
  - [BreakifyAdaptativeLayout](#breakifyadaptativelayout)
  - [BreakifyGrid](#breakifygrid)
  - [BreakifyResponsiveGrid](#breakifyresponsivegrid)
  - [BreakifyPanelLayout](#breakifypanellayout)
  - [BreakifyListView](#breakifylistview)
  - [BreakifyContainer](#breakifycontainer)
  - [BreakifySection (experimental)](#breakifysection-experimental)
  - [BreakifyNavbar (experimental)](#breakifynavbar-experimental)
  - [BreakifyVisibility](#breakifyvisibility)
  - [BreakifyBuilder](#breakifybuilder)
  - [BreakifyDebugBanner](#breakifydebugbanner)
- [Responsive Preview](#responsive-preview)
- [Example App](#example-app)
- [Contributing](#contributing)
- [License](#license)
- [Author](#author)

---

## Latest Important Updates

### `heightMode` replaces `equalHeight` in `BreakifyGrid` and `BreakifyResponsiveGrid`

> **Breaking change.** The `equalHeight` boolean no longer exists. It is
> replaced by `heightMode`, a nullable `BreakifyHeightMode` enum that lets you
> choose *how* item heights are calculated.

| `heightMode` | Behavior | `Spacer` / `Expanded` | Loading |
|---|---|---|---|
| `null` (default) | Items are sized from `childAspectRatio` | n/a | Lazy |
| `BreakifyHeightMode.equal` | Every item has exactly the same height: the tallest item of the whole grid | Supported | Rows are measured once and cached; only visible rows stay alive |
| `BreakifyHeightMode.equalInRow` | Every item in a row has the height of that row's tallest item. Rows can differ from each other | Supported | Lazy |
| `BreakifyHeightMode.natural` | Every item keeps its natural height, aligned to the top of its row | Not supported (unbounded height) | Lazy |

When `heightMode` is not `null`, `childAspectRatio` is ignored and heights come
from the content. It currently only supports `Axis.vertical` in
`BreakifyGrid`, and children must support intrinsic measurement (widgets such
as `LayoutBuilder` are not supported).

**Migration**

```dart
// Before
BreakifyGrid(
  columns: const BreakifyValue(sm: 1, md: 2, lg: 3),
  equalHeight: true,
  children: cards,
)

// After (same behavior as the old `equalHeight: true`)
BreakifyGrid(
  columns: const BreakifyValue(sm: 1, md: 2, lg: 3),
  heightMode: BreakifyHeightMode.equalInRow,
  children: cards,
)
```

`equalHeight: false` becomes `heightMode: null` (or simply omit it).

**Choosing a mode**

* Use `equalInRow` for long or scrollable lists: it is lazy and cheap.
* Use `equal` when every card must look identical across rows. Its first
  layout and every width change measure all cards, so prefer it for up to a
  few hundred items.
* Use `natural` when cards should keep their own size. Do not put `Spacer` or
  `Expanded` inside their `Column`; use `mainAxisSize: MainAxisSize.min`.

`BreakifyHeightMode` is exported from `package:breakify/breakify.dart`. See
the [CHANGELOG](CHANGELOG.md) for details.

---

## What is Breakify?

Breakify is a lightweight responsive layout toolkit for Flutter designed to make responsive UI easier to build and maintain.

Instead of repeatedly checking screen dimensions throughout your widgets:

```dart
if (MediaQuery.sizeOf(context).width >= 1024) {
  // ...
}
```

Breakify lets you describe **how a value or layout should behave** across screen sizes, and takes care of resolving it for you.

---

## Why Breakify?

Without Breakify, responsive layouts often require manually checking screen sizes throughout your widgets:

```dart
if (MediaQuery.sizeOf(context).width >= 1024) {
  ...
}
```

or reaching for a `LayoutBuilder` every time:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    // ...
  },
)
```

With Breakify, the same logic becomes declarative:

```dart
BreakifyAdaptativeLayout(
  breakpoint: BreakifyBreakpoint.lg,
  spacing: const BreakifyFluidValue(
    sm: 12,
    lg: 24,
  ),
  children: [
    LeftPanel(),
    RightPanel(),
  ],
)
```

| Without Breakify | With Breakify |
|---|---|
| Screen-size checks scattered across widgets | Responsive logic centralized in one value |
| Manual `LayoutBuilder` boilerplate per widget | Built-in adaptive widgets |
| Hard breakpoint jumps | Optional fluid interpolation |
| Easy to forget a breakpoint case | Automatic fallback to the nearest defined value |

The responsive logic stays centralized, making your widgets easier to read, maintain, and reuse.

---

## Features

* Responsive breakpoints
* Fluid values with smooth interpolation
* Adaptive row/column layouts
* Responsive containers
* Responsive grids, including explicit and automatic column layouts
* Horizontal grids and equal-height rows
* Responsive list views (vertical and horizontal)
* Main-and-secondary panel layouts
* Experimental page sections (`BreakifySection`)
* Experimental responsive navbar (`BreakifyNavbar`)
* Conditional visibility by breakpoint, globally or locally
* Development breakpoint banner with configurable position

---

## Requirements

* Dart SDK `>=3.0.0`
* Flutter SDK `>=3.27.0`

---

## Installation

Add Breakify to your `pubspec.yaml`.

```yaml
dependencies:
  breakify: ^0.3.0
```

Then import the package.

```dart
import 'package:breakify/breakify.dart';
```

---

## Quick Start

Wrap your application with `BreakifyScope`.

```dart
void main() {
  runApp(
    BreakifyScope(
      child: MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}
```

This makes responsive information available throughout the widget tree.

---

## Default Breakpoints

Breakify includes five responsive breakpoints by default.

| Breakpoint | Minimum width |
| ---------- | ------------: |
| sm         |           640 |
| md         |           768 |
| lg         |          1024 |
| xl         |          1280 |
| xxl        |          1536 |

You can also define your own breakpoint configuration to adapt layouts to the needs of your project.

```dart
const breakpoints = BreakifyBreakpoints(
  sm: 500,
  md: 700,
  lg: 900,
  xl: 1200,
  xxl: 1600,
);
```

```dart
BreakifyScope(
  breakpoints: breakpoints,
  child: MyApp(),
)
```

> **Note:** every breakpoint width shown in this README — including the
> [Responsive Preview](#responsive-preview) below — uses these defaults.
> Since breakpoints are fully customizable, your own app may switch
> layouts at different widths.

Each breakpoint becomes active at its configured minimum width, including the
exact threshold. For example, with `xl: 1400`, `xl` resolves from 1400 pixels.

---

## Responsive Values

Instead of manually checking the screen width, define how a value should behave.

```dart
const columns = BreakifyValue(
  sm: 1,
  md: 2,
  lg: 4,
);

final value = context.resolve(columns);
```

Missing breakpoints automatically inherit the nearest previous value.

For example:

| Breakpoint | Value |
| ---------- | ----: |
| sm         |     1 |
| md         |     2 |
| lg         |     4 |
| xl         |     4 |
| xxl        |     4 |

`BreakifyValue` is generic, so it can resolve values such as `int`, `double`,
`EdgeInsets`, or other types used by responsive widgets. The `sm` value is
required; higher breakpoints inherit the closest value defined before them.

---

## Fluid Values

Need values to scale smoothly instead of changing abruptly?

Use `BreakifyFluidValue`.

```dart
const spacing = BreakifyFluidValue(
  sm: 8,
  md: 16,
  lg: 24,
);

Container(
  padding: EdgeInsets.all(
    context.resolve(spacing),
  ),
)
```

Instead of jumping from one value to another, Breakify interpolates between breakpoints.

Interpolation is linear between each pair of defined breakpoint values. Values
before the first defined point use the first value, and values after the last
defined point use the last value. If a different breakpoint configuration is
needed for one fluid value, use `overrideBreakpoints`. Use
`resolveRounded` when the interpolated result should be rounded to the nearest
logical pixel.

---

## BuildContext Extensions

Breakify provides useful extensions for accessing responsive information.

```dart
context.breakpoint
```

Returns the current breakpoint.

For widgets using `BreakifyScope`, this is the breakpoint resolved from the
scope's width. Widgets that use `BreakifyBuilder` resolve their breakpoint from
the width in their local `BoxConstraints`.

```dart
context.breakifyWidth
```

Returns the current width.

```dart
context.resolve(value)
```

Resolves any `BreakifyResolvable`.

---

## Widgets

### BreakifyAdaptativeLayout

Automatically switches between a `Column` and a `Row`.

```dart
BreakifyAdaptativeLayout(
  breakpoint: BreakifyBreakpoint.lg,
  spacing: const BreakifyValue(
    sm: 12,
    lg: 24,
  ),
  children: [
    Sidebar(),
    Content(),
  ],
)
```

`distributeEvenly` controls whether horizontal children use `Expanded`
(`true`) or `Flexible` (`false`). `stretchChildren` applies
`CrossAxisAlignment.stretch` to the vertical layout. Spacing can be a
`BreakifyValue` or a `BreakifyFluidValue`.

#### Custom distributions with `order`

`order` is optional. Without it, the layout behaves exactly as shown above.
When set, `layoutBelow` is used below `breakpoint` and `layoutAbove` from
`breakpoint` onward.

```dart
BreakifyAdaptativeLayout(
  breakpoint: BreakifyBreakpoint.lg,
  spacing: const BreakifyFluidValue(sm: 12, lg: 24),
  children: [Title(), Description(), Image()],
  order: const BreakifyLayoutOrder(
    layoutBelow: BreakifyLayoutTemplate.twoRows,
    layoutAbove: BreakifyLayoutTemplate.twoColumns,
  ),
)
```

| Template | Result |
|---|---|
| `inRow` | All children in one row. |
| `inColumn` | All children in one column. |
| `twoRows` | Two rows, one below the other. |
| `twoColumns` | Two columns, side by side. |
| `custom(left:, right:)` | Two columns with explicit children. |

For `twoRows` and `twoColumns`, the first `ceil(n / 2)` children go in the
first group (top row / left column) and the rest in the second. With three
children: `[0, 1]` and `[2]`.

With `custom`, the indices refer to positions in the original `children`
list (`0` = `Title()`, `1` = `Description()`, `2` = `Image()`):

```dart
order: const BreakifyLayoutOrder(
  layoutBelow: BreakifyLayoutTemplate.inColumn,
  layoutAbove: BreakifyLayoutTemplate.custom(
    left: [0, 1],
    right: [2],
  ),
),
```

Every child must appear exactly once and neither list may be empty;
otherwise an error is thrown in debug mode. Groups are not height-equalized:
a child alone in a group (such as an image) keeps its own height unless it
sizes itself.

---

### BreakifyGrid

Responsive grid with configurable columns, spacing, and aspect ratio.

```dart
BreakifyGrid(
  columns: const BreakifyValue(
    sm: 2,
    md: 3,
    lg: 4,
  ),
  spacing: const BreakifyFluidValue(
    sm: 8,
    lg: 20,
  ),
  children: products,
)
```

`columns`, `spacing`, `crossAxisSpacing`, `mainAxisSpacing`, and
`childAspectRatio` support responsive values. When both `spacing` and an axis
specific spacing are provided, the axis-specific value takes precedence.
`padding`, `physics`, `shrinkWrap`, and `scrollDirection` are forwarded to the
underlying scrollable grid.

It also supports:

* **Horizontal scrolling** — set `scrollDirection: Axis.horizontal` to
  scroll sideways instead of vertically. In this mode, `columns` controls
  the number of rows instead of columns, and `childAspectRatio` is still
  expressed as width / height.
* **Height modes** — set `heightMode` (a `BreakifyHeightMode`) to size items
  from their content instead of `childAspectRatio`, which is then ignored.
  * `BreakifyHeightMode.equal`: every item has the same height (the tallest
    of the whole grid).
  * `BreakifyHeightMode.equalInRow`: items in each row match that row's
    tallest item; rows may differ.
  * `BreakifyHeightMode.natural`: each item keeps its own height.

  Heights are measured once, so `Spacer` and `Expanded` inside a `Column`
  work (except with `natural`). Children must support intrinsic measurement
  (`LayoutBuilder` is not supported). Currently only supported with
  `Axis.vertical`. See [Latest Important Updates](#latest-important-updates).

```dart
BreakifyGrid(
  columns: const BreakifyValue(sm: 1, md: 2, lg: 3),
  scrollDirection: Axis.horizontal,
  spacing: const BreakifyFluidValue(sm: 8, lg: 20),
  children: cards,
)
```

### BreakifyResponsiveGrid

Automatically calculates how many columns fit while keeping a minimum item
width.

```dart
BreakifyResponsiveGrid(
  minItemWidth: 240,
  maxColumns: 4,
  spacing: 16,
  children: products,
)
```

Unlike `BreakifyGrid`, which uses an explicit responsive column count,
`BreakifyResponsiveGrid` calculates the column count from the local width
provided by its parent. `minItemWidth` is the minimum desired width for each
item, `maxColumns` optionally caps the calculated count, and `spacing` is
included in the calculation between columns.

When the parent provides an unbounded width, the grid uses `minItemWidth` as
its finite fallback width.

The column count is calculated from the available width after horizontal
padding and the space required between items. `maxColumns` caps the result,
while at least one column is always used. Unlike `BreakifyGrid`, this widget
does not require a value for each breakpoint and responds to the local width
provided by its parent.

Set `heightMode` (`BreakifyHeightMode.equal`, `equalInRow` or `natural`) to
size items from their content. It is opt-in (`null` by default) and ignores
`childAspectRatio`. See [Latest Important Updates](#latest-important-updates)
for the behavior of each mode.

```dart
BreakifyResponsiveGrid(
  minItemWidth: 220,
  maxColumns: 3,
  spacing: 16,
  heightMode: BreakifyHeightMode.equalInRow,
  children: [
    Card(child: Text('Short content')),
    Card(child: Text('Content that needs more vertical space.')),
  ],
)
```

---

### BreakifyPanelLayout

Places a main panel beside a vertical stack of secondary panels from the
selected breakpoint onward.

```dart
BreakifyPanelLayout(
  breakpoint: BreakifyBreakpoint.lg,
  spacing: const BreakifyFluidValue(sm: 12, lg: 24),
  mainPanel: MainContent(),
  secondaryPanels: [
    SummaryCard(),
    ActionsCard(),
  ],
)
```

Below the breakpoint, all panels are arranged vertically. At the breakpoint,
the main panel and the secondary panel column are arranged horizontally.

`mainFlex` and `secondaryFlex` control the horizontal width ratio. If
`secondaryPanels` is empty, the layout remains vertical. The breakpoint is
resolved from the layout's available local width, so padding or parent
constraints can make it differ from the global screen breakpoint.

#### `reverse` and `secondaryDirection`

Both only affect the horizontal layout (vertical mode is unchanged).

```dart
BreakifyPanelLayout(
  breakpoint: BreakifyBreakpoint.lg,
  spacing: const BreakifyFluidValue(sm: 12, lg: 24),
  reverse: true,
  secondaryDirection: Axis.horizontal,
  mainPanel: MainContent(),
  secondaryPanels: [SummaryCard(), ActionsCard()],
)
```

- `reverse` (default `false`): with `true`, the secondary panels go on the
  left and the main panel on the right. The order of `secondaryPanels` is
  kept, and `mainFlex` / `secondaryFlex` still apply to their own area.
- `secondaryDirection` (default `Axis.vertical`): with `Axis.horizontal`,
  the secondary panels are placed in a `Row`, each with an equal share of the
  width and separated by `spacing`. In that `Row`,
  `CrossAxisAlignment.stretch` is applied as `start` because its height is
  unbounded.

---

### BreakifyListView

Responsive list with configurable spacing and separators.

```dart
BreakifyListView(
  spacing: const BreakifyValue(
    sm: 8,
    lg: 16,
  ),
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index]),
    );
  },
)
```

Supports a custom `separator` widget (replacing the default spacing) and
`scrollDirection: Axis.horizontal` for horizontal lists.

When `separator` is provided, it replaces the responsive spacing between
items. Use `shrinkWrap` and appropriate scroll physics when placing the list
inside another scrollable widget. Horizontal spacing is applied along the
horizontal axis.

---

### BreakifyContainer

Centers content while limiting its maximum width.

```dart
BreakifyContainer(
  maxWidth: const BreakifyValue(
    sm: 1200,
  ),
  child: content,
)
```

`maxWidth` and `padding` support `BreakifyValue` and `BreakifyFluidValue`.
`margin` and `alignment` use Flutter's regular layout types.

---

### BreakifySection (experimental)

> **Experimental in 0.3.0:** its API may change in future releases.

A full-width section for web pages and landing pages. It supports a
background, alignment, responsive `padding` and `minHeight`, and
`fullViewport`. Set `childScale` to visually enlarge or shrink its child
without changing the space reserved for it; this can help scale a footer logo.
The section does not clip scaled overflow, though an ancestor may do so.

```dart
BreakifySection(
  backgroundColor: Colors.indigo.shade50,
  minHeight: const BreakifyValue(sm: 130),
  childScale: 2,
  alignment: Alignment.centerRight,
  padding: const BreakifyValue<EdgeInsetsGeometry>(
    sm: EdgeInsets.all(16),
    lg: EdgeInsets.symmetric(horizontal: 96, vertical: 48),
  ),
  child: const FlutterLogo(size: 64),
)
```

`padding` and `minHeight` support `BreakifyValue` and `BreakifyFluidValue`.
With `fullViewport: true` the minimum height is the viewport height
(`MediaQuery.sizeOf(context).height`); if `minHeight` is also set, the larger
value is used. The section grows when its content needs more room and does not
scroll on its own, so place it inside a `ListView` or `SingleChildScrollView`.
Requires a `BreakifyScope`.

---

### BreakifyNavbar (experimental)

> **Experimental in 0.3.0:** its API may change in future releases.

A responsive navbar. From the `breakpoint` up (default `md`) the items are
laid out horizontally; below it, a hamburger button opens a `dropdown` or a
`drawer` menu.

```dart
BreakifyNavbar(
  logo: Image.asset('assets/logo.png', height: 32),
  items: [
    BreakifyNavbarItem(label: 'Home', icon: Icons.home, onTap: () {}),
    BreakifyNavbarItem(label: 'Services', icon: Icons.work, onTap: () {}),
    BreakifyNavbarItem(label: 'Contact', onTap: () {}, enabled: false),
  ],
  menuType: BreakifyNavbarMenuType.drawer,
  drawerSide: BreakifyNavbarDrawerSide.right,
  scrollBehavior: BreakifyNavbarScrollBehavior.hideOnScroll,
  body: ListView(children: [/* page content */]),
)
```

- `menuType`: `dropdown` (expands below the navbar) or `drawer` (side panel
  over the content; closes by tapping outside, with the close icon, or by
  selecting an item).
- `scrollBehavior`: `fixed` (always visible, default), `static` (scrolls away
  with the content) or `hideOnScroll` (hides when scrolling down, returns when
  scrolling up; `scrollThreshold` sets the sensitivity).
- Also configurable: `logo`, `menuIcon`, `closeIcon`, `backgroundColor`,
  `foregroundColor`, `menuBackgroundColor`, `height`, `padding`,
  `itemSpacing`, `drawerWidth`, `drawerOverlayColor`, `animationDuration`
  and `elevation`.
- `logoMaxHeight` (default 80): the logo is no longer squeezed into the bar
  `height`; it can grow up to this value, centered, and paints beyond the bar
  edges (not clipped) if it is taller than `height`.

Known limitations:

- Requires a `BreakifyScope` and a Material ancestor.
- It wraps the page content in `body`. It listens to the scroll
  notifications of `body` and never uses a `ScrollController`.
- With `fixed` and `hideOnScroll` the body is placed below the navbar. With
  `static` the navbar overlays the body, which must apply the top padding
  (`MediaQuery.paddingOf(context).top`) if it uses a custom `padding`,
  `SingleChildScrollView` or `CustomScrollView`.
- `static` and `hideOnScroll` need a vertical scrollable as the top-level
  scrollable of `body`.
- Desktop items do not scroll: too many items overflow.
- The Android back button does not close the mobile menu.

---

### BreakifyVisibility

Show or hide widgets depending on the current breakpoint.

```dart
BreakifyVisibility(
  minBreakpoint: BreakifyBreakpoint.lg,
  child: Sidebar(),
)
```

Or show only on specific breakpoints.

```dart
BreakifyVisibility.only(
  visibleIn: {
    BreakifyBreakpoint.sm,
    BreakifyBreakpoint.xl,
  },
  child: Logo(),
)
```

Use `mode: BreakifyVisibilityMode.local` to resolve visibility from the
width available to the widget instead of the global `BreakifyScope` width.

The default mode is `BreakifyVisibilityMode.global`. Use `minBreakpoint` to
show a child from a breakpoint upward, `maxBreakpoint` to show it up to a
breakpoint, or combine both to define an inclusive range. `replacement` is
rendered while the child is hidden; if it is omitted, the widget uses an
empty `SizedBox`.

```dart
BreakifyVisibility(
  minBreakpoint: BreakifyBreakpoint.lg,
  mode: BreakifyVisibilityMode.local,
  replacement: MobileMenu(),
  child: DesktopSidebar(),
)
```

`global` uses the width exposed by `BreakifyScope`; `local` uses the finite
width available where the widget is placed. If the local width is unbounded,
it falls back to the global width.

---

### BreakifyBuilder

Build widgets based on the current breakpoint.

```dart
BreakifyBuilder(
  builder: (context, breakpoint, constraints) {
    return Text(
      breakpoint.name,
    );
  },
)
```

The builder receives the current `BuildContext`, the resolved
`BreakifyBreakpoint`, and the local `BoxConstraints`. It is useful when a
layout needs custom behavior that is not covered by the built-in widgets.

---

### BreakifyDebugBanner

Displays the current breakpoint during development.

```dart
BreakifyDebugBanner(
  child: MyApp(),
)
```

Use `enabled` to hide the banner without removing it from the tree,
`corner` to select one of the four screen corners, and `breakpoints` to use a
custom configuration. This widget is intended for development and should
usually be disabled in production.

The banner resolves its breakpoint from its local width. When placed inside a
constrained container, it shows that container's breakpoint instead of the
global screen breakpoint. If the local width is unbounded, it falls back to
the width provided by `BreakifyScope`.

In the example app, the banner added through `MaterialApp.builder` represents
the global route/window view and appears on every example screen. The home
screen also includes a banner inside a constrained 720 px container so you
can compare the global and local breakpoints while resizing the window.

```dart
BreakifyDebugBanner(
  enabled: true,
  corner: BreakifyBannerCorner.bottomLeft,
  child: MyApp(),
)
```

---

## Responsive Preview

The screenshots below were captured from the app in [`/example`](example),
resized across each breakpoint.

> These previews use Breakify's **default** breakpoint widths (see the
> [Default Breakpoints](#default-breakpoints) table above). Breakpoints are
> fully customizable via `BreakifyBreakpoints`, so an app using custom
> values will switch layouts at different widths — the *behavior* shown
> here (how many columns, how the layout adapts) is what stays consistent,
> not the exact pixel value.

<table align="center">
  <tr>
    <td align="center">
      <img src="assets/breakpoint_sm.jpg" width="160" alt="sm breakpoint preview"><br>
      <sub><b>sm</b> · phone</sub>
    </td>
    <td align="center">
      <img src="assets/breakpoint_md.jpg" width="160" alt="md breakpoint preview"><br>
      <sub><b>md</b> · large phone / small tablet</sub>
    </td>
    <td align="center">
      <img src="assets/breakpoint_lg.jpg" width="160" alt="lg breakpoint preview"><br>
      <sub><b>lg</b> · tablet / small laptop</sub>
    </td>
    <td align="center">
      <img src="assets/breakpoint_xl.jpg" width="160" alt="xl breakpoint preview"><br>
      <sub><b>xl</b> · laptop / desktop</sub>
    </td>
    <td align="center">
      <img src="assets/breakpoint_xxl.jpg" width="160" alt="xxl breakpoint preview"><br>
      <sub><b>xxl</b> · large desktop</sub>
    </td>
  </tr>
</table>

<!--
  How to regenerate these screenshots:
  1. Run the example app: flutter run -d chrome
  2. Resize the browser window to each default breakpoint width
     (640, 768, 1024, 1280, 1536) — or a representative width just
     above each one.
  3. Capture a screenshot and save it as assets/preview_<breakpoint>.png
-->

---

## Example App

A complete example application is available in the [`example`](example) folder.

Run the example on Flutter Web:

```bash
flutter run -d chrome
```

Or run it on any connected device (Android, iOS, desktop, or the default emulator):

```bash
flutter run
```

---

## License

This project is licensed under the MIT License.

## Author

Developed and maintained by Josue Serna Muñoz.

GitHub: https://github.com/josueSerna