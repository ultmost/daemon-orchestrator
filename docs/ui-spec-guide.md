# UI-SPEC Guide

> Frontend work starts with a contract, not a blank canvas. This is the UI-SPEC.

---

## What Is a UI-SPEC?

A UI-SPEC.md is a lightweight written contract between you and the builder (Hermione) that defines what will be built before a single line of code is written.

It answers:
- What does each component/page look like?
- What states exist?
- How does it behave on different screen sizes?
- What accessibility requirements apply?

**Why it matters:** The biggest source of rework in frontend builds is underdefined scope. "Build a pricing page" produces wildly different results depending on what's in the builder's head. A UI-SPEC removes the ambiguity.

---

## When Is a UI-SPEC Required?

| Situation | UI-SPEC required? |
|-----------|------------------|
| New page from scratch | Yes |
| New feature section on existing page | Yes |
| New reusable component (card, modal, form) | Yes if complex |
| Bug fix (visual or logic) | No |
| Small style tweak (color, spacing, font) | No |
| Refactor without visual changes | No |
| Design already provided via Figma URL | Optional (Figma is the spec) |

**Rule of thumb:** If you'd be frustrated by the result being "not what I meant", write a UI-SPEC first.

---

## What a UI-SPEC Contains

### Required Sections

**1. Overview**
One paragraph describing the purpose and context of what's being built.

**2. Layout**
- Overall structure (sidebar? full-width? 2-column?)
- Breakpoints and how layout changes at each
- Grid or flex behavior

**3. Components**
For each component:
- Name and purpose
- Props/variants (e.g., `size: sm | md | lg`, `state: default | loading | error`)
- Visual description or ASCII wireframe

**4. States**
- Default / empty
- Loading
- Error
- Success
- Edge cases (very long text, no data, etc.)

**5. Responsiveness**
- Mobile (375px): what changes?
- Tablet (768px): what changes?
- Desktop (1280px+): base design

**6. Accessibility**
- ARIA labels needed
- Keyboard navigation requirements
- Color contrast requirements (WCAG AA minimum)

### Optional Sections

**7. Animations**
- Which elements animate?
- Trigger (hover, scroll, mount)?
- Duration and easing

**8. Design Tokens**
- Colors: use `--color-*` tokens or specific hex?
- Typography: which scale?
- Reference to DESIGN.md if available

**9. Open Questions**
Things you're unsure about that need a decision before or during build.

---

## UI-SPEC.md Template

Copy this into your project and fill it in:

```markdown
# UI-SPEC: [Component/Page Name]

**Date:** YYYY-MM-DD
**Builder:** Hermione
**Status:** Draft | Ready | Building | Done

---

## Overview

[One paragraph: what is this, where does it live, what does it do for the user?]

---

## Layout

- Structure: [describe overall layout]
- Mobile (375px): [how it looks/behaves]
- Tablet (768px): [how it looks/behaves]
- Desktop (1280px+): [base design]

---

## Components

### [Component Name]
- **Purpose:** [what it does]
- **Variants:** [list variants]
- **Wireframe:**
  ```
  [ASCII sketch or description]
  ```

---

## States

| State | Description | Visual |
|-------|-------------|--------|
| Default | Normal loaded state | [describe] |
| Loading | Data fetching | [describe] |
| Empty | No data | [describe] |
| Error | Failed state | [describe] |

---

## Responsiveness

| Breakpoint | Changes |
|-----------|---------|
| Mobile (375px) | [list changes] |
| Tablet (768px) | [list changes] |
| Desktop (1280px+) | Base design |

---

## Accessibility

- [ ] ARIA labels: [list which elements]
- [ ] Keyboard nav: [describe flow]
- [ ] Color contrast: WCAG AA minimum
- [ ] Focus states: visible on all interactive elements

---

## Animations (optional)

| Element | Trigger | Animation | Duration |
|---------|---------|-----------|----------|
| [element] | [hover/mount/scroll] | [describe] | [ms] |

---

## Design Tokens

- Colors: [reference DESIGN.md or list hex values]
- Typography: [scale reference]
- Spacing: [reference]

---

## Out of Scope

Explicitly list what this spec does NOT cover:
- [item]
- [item]

---

## Open Questions

- [ ] [Question that needs resolving before or during build]
```

---

## How It Connects to Hermione

When you invoke Hermione for a frontend task, she should:

1. Check if a `UI-SPEC.md` exists for the task
2. If yes: read it and treat it as the authoritative contract
3. If no (and the task is complex): ask you to fill one out first, or fill one out herself based on your description before coding
4. After building: verify output against each spec item and report any deviations

**Add this to your Hermione skill file** to enforce this behavior:

```markdown
## Pre-Build Gate
Before writing any component or page:
1. Check if UI-SPEC.md exists for this task
2. If task is NEW PAGE or NEW FEATURE: require UI-SPEC (create if missing)
3. If task is BUG FIX or SMALL TWEAK: proceed without spec
4. Announce which path you're taking
```

---

## Example: Pricing Page UI-SPEC

```markdown
# UI-SPEC: Pricing Page

**Date:** 2025-01-15
**Builder:** Hermione
**Status:** Ready

## Overview
Marketing pricing page with 3 tiers (Free, Pro, Enterprise). Lives at /pricing.
Goal: convert visitors to sign up for Pro. Primary CTA is "Start Free Trial".

## Layout
- Single column, centered, max-width 1100px
- Hero section → Pricing cards → FAQ → Final CTA

## Components

### PricingCard
- Variants: default | highlighted (Pro tier)
- Contains: tier name, price, billing period, feature list, CTA button
- Highlighted variant has border-primary and subtle background

### FeatureList
- Bulleted list with check icons (Lucide CheckCircle)
- Grayed-out items for unavailable features (with X icon)

## States
| State | Description |
|-------|-------------|
| Default | Monthly billing selected |
| Toggle: Annual | Prices update, "Save 20%" badge appears |

## Responsiveness
| Breakpoint | Changes |
|-----------|---------|
| Mobile (375px) | Cards stack vertically. FAQ accordion. |
| Tablet (768px) | 2 cards side by side. Enterprise below. |
| Desktop (1280px+) | 3 cards in a row. |

## Accessibility
- [ ] Toggle has aria-label "Switch to annual billing"
- [ ] Cards have role="article" with aria-label for tier name
- [ ] All CTAs have descriptive labels (not just "Click here")

## Out of Scope
- Payment flow (separate page)
- Enterprise contact form (links to Calendly)
```

---

## Integration with GSD Pipeline

In the GSD workflow, UI-SPEC.md is created during `gsd-discuss-phase` (or `gsd-plan-phase`) and consumed by `gsd-execute-phase` when it delegates to Hermione.

The pipeline becomes:
```
discuss-phase → UI-SPEC.md (written)
plan-phase    → PLAN.md references UI-SPEC sections as tasks
execute-phase → Hermione reads UI-SPEC, builds, verifies against it
verify-work   → Checks output against UI-SPEC acceptance criteria
```
