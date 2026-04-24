# Deck build — one-Markdown-per-slide -> HTML (+ optional PDF)
#
# Usage:
#   make          # build deck.html
#   make pdf      # also build deck.pdf
#   make clean
#   make watch

DECK_NAME ?= deck
SLIDES_DIR := slides
OUT_HTML  := $(DECK_NAME).html
OUT_PDF   := $(DECK_NAME).pdf

GENERATOR := ../build-deck.sh
CSS_SRC   := ../deck.css

MD_SLIDES := $(sort $(wildcard $(SLIDES_DIR)/*.md))

.PHONY: all pdf clean watch verify

all: $(OUT_HTML)

$(OUT_HTML): $(MD_SLIDES) $(GENERATOR) $(CSS_SRC)
	@test -L deck.css || ln -sf ../deck.css deck.css
	$(GENERATOR) $(SLIDES_DIR) $(OUT_HTML)

pdf: $(OUT_PDF)

$(OUT_PDF): $(OUT_HTML)
	@if command -v chromium >/dev/null; then \
	   chromium --headless --disable-gpu --no-sandbox \
	     --print-to-pdf=$(OUT_PDF) --no-pdf-header-footer \
	     "file://$$PWD/$(OUT_HTML)"; \
	 elif command -v google-chrome >/dev/null; then \
	   google-chrome --headless --disable-gpu \
	     --print-to-pdf=$(OUT_PDF) --no-pdf-header-footer \
	     "file://$$PWD/$(OUT_HTML)"; \
	 elif command -v wkhtmltopdf >/dev/null; then \
	   wkhtmltopdf --orientation Landscape --page-size A4 \
	     $(OUT_HTML) $(OUT_PDF); \
	 else \
	   echo "no PDF renderer (chromium / google-chrome / wkhtmltopdf). Open $(OUT_HTML) in a browser and Print-to-PDF." >&2; exit 1; \
	 fi
	@echo "built: $(OUT_PDF)"

clean:
	rm -f $(OUT_HTML) $(OUT_PDF) deck.css

verify:
	@echo "slides found: $(words $(MD_SLIDES))"
	@for f in $(MD_SLIDES); do echo "  $$f"; done

watch:
	@command -v inotifywait >/dev/null || { echo "install inotify-tools" >&2; exit 1; }
	@echo "watching $(SLIDES_DIR)/ — ctrl-c to stop"
	@while true; do \
	   inotifywait -qq -e modify,create,delete,move -r $(SLIDES_DIR); \
	   $(MAKE) --no-print-directory all; \
	 done
