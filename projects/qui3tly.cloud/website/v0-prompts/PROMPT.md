# v0.dev prompt — qui3tly.cloud landing page

> Paste the **Instructions** block below into v0.dev. Then, when it asks for content, paste each `copy/*.md` section when prompted for that section.

---

## Instructions

Build a single-page landing site for **qui3tly.cloud** — the self-hosted private cloud service operated by **quietly IT Solutions**. — a sovereign, self-hosted private cloud (mail, files, office, identity, monitoring) for small businesses and independent professionals in Europe. Footer must credit the operator: 'operated by quietly IT Solutions'.

### Stack

- Next.js App Router (single page, `app/page.tsx`)
- Tailwind CSS with CSS variables
- shadcn/ui components where natural
- No external JS libraries beyond the above
- Accessible: every section has a proper `<section>`, every heading is in order, contrast ≥ 4.5:1, focus rings visible

### Brand tokens (exact values — extracted from actual quietly logos)

```css
--ink:          #2a2a2a   /* charcoal — primary text */
--ink-soft:     #4a4a4a
--muted:        #7a7a7a
--line:         #d4d4d4
--paper:        #f5f5f4   /* warm off-white page bg */
--panel:        #e5e5e3   /* panel / card grey */
--panel-dark:   #3a3a38   /* dark GREY hero bg — NEVER pure black */
--panel-deep:   #2a2a28
--accent:       #90c020   /* brand olive-lime (line art color) */
--accent-deep:  #6a8f18   /* darker olive */
--accent-hi:    #78f000   /* bright lime — highlights only, sparingly */
--accent-tint:  #c0d090   /* sage tint (from logo panel) */
```

**Palette rationale**: the qui3tly.cloud brand is **olive-lime green line-art on warm grey**. Hero and CTA backgrounds are **charcoal grey (`#3a3a38`), never pure black**. Use the brighter `--accent-hi` lime (#78f000) sparingly — for CTA buttons, live-metric numbers, and active-link underlines only. The olive (#90c020) is the default accent. Everything else is warm greys and off-whites.

Fonts: `Inter` (sans) + `ui-monospace` (mono). Use monospace for numbers-in-metric cards, kickers, and footer.

### Logo

- Primary (for white/light backgrounds): `assets/logo-black.jpg` — lockup in black
- Negative (for dark/accent backgrounds): `assets/logo-negative.png` — lockup in white + lime
- Mark only (vector, recolor with `currentColor`): `assets/logo-mark.svg`  (raster fallback: `logo-mark.png`)
- Favicon: `assets/favicon-32.jpg` / `assets/apple-touch-icon.jpg`

Use the **negative** lockup on the hero (dark background) and the **primary** lockup on the nav bar (light background). Do not recolor or restyle the logo.

### Layout

Single page, 8 sections in this order:

1. **Hero** — dark grey gradient (`from-[#3a3a38] via-[#2a2a28] to-[#1e2a14]`) — NEVER pure black. Place the `logo-mark.svg` top-left, wordmark 'qui3tly.cloud' next to it (white text, with lime #78f000 dot before 'cloud'). Large headline, one-line subtitle, primary CTA button (goes to `mailto:hello@quietly.online`), small monospace stats line at bottom.
2. **Problem** — white. Five-bullet list of customer pains. Closes with a one-line "There is a third option" in muted italic.
3. **Solution** — white. Heading, 2-line intro paragraph, then a **three-column card grid** (Sovereign / Accountable / Transparent) each with a short paragraph.
4. **Stack** — soft paper background. Heading, then an **8-row table** of capabilities (3 columns: Capability / Powered by / Access at). Monospace for "Access at" column.
5. **Proof** — dark section or distinctive background. **Eight metric cards** in a 4×2 grid, each card: huge monospace number + small uppercase label under it. At the bottom, one sentence + link to the live status page.
6. **Engagement** — white. Heading, **5-row table** of stages (Stage / Duration / What happens).
7. **Governance** — paper background. Heading, intro line, **7-item ordered list** of the workflow steps (large numbers), then a small 5-bullet "Clients get:" list.
8. **CTA** — sage-to-olive gradient (`from-[#c0d090] via-[#90c020] to-[#6a8f18]`). Dark charcoal text (#2a2a2a). One-line body. Large pill-shaped CTA with `mailto:` link. Small monospace version-line below.

### Typography rules

- No emoji.
- No exclamation marks.
- All tables left-aligned.
- Numerals for numbers ≥ 10, words for 0–9 (already followed in copy; keep it).
- Headings sentence-case (first word capitalized, nothing else).

### Content

Content is supplied in 8 Markdown files named `01-hero.md` through `08-cta.md` (see `copy/` folder). **Use them verbatim.** Do not rewrite, do not add taglines, do not add features that aren't in the copy.

### Delivery

- Single `app/page.tsx` plus `app/globals.css` with the brand tokens.
- No client-side JS unless strictly necessary.
- Build should work with `pnpm build && pnpm start`.
- OG card: `assets/og.png` (1200×630, pre-rendered) — set `og:image` to it. Title/description from `copy/meta.yaml`.

### Do NOT

- Add testimonials we don't have.
- Invent customer logos.
- Use stock illustrations.
- Add a newsletter signup.
- Add animations beyond a subtle fade-in on scroll.
- Use any word from this list: *revolutionary, cutting-edge, leverage, seamless, unlock, empower, game-changing, next-gen, AI-powered*.

### Final check

Before returning the code, verify:

- Every one of the 8 sections is present.
- The CTA button appears in both the hero and the final section.
- The mailto link is exactly `mailto:hello@quietly.online`.
- The page renders correctly at `375px`, `768px`, and `1440px` widths.
