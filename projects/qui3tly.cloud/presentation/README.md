# qui3tly.cloud sales deck

A self-contained, standalone HTML sales deck. 12 slides, A4 landscape print-ready.

## Files

| File | Purpose |
|------|---------|
| [`deck.html`](deck.html) | The deck. Open in any modern browser. |
| [`deck.css`](deck.css)   | Screen + print styles (A4 landscape, one slide per page). |

## View

Open `deck.html` in any browser. Use **Ctrl/Cmd + P** to preview print layout — the CSS automatically switches to A4 landscape, one slide per page, with page numbers in the bottom-right corner.

## Render to PDF (A4 landscape)

### With Chromium / Chrome (recommended)

```bash
chromium --headless --disable-gpu --no-sandbox \
  --print-to-pdf=qui3tly-cloud-deck.pdf \
  --print-to-pdf-no-header \
  --no-pdf-header-footer \
  "file://$PWD/deck.html"
```

### With Firefox

```bash
firefox --headless --print qui3tly-cloud-deck.pdf "file://$PWD/deck.html"
```

### From macOS (no headless Chrome needed)

Open `deck.html` in Safari or Chrome → **File > Print → Save as PDF**. Choose **A4, landscape, no margins**.

## Slide index

| # | Title |
|---|-------|
| 01 | Cover — qui3tly.cloud one-liner |
| 02 | The problem — US SaaS rent, sovereignty loss |
| 03 | What qui3tly.cloud is — sovereign, accountable, transparent |
| 04 | The stack — eight capabilities |
| 05 | Architecture — 2 hosts, 5 planes, live topology |
| 06 | Live proof points (2026-04-24 snapshot) |
| 07 | Six reasons we're different |
| 08 | Fit / no-fit |
| 09 | Engagement model — 5 stages |
| 10 | References — Norma live, Montefish proposal |
| 11 | Governance — 7-step change workflow |
| 12 | CTA — hello@quietly.online |

## Update discipline

- Numbers on slide 06 are live-snapshot values. When they materially change, update them and bump `data-n` / meta line.
- The ASCII topology on slide 05 is a **schematic** of `CCIE_TOPOLOGY.md` — if the canonical topology changes, update this too.
- Version in meta line (cover slide) reflects the deck's rev, not the infrastructure.
