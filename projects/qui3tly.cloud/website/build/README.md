# build/

Generated outputs live here. Do not hand-edit.

Subfolders will be one of:

- `v0-YYYYMMDD-NN/` — v0.dev export
- `astro/`          — Astro project (if we go that route)
- `pandoc/`         — plain HTML from `copy/*.md` (fallback)

Each deployment should have its own folder so we can A/B or roll back.
