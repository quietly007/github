# v0.dev prompt — qui3tly.cloud landing page

> Paste the **Instructions** block below into v0.dev. Then, when it asks for content, paste each `copy/*.md` section when prompted for that section.

---

## Instructions

Build a single-page landing site for **qui3tly.cloud** — a sovereign, self-hosted private cloud service (mail, files, office, identity, monitoring) for small businesses and independent professionals in Europe.

### Stack

- Next.js App Router (single page, `app/page.tsx`)
- Tailwind CSS with CSS variables
- shadcn/ui components where natural
- No external JS libraries beyond the above
- Accessible: every section has a proper `<section>`, every heading is in order, contrast ≥ 4.5:1, focus rings visible

### Brand tokens (exact values)

```css
--ink:         #0f172a
--ink-soft:    #334155
--muted:       #64748b
--line:        #e2e8f0
--paper:       #fafaf9
--accent:      #0ea5e9
--accent-deep: #0369a1
--green:       #16a34a
```

Fonts: `Inter` (sans) + `ui-monospace` (mono). Use monospace for numbers-in-metric cards, kickers, and footer.

### Layout

Single page, 8 sections in this order:

1. **Hero** — dark gradient (`from-[#0f172a] via-[#1e293b] to-[#0369a1]`). Large headline, one-line subtitle, primary CTA button (goes to `mailto:hello@quietly.online`), small monospace stats line at bottom.
2. **Problem** — white. Five-bullet list of customer pains. Closes with a one-line "There is a third option" in muted italic.
3. **Solution** — white. Heading, 2-line intro paragraph, then a **three-column card grid** (Sovereign / Accountable / Transparent) each with a short paragraph.
4. **Stack** — soft paper background. Heading, then an **8-row table** of capabilities (3 columns: Capability / Powered by / Access at). Monospace for "Access at" column.
5. **Proof** — dark section or distinctive background. **Eight metric cards** in a 4×2 grid, each card: huge monospace number + small uppercase label under it. At the bottom, one sentence + link to the live status page.
6. **Engagement** — white. Heading, **5-row table** of stages (Stage / Duration / What happens).
7. **Governance** — paper background. Heading, intro line, **7-item ordered list** of the workflow steps (large numbers), then a small 5-bullet "Clients get:" list.
8. **CTA** — blue gradient (accent → accent-deep). Large heading. One-line body. Large pill-shaped CTA with `mailto:` link. Small monospace version-line below.

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
- OG card reads: `og_title + og_description` from `copy/meta.yaml`.

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
