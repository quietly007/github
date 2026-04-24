# qui3tly.cloud deck system

Two decks live in this folder:

| Path | Purpose |
|------|---------|
| [`deck.html`](deck.html) + [`deck.css`](deck.css) | **The qui3tly.cloud sales deck** — 12 slides, hand-built, canonical. |
| [`template/`](template/) | **Reusable deck generator** — Markdown-per-slide → HTML via Pandoc. Use for client decks. |

## The qui3tly.cloud sales deck

Open [`deck.html`](deck.html) in any browser. `Cmd/Ctrl + P` for A4-landscape print.

Render to PDF:

```bash
chromium --headless --disable-gpu --no-sandbox \
  --print-to-pdf=qui3tly-cloud-deck.pdf --no-pdf-header-footer \
  "file://$PWD/deck.html"
```

Or from macOS: open in Chrome/Safari → File → Print → Save as PDF → A4, landscape, no margins.

## The deck generator (reusable)

One Markdown file per slide. Pandoc assembles them into an HTML deck that reuses `deck.css`.

```bash
# Start a new deck (e.g. for a client)
cp -r template ~/.github/projects/clients/<slug>/deck
cd !$
# Edit slides/ — one .md per slide, name them 01-*.md, 02-*.md, ...
make                # builds deck.html
make pdf            # builds deck.pdf (needs chromium)
make watch          # rebuild on save (needs inotify-tools)
```

See [`template/README.md`](template/README.md) for the full spec:
- frontmatter (`class:`, `kicker:`)
- style rules (from `~/.docs/00-standards/VOICE.md`)
- how to add images, tables, ASCII diagrams

## Shared assets

| File | Purpose |
|------|---------|
| [`deck.css`](deck.css)         | Stylesheet — screen + A4-landscape print. One source of truth. |
| [`build-deck.sh`](build-deck.sh) | Generator — Markdown-per-slide → HTML. |

**Do not** fork `deck.css` per-client. Derive a client theme by adding **one** `client.css` override after it:

```html
<link rel="stylesheet" href="deck.css" />
<link rel="stylesheet" href="client.css" />
```

## Writing discipline

All prose in any deck must follow [`~/.docs/00-standards/VOICE.md`](~/.docs/00-standards/VOICE.md):

- short sentences
- numbers before adjectives
- no hype words
- no exclamation marks
- no emojis in ship-ready material

## Slide index (the qui3tly.cloud deck)

| # | Title |
|---|-------|
| 01 | Cover — qui3tly.cloud one-liner |
| 02 | The problem — US SaaS rent, sovereignty loss |
| 03 | What qui3tly.cloud is — 3 pillars |
| 04 | The stack — 8 capabilities |
| 05 | Architecture — ASCII topology |
| 06 | Live proof points |
| 07 | Six reasons we're different |
| 08 | Fit / no-fit |
| 09 | Engagement model |
| 10 | References |
| 11 | Governance |
| 12 | CTA — hello@quietly.online |
