# Montefish

Multilingual hosting proposal (EN / SR / RU). See `status.yaml`.

## Artifacts (ship-ready)

- [`PROPOSAL.html`](PROPOSAL.html) / [`PROPOSAL.md`](PROPOSAL.md)             — English
- [`PROPOSAL_SR.html`](PROPOSAL_SR.html) / `.md`  — Serbian
- [`PROPOSAL_RU.html`](PROPOSAL_RU.html) / `.md`  — Russian
- [`print.css`](print.css)                         — A4 print stylesheet

## Internal (never ship)

- `_internal/REALITY_ANALYSIS.md`

## Print

```bash
# Chromium headless PDF (keeps print CSS)
chromium --headless --disable-gpu --no-sandbox \
  --print-to-pdf=PROPOSAL.pdf --print-to-pdf-no-header \
  "file://$PWD/PROPOSAL.html"
```
