# Deck template — one Markdown file per slide

Copy this folder to a new location, edit the slides, run `make`.

## Files

```
template/
├── slides/
│   ├── 01-cover.md      ← first two-digit number controls order
│   ├── 02-problem.md
│   ├── 03-answer.md
│   ├── 04-stack.md
│   ├── 05-proof.md
│   └── 06-cta.md
├── Makefile             ← `make` builds deck.html, `make pdf` builds PDF
└── README.md
```

Expected neighbours (re-used, not copied):

```
../deck.css              ← shared stylesheet
../build-deck.sh         ← shared generator
```

## Slide file format

### YAML frontmatter (optional)

```markdown
---
class: cover        # or `cta`, or empty for default slide
kicker: "section label · small uppercase"
---
```

- `class: cover` → dark hero slide (use on first slide)
- `class: cta`   → blue gradient closing slide
- `kicker:` → small uppercase section label above the heading

### Body

Plain markdown after the frontmatter. Pandoc handles it:

- `# Title` becomes `h1` (use on `cover` and `cta` only)
- `## Heading` becomes `h2` (use on every interior slide)
- Tables, lists, code blocks, images all work
- Each file = one slide, no horizontal-rule separators needed

## Build

```bash
make          # builds ./deck.html
make pdf      # also builds ./deck.pdf (requires chromium or wkhtmltopdf)
make clean    # removes built artifacts
make watch    # rebuilds on slide edits (requires inotifywait)
```

## Style rules

See `~/.docs/00-standards/VOICE.md`. Keep slides:

- one idea per slide
- ≤ 40 words of body text
- tables when comparing facts
- no exclamation marks
- no emojis in client-facing decks

## Copy this template

```bash
cp -r ~/.github/projects/qui3tly.cloud/presentation/template \
      ~/.github/projects/clients/<slug>/deck
cd !$
# edit slides/, then:
make
```
