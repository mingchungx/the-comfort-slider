# The Comfort Slider — Design Guidelines

The design language for this app. It should feel **native, playful, and a little
sexy** — Liquid Glass surfaces floating over a living, warm background, with money
that reacts when you touch it. When adding UI, match these conventions rather than
inventing new ones.

Target: **iOS 26+** (Liquid Glass, Metal stitchable shaders, glass button styles).

---

## 1. Surfaces — Liquid Glass

- **Every section is a glass card.** Use the shared `GlassCard`, which applies
  `.glassEffect(.regular, in: .rect(cornerRadius: 28))` with default padding. Do
  not roll your own translucent backgrounds.
- **Wrap groups of cards in a single `GlassEffectContainer`** (see
  `CalculatorView.sections`). Multiple independent `.glassEffect` views without a
  container render inconsistently — glass adapts to the moving shader behind it,
  and cards visibly shift color when siblings resize/reflow. One container makes
  them render as a coordinated system. Use `spacing: 0` so separate cards don't
  blend into each other.
- **Never stack Liquid Glass on Liquid Glass.** A control inside a glass card must
  not add its own `.glassEffect` — the nested glass strobes light/dark against the
  animated background. Small controls (e.g. `HoldStepButton`) use
  `.background(.regularMaterial, in:)` instead: a stable frosted material that
  reads as glassy without the flicker.
- Native glass button styles (`.buttonStyle(.glass)`, `.glassProminent`) are fine
  for standalone buttons that sit directly on the shader, not inside a glass card.

## 2. Background — animated shader

- The calculator sits over `ShaderBackground`: a Metal stitchable "sandy gradient"
  (`Shaders.metal`) driven by `TimelineView(.animation)`, tinted by the current
  comfort zone's palette.
- The background is **fixed to the screen** (a `.background` on the scroll view);
  content scrolls over it. Retint transitions animate with
  `.animation(.smooth, value: zone)`.
- Keep the shader as the sole ambient motion. Glass cards read against it — don't
  add competing gradients or opaque fills that would hide it.

## 3. Color

- **Comfort zones are the color system.** `ComfortZone` owns the palette:
  - Comfortable → green · 😌 · calm sandy greens
  - Stretching → orange · 😬 · warm amber
  - Unhinged → red · 🤡 · hot clay
- Tint interactive accents (`Slider`, zone labels, active states) with
  `zone.tint`. Let the zone drive color; avoid introducing unrelated accent hues.
- **Theme-aware:** rely on semantic colors (`.primary`, `.secondary`,
  `.regularMaterial`) so light and dark both work. Never hardcode a light-only or
  dark-only color.

## 4. Typography

- **System fonts only, semantic sizes only.** Use `.largeTitle`, `.title2`,
  `.headline`, `.subheadline`, `.caption`, etc. **Never set explicit point sizes.**
- Hero numbers (the salary, price) use `.system(.largeTitle, design: .rounded)`
  bold — rounded gives the money its friendly, tactile feel.
- Secondary/context text is `.secondary`; captions are `.caption`/`.footnote`.
- Use `.monospacedDigit()` on stepper values so digits don't jitter as they change.

## 5. Motion & animation

- **Animate the interaction, not the value.** Do not attach
  `.animation(_:value:)` to a field whose value can be seeded on appear — it will
  play a spurious transition on load. Instead wrap the *interaction* in
  `withAnimation` (see `HoldStepButton.step()`), so the numeric roll only plays on
  a real tap/hold.
- **`.contentTransition(.numericText())`** on every changing number, so values
  roll rather than snap when animated by an interaction.
- **Pow** for delight:
  - `.changeEffect(.spray { … })` sprays money (`💵/💸/🤑`, count scaled by zone)
    when you tap the salary or cross a zone.
  - `.transition(.movingParts.blur)` for text that swaps (e.g. the roast).
  - Stepper buttons spray a `➕`/`➖` on release.
- Springs: `.snappy` for controls, `.smooth` for ambient/zone changes. Keep
  durations short and lively.

## 6. Haptics

Haptics are part of the feel — use `.sensoryFeedback` (no UIKit):

- `.impact(weight: .medium)` when the comfort **zone** changes.
- `.impact(weight: .light)` on stepper presses.
- `.selection` on reroll / discrete selections.
- Don't fire haptics on every continuous slider tick — gate to meaningful changes.

## 7. Layout & structure

- Sections stack vertically in a `ScrollView` with consistent section spacing;
  each section is a `GlassCard`.
- **Collapsible sections** use the shared `CollapsibleSection`: a glass card with a
  header (title + chevron that rotates `0° → -90°`) whose **entire header row is
  tappable** (`.contentShape(.rect)` inside a `.plain` button), toggling with
  `withAnimation(.snappy)` and a `.transition(.opacity)` on the body. Secondary
  sections (Sales tax) default collapsed.
- Reusable stepper pattern: `StepperControl` = `[ − ]  value  [ + ]` with a
  centered value that expands to fill; the buttons are `HoldStepButton`
  (tap = one step, hold = rapid repeat, spray on release).
- A calculated amount under a control (down payment $, interest $, tax $) can carry
  an `InfoButton` (`info.circle`) that presents a plain explanatory `.alert`.

## 8. Inputs

- Monetary/percentage entry uses `.keyboardType(.decimalPad)` and is sanitized
  through the shared `AmountSanitizer` (digits, one decimal separator, ≤2 fraction
  digits, locale-aware decimal key normalized to `.`).
- **Keyboards must be dismissable.** Provide a keyboard toolbar `Done` button
  (`ToolbarItemGroup(placement: .keyboard)`) and `.scrollDismissesKeyboard(.interactively)`.
  Decimal pads have no return key, so both are required.
- The price field auto-focuses ~0.5s after the calculator appears so the pad is
  ready without a tap.

## 9. Formatting & locale

- **Follow the device locale — never hardcode one.** Currency uses
  `.currency(code:)` and numbers use `.number.grouping(.automatic)`, both defaulting
  to `Locale.current`. Grouping/decimal marks and symbol placement are the user's
  regional convention (e.g. `$5,800,000` vs `5.800.000 $`).
- Percentages driving the comfort math are quantized to **whole numbers** — the
  value shown and the value used are always identical (no hidden decimals).

## 10. Code conventions (so the UI stays consistent)

- **MVVM + Observation.** `@Observable` view models and stores; inject stores via
  `@Environment`. Views are `@State`-owned view models.
- **Views contain only `body`.** Move subviews, helpers, and computed values into a
  `private extension` in the same file (or a shared component if reused).
- **File-local constants** live in a `private enum Constants` with `static let`.
  Prefer `.zero` over a magic `0`.
- **Small, composable components.** Extract shared UI (`GlassCard`, `StepperControl`,
  `HoldStepButton`, `CollapsibleSection`, `InfoButton`) rather than duplicating.
- **Default components and styles** so the app automatically picks up the latest
  Liquid Glass variants.
- Be deliberate about state writes to avoid needless re-renders (e.g. throttle
  continuous slider updates before they drive recomputation).
- Self-documenting code; comment only where intent isn't obvious.
