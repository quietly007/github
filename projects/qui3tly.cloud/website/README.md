# qui3tly.cloud — website

Source of truth for the marketing site. **Not yet deployed** — this folder holds copy, prompts, and build artifacts so whichever framework we pick (v0, Astro, plain HTML) is fed from the same inputs.

## Folder layout

```
website/
├── README.md            ← this file
├── copy/                ← section-by-section copy in Markdown
│   ├── 01-hero.md
│   ├── 02-problem.md
│   ├── 03-solution.md
│   ├── 04-stack.md
│   ├── 05-proof.md
│   ├── 06-engagement.md
│   ├── 07-governance.md
│   ├── 08-cta.md
│   └── meta.yaml        ← page title, description, OG tags, links
├── assets/              ← static images, favicon, OG card source
├── v0-prompts/          ← prompts for v0.dev / Lovable / Bolt
│   ├── PROMPT.md
│   └── ITERATIONS.md
└── build/               ← generated output (v0 export, Astro build, etc.)
```

## Workflow

### Option A — v0.dev (fastest, recommended first pass)

1. Read [`v0-prompts/PROMPT.md`](v0-prompts/PROMPT.md).
2. Paste it into [v0.dev](https://v0.dev).
3. Iterate in v0; save each iteration's description into [`ITERATIONS.md`](v0-prompts/ITERATIONS.md).
4. Export to `build/v0-<date>/` and deploy from there.

### Option B — hand-rolled Astro (when we outgrow v0)

1. `build/astro/` — scaffold with `pnpm create astro@latest`.
2. Import `copy/*.md` directly; Astro renders them.
3. Use `deck.css` tokens as the theme base (`--ink`, `--accent`, `--paper`).

### Option C — plain HTML (fallback)

1. Run Pandoc over `copy/*.md` in order.
2. Wrap with the same CSS palette as the deck.
3. Upload to any static host.

## Writing discipline

All copy follows [`~/.docs/00-standards/VOICE.md`](~/.docs/00-standards/VOICE.md). Each `copy/*.md` is **one section**. Keep every section:

- one clear idea
- ≤ 80 words of body text
- numbers-before-adjectives
- tables over prose paragraphs when comparing

## Status

**Not deployed.** Copy drafted 2026-04-24. v0 prompt drafted. DNS / hosting decision pending.

When we deploy, update:
- this README (status, deployment URL, deploy command)
- `~/.docs/SYSTEM_OF_RECORD.md` (add `www.quietly.online` or chosen FQDN to domain table)
- `~/.docs/01-architecture/CCIE_TOPOLOGY.md` (add to FQDN → service table)
